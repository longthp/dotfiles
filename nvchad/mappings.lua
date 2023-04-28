---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },

    ["<S-l>"] = {
      function()
        require("nvchad_ui.tabufline").tabuflineNext()
      end,
      "goto next buffer",
    },

    ["<S-h>"] = {
      function()
        require("nvchad_ui.tabufline").tabuflinePrev()
      end,
      "goto prev buffer",
    },

    ["<C-w>"] = {
      function()
        require("nvchad_ui.tabufline").close_buffer()
      end,
      "close buffer",
    },

    ["<leader>h"] = { "<C-w>h", "focus window left" },
    ["<leader>l"] = { "<C-w>l", "focus window right" },
    ["<leader>j"] = { "<C-w>j", "focus window down" },
    ["<leader>k"] = { "<C-w>k", "focus window up" },

    ["<C-Up>"] = { ":resize -2<CR>", "resize with arrows" },
    ["<C-Down>"] = { ":resize +2<CR>", "resize with arrows" },
    ["<C-Left>"] = { ":vertical resize -2<CR>", "resize with arrows" },
    ["<C-Right>"] = { ":vertical resize +2<CR>", "resize with arrows" },

    ["<leader>to"] = { ":tabnew<CR>", "open new tab" },
    ["<leader>tx"] = { ":tabclose<CR>", "close current tab" },
    ["<leader>tn"] = { ":tabn<CR>", "go to next tab" },
    ["<leader>tp"] = { ":tabp<CR>", "go to previous tab" },

  },

  v = {
    ["<"] = { "<gv", "stay in indent mode" },
    [">"] = { ">gv", "stay in indent mode" }
  },

  t = {
    ["jk"] = { vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "escape terminal mode" },
  },

  x = {
    ["J"] = { ":move '>+1<CR>gv-gv", "move text down" },
    ["K"] = { ":move '<-2<CR>gv-gv", "move text up" },
  },
}

M.nvterm = {
  t = {
    ["<C-\\>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "toggle horizontal term",
    },
  },
  n = {
    ["<C-\\>"] = {
      function()
        require("nvterm.terminal").toggle "horizontal"
      end,
      "toggle horizontal term",
    },
  }
}

M.telescope = {
    n = {
        ["<leader>fe"] = { "<cmd> Telescope file_browser <CR>", "file browser" },
    }
}

return M
