-- Initial LUA Config file for neovim
-- Simple start taken from - https://vonheikemen.github.io/devlog/tools/simple-neovim-config/

--Basic Vim configuration options

vim.o.guicursor = "" -- set cursor to block at all times

vim.o.number = true --Line Numbers
vim.o.relativenumber = true

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true -- use spaces instead of tabs
vim.o.softtabstop = 4

vim.o.autoindent = true -- enable autoindent based on last line
vim.o.wrap = false -- disable line wrapping

vim.o.smartcase = true -- ignore case when search pattern is all lowercase
vim.o.ignorecase = true

vim.o.hlsearch = false --clear search highlights after submit
vim.o.incsearch = true

vim.o.scrolloff = 8
vim.o.isfname = vim.o.isfname .. ",@-@"
vim.o.signcolumn = 'yes' --reserve a space in the gutter for signs. Some plugins use this to show icons
vim.o.termguicolors = true

vim.o.updatetime = 50

vim.o.colorcolumn = "80"

--vim backups
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv("HOME") .. "./vim.undodir"

--Clipboard interaction
 
-- Keybinds for system clipboard copy paste

vim.keymap.set({'n', 'x'}, 'gy', '"+y', {desc = 'Copy to clipboard'})
vim.keymap.set({'n', 'x'}, 'gp', '"+p', {desc = 'Paste clipboard text'})

-- Note read article again about leaders and whether that's going to be important
vim.g.mapleader = vim.keycode('<Space>')

vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', {desc = 'Save file'})

-- Plugins 

-- Mini Install - https://github.com/nvim-mini/mini.nvim - Collection of small no depedency plugins for nvim

vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

require('mini.files').setup({})
vim.keymap.set('n', '<leader>e', '<cmd>lua MiniFiles.open()<cr>', {desc = 'File explorer'})

require('mini.pick').setup({})
vim.keymap.set('n', '<leader><space>', '<cmd>Pick buffers<cr>', {desc = 'Search open files'})
vim.keymap.set('n', '<leader>ff', '<cmd>Pick files<cr>', {desc = 'Search all files'})
vim.keymap.set('n', '<leader>fh', '<cmd>Pick help<cr>', {desc = 'Search help tags'})


require('mini.snippets').setup({})
require('mini.completion').setup({})

-- Rose Pine Theme install
vim.pack.add({
    {
        src = "https://github.com/rose-pine/neovim",
        name = "rose-pine",
    },
})
require("rose-pine").setup()

--Theme stuff?

local ok_theme =  pcall(vim.cmd.colorscheme, 'rose-pine')
if not ok_theme then
	vim.cmd.colorscheme('habamax')
end
