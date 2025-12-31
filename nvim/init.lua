-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
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
vim.opt.rtp:prepend(lazypath)

-- Basic Settings
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Basic
vim.opt.listchars = { eol = '$', tab = '>-', trail = '·', extends = '❯', precedes = '❮' }
vim.opt.fillchars = { diff = '⣿', vert = '│' }
vim.opt.virtualedit = 'block'

vim.opt.number = true
vim.opt.relativenumber = true

-- Fix the clipboard
vim.opt.clipboard = 'unnamedplus'

-- ultisnips
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<c-b>"
vim.g.UltiSnipsJumpBackwardTrigger = "<c-z>"

-- vim-bookmarks
vim.g.bookmark_sign = '⚑'
vim.g.bookmark_annotation_sign = '#'
vim.g.bookmark_save_per_working_dir = 0
vim.g.bookmark_auto_save = 1
vim.g.bookmark_auto_save_file = vim.fn.expand('$HOME') .. '/.vim-bookmarks'
vim.g.bookmark_auto_close = 0
vim.g.bookmark_highlight_lines = 0
vim.g.bookmark_show_warning = 1
vim.g.bookmark_center = 1

vim.g.indent_guides_auto_colors = 0
vim.g.indent_guides_start_level = 0
vim.g.indent_guides_guide_size = 1

-- Plugins
require("lazy").setup({
  -- UI and appearance
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },

  -- Git
  { 'tpope/vim-fugitive' },
  { 'airblade/vim-gitgutter' },

  -- Utilities
  { 'sjl/gundo.vim' },
  { 'benekastah/neomake' },
  { 'Lokaltog/vim-easymotion' },
  { 'justinmk/vim-sneak' },
  { 'tomtom/tcomment_vim' },
  { 'godlygeek/tabular' },
  { 'tpope/vim-surround' },
  { 'kshenoy/vim-signature' },
  { 'luochen1990/rainbow' },
  { 'tpope/vim-repeat' },
  { 'wellle/targets.vim' },

  -- Language support
  { 'LnL7/vim-nix' },
  { 'rust-lang/rust.vim' },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- Fuzzy search
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- or if using mini.icons/mini.nvim
    -- dependencies = { "nvim-mini/mini.icons" },
    ---@module "fzf-lua"
    ---@type fzf-lua.Config|{}
    ---@diagnostics disable: missing-fields
    opts = {}
    ---@diagnostics enable: missing-fields
  },
  {
    'mikesmithgh/kitty-scrollback.nvim',
    enabled = true,
    lazy = true,
    cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackGenerateCommandLineEditing' },
    event = { 'User KittyScrollbackLaunch' },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    version = '^6.0.0', -- pin major version, include fixes and features that do not have breaking changes
  },

  -- Colorschemes
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "polirritmico/monokai-nightasty.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "tiagovla/tokyodark.nvim",
    opts = {
        -- custom options here
    },
  },
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    lazy = false,
    opts = {style = "warmer"},
  },
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration

      -- -- Only one of these is needed.
      -- "nvim-telescope/telescope.nvim", -- optional
      -- "ibhagwan/fzf-lua",              -- optional
      -- "nvim-mini/mini.pick",           -- optional
      -- "folke/snacks.nvim",             -- optional
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
    }
  },
})

-- Use Enter as colon
vim.keymap.set('n', '<CR>', ':')

-- Replace Esc for fd
vim.keymap.set('i', 'fd', '<Esc>')

-- Star search in visual mode
vim.keymap.set('v', '*', '"ty/<C-R>t<CR>')

-- Fix override triggering paste
vim.keymap.set('x', 'p', 'P')
-- Telescope mappings
vim.keymap.set('n', '<leader>ff', FzfLua.files, {desc = "Fuzzy find files"})
vim.keymap.set('n', '<leader>fr', FzfLua.resume, {desc = "Resume latest fuzzy search"})
vim.keymap.set('n', '<leader>fg', FzfLua.live_grep, {desc = "Fuzzy find using grep"})
vim.keymap.set('n', '<leader>fb', FzfLua.buffers, {desc = "Fuzzy find buffer"})
vim.keymap.set('n', '<leader>fh', FzfLua.help_tags, {desc = "Fuzzy find help"})

-- Set Y to como se debe
vim.keymap.set('n', 'H', '^')
vim.keymap.set('n', 'L', '$')
vim.keymap.set('n', 'Y', 'y$')
vim.keymap.set('n', 'K', '<nop>')

-- Tabs navigation
vim.keymap.set('n', '<leader>b', vim.cmd.bprevious)
vim.keymap.set('n', '<leader>n', vim.cmd.bnext)
vim.keymap.set('n', '<leader>d', vim.cmd.bdelete)

-- Forgot to sudo
vim.api.nvim_create_user_command('W', 'w !sudo tee % > /dev/null', {})


-- Move blocks of text around
vim.keymap.set('n', '<C-j>', ':m+<CR>==')
vim.keymap.set('n', '<C-k>', ':m-2<CR>==')
vim.keymap.set('n', '<C-h>', '<<')
vim.keymap.set('n', '<C-l>', '>>')
vim.keymap.set('i', '<C-j>', '<Esc>:m+<CR>==gi')
vim.keymap.set('i', '<C-k>', '<Esc>:m-2<CR>==gi')
vim.keymap.set('i', '<C-h>', '<Esc><<`]a')
vim.keymap.set('i', '<C-l>', '<Esc>>>`]a')
vim.keymap.set('v', '<C-j>', ":m'>+<CR>gv=gv")
vim.keymap.set('v', '<C-k>', ':m-2<CR>gv=gv')
vim.keymap.set('v', '<C-h>', '<gv')
vim.keymap.set('v', '<C-l>', '>gv')

require("fzf-lua").setup()

vim.cmd.colorscheme "onedark"

require('lualine').setup()

