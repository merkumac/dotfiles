local opt = vim.opt

-- numbers
opt.number = true 
opt.relativenumber = true

-- whitespace
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Serch setup
opt.incsearch = true          -- incremental search
opt.ignorecase = true         -- case-insensitive search
opt.smartcase = true          -- unless the pattern I look for has uppercase

opt.clipboard = "unnamedplus" -- integrate system clipboard

opt.wrap = false
opt.swapfile = false
opt.termguicolors = true
opt.undofile = true
opt.incsearch = true
opt.signcolumn = "yes"
opt.cursorline = true

local map = vim.keymap.set
vim.g.mapleader = " "


-- [[ Install `lazy.nvim` plugin manager ]]
--  This one is taken from the `https://lazy.folke.io/installation`
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo =  'https://github.com/folke/lazy.nvim.git'
    local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

opt.rtp:prepend(lazypath)

-- Actually require Lazy, so it gets loaded
require("lazy").setup({})

-- This one I took from Vimothy, for sourcing the init.lua, during development
map('n', '<leader>o', ':update<CR> :source<CR>')
