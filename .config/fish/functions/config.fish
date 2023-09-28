function config --wraps='/usr/bin/git --git-dir=/home/steffeno/.local/share --work-tree=/home/steffeno' --wraps='/usr/bin/git --git-dir=/home/steffeno/.local/share/dotfiles --work-tree=/home/steffeno' --description 'alias config=/usr/bin/git --git-dir=/home/steffeno/.local/share/dotfiles --work-tree=/home/steffeno'
  /usr/bin/git --git-dir=/home/steffeno/.local/share/dotfiles --work-tree=/home/steffeno $argv
        
end
