local options = {
	backup = false,
	clipboard = "unnamedplus",
	cmdheight = 2,
	colorcolumn = "101",
	expandtab = true,
	hlsearch = true,
	ignorecase = true,
	incsearch = true,
	number = true,
	relativenumber = true,
	scrolloff = 8,
	shiftwidth = 4,
	showmode = false,
	smartcase = true,
	smartindent = true,
	softtabstop = 4,
	splitbelow = true,
	splitright = true,
	swapfile = false,
	tabstop = 4,
	termguicolors = true,
	undofile = true,
	writebackup = false,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end
