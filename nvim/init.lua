vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  -- Importa tus plugins personalizados desde custom/plugins.lua
  { import = "custom.plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

--Configuración para fondo transparente
-- vim.cmd [[
--     hi Normal guibg=NONE ctermbg=NONE
--     hi NormalNC guibg=NONE ctermbg=NONE
--     hi EndOfBuffer guibg=NONE ctermbg=NONE
--     hi SignColumn guibg=NONE ctermbg=NONE
--     hi VertSplit guibg=NONE ctermbg=NONE
--     hi LineNr guibg=NONE ctermbg=NONE
--     hi Folded guibg=NONE ctermbg=NONE
--     hi NonText guibg=NONE ctermbg=NONE
--     hi SpecialKey guibg=NONE ctermbg=NONE
--     hi IncSearch guibg=NONE ctermbg=NONE
--     hi Search guibg=NONE ctermbg=NONE
--     hi Pmenu guibg=NONE ctermbg=NONE
--     hi PmenuSbar guibg=NONE ctermbg=NONE
--     hi PmenuThumb guibg=NONE ctermbg=NONE
--     hi PmenuSel guibg=NONE ctermbg=NONE
--     hi WildMenu guibg=NONE ctermbg=NONE
--     hi StatusLine guibg=NONE ctermbg=NONE
--     hi StatusLineNC guibg=NONE ctermbg=NONE
--     hi TabLine guibg=NONE ctermbg=NONE
--     hi TabLineFill guibg=NONE ctermbg=NONE
--     hi TabLineSel guibg=NONE ctermbg=NONE
--     hi CursorLineNr guibg=NONE ctermbg=NONE
-- ]]

-- Configuración global para la indentación
local opt = vim.opt

opt.expandtab = true    -- Usa espacios en lugar de tabs
opt.shiftwidth = 4      -- Número de espacios a usar para cada nivel de indentación
opt.tabstop = 4         -- Número de espacios que representa un tab
opt.softtabstop = 4     -- Número de espacios al presionar Tab
opt.autoindent = true   -- Copia la indentación de la línea anterior al iniciar una nueva línea
opt.smartindent = true  -- Hace indentación inteligente en algunas condiciones

-- Configuración específica para ciertos tipos de archivos
vim.cmd [[
    autocmd FileType c,cpp,python,java,html,css,javascript setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab
]]

-- Get copied text always on system clipboard
vim.opt.clipboard = 'unnamedplus'
