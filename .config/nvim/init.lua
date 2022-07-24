-- Load Plugins
require('plugins')
-- Load keymap
require('keymap')
-- Load autocmds
require('autocmd')


vim.cmd("source ~/.config/nvim/annoyances.vim")

-------------------------------------
-- Plugin Settings

-- Rainbow
vim.g.rainbow_active = 1
-- Airline
vim.g.airline_powerline_fonts = 1
-------------------------------------

vim.opt.number=true
vim.opt.linespace=0
vim.opt.tabstop=4
vim.opt.softtabstop=4
vim.opt.shiftwidth=4
vim.opt.expandtab=true
vim.opt.autoindent=true
vim.opt.fileformat=unix
vim.opt.background=dark
vim.opt.pastetoggle='<F3>'
vim.opt.history=1000
vim.opt.showmode=true
vim.opt.cursorline=true
vim.opt.ruler=true
vim.opt.rulerformat='%30(%=:b%n%y%m%r%w %l,%c%V %P%)'
vim.opt.showcmd=true
vim.opt.backspace='indent,eol,start'

vim.opt.showmatch=true
vim.opt.incsearch=true
vim.opt.hlsearch=true
vim.opt.ignorecase=true
vim.opt.smartcase=true
vim.opt.wildmenu=true
vim.opt.wildmode='list:longest,full'
vim.opt.whichwrap='b,s,h,l,<,>,[,]'
vim.opt.scrolljump=5
vim.opt.scrolloff=3
vim.opt.foldenable=true
vim.opt.list=true
vim.opt.listchars='tab:› ,trail:•,extends:#,nbsp:.'

vim.opt.autoindent=true
vim.opt.shiftwidth=4
vim.opt.tabstop=4
vim.opt.splitright=true
vim.opt.splitbelow=true

vim.opt.spelllang=en_us