-- Settings
local opt = vim.opt

opt.scrolloff = 4
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.termguicolors = true
opt.clipboard = 'unnamedplus'

opt.number = true
opt.relativenumber = true

--opt.statuscolumn = "%s %{v:lnum} %{v:relnum} "
-- ⟹    ➤
--opt.statuscolumn = "%s %{v:lnum} %{v:relnum == 0 ? ➤'→' : v:relnum}"
--opt.statuscolumn = "%s %{v:lnum} %{v:relnum == 0 ? '➤' : v:relnum}"
--opt.statuscolumn = "%s %{v:lnum} %{v:relnum == 0 ? '⮕' : v:relnum}"
--opt.statuscolumn = "%s %{v:lnum} %{v:relnum == 0 ? '⟹' : v:relnum}"
-- opt.statuscolumn = "%s %{v:lnum} %{v:relnum == 0 ? '👉' : v:relnum}"
-- opt.statuscolumn = "%s %{v:lnum} %{v:relnum == 0 ? '=󰅂' : v:relnum}"
--opt.statuscolumn = "%s %{v:lnum} %{v:relnum == 0 ? '󰬪' : v:relnum}"
--opt.statuscolumn = "%s %{v:lnum} %{v:relnum == 0 ? '󰧚' : v:relnum}%= ▏"
opt.statuscolumn = "%s %=%{v:lnum} %=%{v:relnum == 0 ? '●➤' : v:relnum} ▏"
--
-- →
-- ➡
-- ➡️
-- ►
-- ☞ ➤  󰅂 󰬪  󰶻  󰄾 󰋇  󰧚 ●
-- ►
-- Colorscheme
-- vim.cmd("colorscheme desert")
-- vim.cmd("colorcolumn=80")

-- Remaps
vim.g.mapleader = " "


local key = vim.keymap.set

-- Search and replace the visual selection
key("v", "<leader>r", '"hy:%s/<C-r>h//gc<left><left><left>')

-- Project View (Netrw)
key("n", "<leader>pv", vim.cmd.Ex)

-- Source init.lua
-- key("n", "<leader><CR>", ":source ~/.config/nvim/init.lua<CR>")
key('n', '<leader><F5>', function()
  vim.cmd('source $MYVIMRC')
  vim.notify('Config reloaded!')
  vim.defer_fn(function()
    vim.notify('')  -- clears the message
  end, 500)        -- 500ms 
end, { desc = 'Reload config' })


-- Center screen after jumping half-page
key("n", "<C-d>", "<C-d>M")
key("n", "<C-u>", "<C-u>M")

-- Keep search terms centered
key("n", "n", "nzzzv")
key("n", "N", "Nzzzv")

-- Move cursor in insert mode with Alt+h/j/k/l
key("i", "<A-h>", "<C-o>h")
key("i", "<A-j>", "<C-o>j")
key("i", "<A-k>", "<C-o>k")
key("i", "<A-l>", "<C-o>l")

-- Word navigation in insert mode
key("i", "<A-b>", "<C-o>b")
key("i", "<A-w>", "<C-o>w")

-- "Greatest Command Ever": Don't lose register value when pasting over highlighted text
key("x", "<leader>p", "\"_dP")

-- Notify on yank (clears after 200ms)
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.schedule(function()
      vim.cmd('echo "Copied to clipboard!"')
      vim.defer_fn(function()
        vim.cmd('echon ""')
      end, 200)
    end)
  end,
})

-- ================================
-- 1. Bootstrap lazy.nvim (MUST be near top)
-- ================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- ================================
-- 3. Plugins at the end
-- ================================
require("lazy").setup({
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      --  latte, frappe, macchiato, mocha
      require("catppuccin").setup({ flavour = "mocha" }) 
      vim.cmd.colorscheme("catppuccin")
    end,
  },

--  {
--    "ellisonleao/gruvbox.nvim",
--    priority = 1000,
--    config = function()
--      require("gruvbox").setup({
--        contrast = "medium",  -- hard, medium, soft
--      })
--      vim.cmd.colorscheme("gruvbox")
--    end,
--  },
--  {
--    "rebelot/kanagawa.nvim",
--    priority = 1000,
--    config = function()
--      require("kanagawa").setup({
--        theme = "wave",  -- dragon, wave, lotus
--      })
--      vim.cmd.colorscheme("kanagawa-dragon")
--    end,
--  },
--  {
--    "folke/tokyonight.nvim",
--    priority = 1000,
--    config = function()
--      require("tokyonight").setup({
--        style = "moon",  -- night, storm, moon, day
--      })
--      vim.cmd.colorscheme("tokyonight-moon")
--    end,
--  },
--  {
--   "neanias/everforest-nvim",
--   priority = 1000,
--   config = function()
--     require("everforest").setup({
--       background = "hard",  -- hard, medium, soft
--     })
--     vim.cmd.colorscheme("everforest")
--   end,
-- },

--  {
--    "rcarriga/nvim-notify",
--    config = function()
--      require("notify").setup({
--        stages = "static",       -- no animation (fade, slide, static)
--        render = "compact",      -- minimal style (default, minimal, compact, wrapped-compact)
--        timeout = 500,          -- default timeout in ms
--        minimum_width = 10,
--        top_down = false,        -- show at bottom like echo
--      })
--      vim.notify = require("notify")  -- replace built-in notify
--    end
--  },

})
