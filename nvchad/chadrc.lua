---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = "catppuccin",
  nvdash = {
    load_on_startup = true,
    header = {
      "██╗      ██████╗ ███╗   ██╗ ██████╗████████╗██╗  ██╗██████╗ ",
      "██║     ██╔═══██╗████╗  ██║██╔════╝╚══██╔══╝██║  ██║██╔══██╗",
      "██║     ██║   ██║██╔██╗ ██║██║  ███╗  ██║   ███████║██████╔╝",
      "██║     ██║   ██║██║╚██╗██║██║   ██║  ██║   ██╔══██║██╔═══╝ ",
      "███████╗╚██████╔╝██║ ╚████║╚██████╔╝  ██║   ██║  ██║██║     ",
      "╚══════╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝   ╚═╝   ╚═╝  ╚═╝╚═╝     ",
    }
  },

  tabufline = {
    overriden_modules = function()
      return {
        buttons = function()
          return ""
        end,
      }
    end,
  },

  hl_override = highlights.override,
  hl_add = highlights.add,
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
