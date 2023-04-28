local overrides = require("custom.configs.overrides")
local fb_actions = require("telescope").extensions.file_browser.actions

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },

  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },

  {
    "NvChad/nvterm",
    config = function ()
      require("nvterm").setup({
        terminals = {
          shell = "pwsh -nologo",
          type_opts = {
            horizontal = { location = "rightbelow", split_ratio = .3 },
          }
        }
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    opts = {
        extensions_list = { "file_browser" },
        extensions = {
            file_browser = {
                hijack_netrw = true,
                mappings = {
                    ["n"] = {
                        ["N"] = fb_actions.create,
                        ["D"] = fb_actions.remove,
                        ["R"] = fb_actions.rename,
                        ["C"] = fb_actions.copy,
                    }
                }
            }
        }
    }
  },
  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
  -- To make a plugin not be loaded
  -- {
  --   "NvChad/nvim-colorizer.lua",
  --   enabled = false
  -- },

}

return plugins
