#include <stdio.h>
#include <assert.h>
#include <signal.h>
#include <pulse/pulseaudio.h>

typedef struct {
    pa_mainloop *mainloop;
    pa_mainloop_api *mainloop_api;
    pa_context *context;
    pa_signal_event *signal;
} PulseAudio;

int pulse_audio_init(PulseAudio *p);
int pulse_audio_run(PulseAudio *p);
void pulse_audio_quit(PulseAudio *p, int ret);
void pulse_audio_destroy(PulseAudio *p);
void exit_signal_callback(pa_mainloop_api *api, pa_signal_event *e, int sig, void *userdata);
void context_state_callback(pa_context *c, void *userdata);
void subscribe_callback(pa_context *c, pa_subscription_event_type_t type, uint32_t idx, void *userdata);
void sink_info_callback(pa_context *c, const pa_sink_info *i, int eol, void *userdata);
void server_info_callback(pa_context *c, const pa_server_info *i, void *userdata);

/*
 * Initializes state and connects to the PulseAudio server.
 */
int pulse_audio_init(PulseAudio *p) {
    p->mainloop = NULL;
    p->mainloop_api = NULL;
    p->context = NULL;
    p->signal = NULL;

    int ret = 0;

    if (!(p->mainloop = pa_mainloop_new())) {
        ret = -1;
        goto cleanup;
    }
    p->mainloop_api = pa_mainloop_get_api(p->mainloop);

    if (pa_signal_init(p->mainloop_api) != 0) {
        ret = -1;
        goto cleanup;
    }
    if (!(p->signal = pa_signal_new(SIGINT, exit_signal_callback, p))) {
        ret = -1;
        goto cleanup;
    }
    signal(SIGPIPE, SIG_IGN);

    if (!(p->context = pa_context_new(p->mainloop_api, NULL))) {
        ret = -1;
        goto cleanup;
    }
    if (pa_context_connect(p->context, NULL, PA_CONTEXT_NOAUTOSPAWN, NULL) < 0) {
        ret = -1;
        goto cleanup;
    }
    pa_context_set_state_callback(p->context, context_state_callback, p);

cleanup:
    if (ret != 0) {
      pulse_audio_destroy(p);
    }
    return ret;
}

/*
 * Deallocates PulseAudio objects (before terminating the program)
 */
void pulse_audio_destroy(PulseAudio *p) {
    if (p->context) {
      pa_context_unref(p->context);
      p->context = NULL;
    }
    if (p->signal) {
        pa_signal_free(p->signal);
        pa_signal_done();
        p->signal = NULL;
    }
    if (p->mainloop) {
        pa_mainloop_free(p->mainloop);
        p->mainloop = NULL;
        p->mainloop_api = NULL;
    }
}

/*
 * Runs the main PulseAudio event loop. Calling quit will cause the event
 * loop to exit.
 */
int pulse_audio_run(PulseAudio *p) {
    int ret;
    pa_mainloop_run(p->mainloop, &ret);
    return ret;
}

/*
 * Quits the main loop with return code `ret`
 */
void pulse_audio_quit(PulseAudio *p, int ret) {
    p->mainloop_api->quit(p->mainloop_api, ret);
}

/*
 * Called on SIGINT
 */
void exit_signal_callback(pa_mainloop_api *api, pa_signal_event *e, int sig, void *userdata) {
  (void)api;
  (void)e;
  (void)sig;
  if (userdata) {
      pulse_audio_quit(userdata, EXIT_SUCCESS);
  }
}

/*
 * Called whenever the context status changes
 */
void context_state_callback(pa_context *c, void *userdata) {
    PulseAudio *p = userdata;
    assert(c && p);

    pa_operation *op;
    switch (pa_context_get_state(c)) {
        case PA_CONTEXT_CONNECTING:
        case PA_CONTEXT_AUTHORIZING:
        case PA_CONTEXT_SETTING_NAME:
          break;
        case PA_CONTEXT_READY:
            if ((op = pa_context_get_server_info(c, server_info_callback, p))) {
                pa_operation_unref(op);
            }
            pa_context_set_subscribe_callback(c, subscribe_callback, p);
            if ((op = pa_context_subscribe(c, PA_SUBSCRIPTION_MASK_SINK | PA_SUBSCRIPTION_MASK_SERVER, NULL, NULL))) {
                pa_operation_unref(op);
            }
            break;
        case PA_CONTEXT_TERMINATED:
            pulse_audio_quit(p, EXIT_SUCCESS);
            break;
        case PA_CONTEXT_FAILED:
        default:
            pulse_audio_quit(p, EXIT_FAILURE);
    }
}

/*
 * Called when an event we subscribed to occurs.
 */
void subscribe_callback(pa_context *c, pa_subscription_event_type_t type, uint32_t idx, void *userdata) {
    unsigned facility = type & PA_SUBSCRIPTION_EVENT_FACILITY_MASK;

        
    pa_operation *op;
    switch(facility) {
        case PA_SUBSCRIPTION_EVENT_SERVER:
        case PA_SUBSCRIPTION_EVENT_SINK:
            if ((op = pa_context_get_sink_info_by_index(c, idx, sink_info_callback, userdata))) {
                pa_operation_unref(op);
            }
            break;
        default:
            assert(0); // got unexpected event
            break;
    }
}

/*
 * Called when the requested sink information is ready.
 */
void sink_info_callback(pa_context *c, const pa_sink_info *i, int eol, void *userdata) {
    (void)c;
    (void)eol;
    (void)userdata;
    if (i) {
        float vol = (float)pa_cvolume_avg(&(i->volume)) / (float)PA_VOLUME_NORM;
        printf("%.0f%%%s\n", vol * 100.0, i->mute ? " (muted)" : "");
        fflush(stdout);
    }
}

/*
 * Called when the requested information on the server is ready. This is
 * used to find the default PulseAudio sink.
 */
void server_info_callback(pa_context *c, const pa_server_info *i, void *userdata) {
    pa_operation *op;
    if ((op = pa_context_get_sink_info_by_name(c, i->default_sink_name, sink_info_callback, userdata))) {
        pa_operation_unref(op);
    }
}

int main() {
    int ret;
    PulseAudio p;
    if (pulse_audio_init(&p) < 0)  {
        ret = EXIT_FAILURE;
        goto exit;
    }
    ret = pulse_audio_run(&p);
    pulse_audio_destroy(&p);
exit:
    return ret;
}
