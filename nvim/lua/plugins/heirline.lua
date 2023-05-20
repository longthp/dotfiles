return {
    "rebelot/heirline.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "neovim/nvim-lspconfig",
    },
    config = function()
        local heirline = require("heirline")
        local conditions = require("heirline.conditions")
        local utils = require("heirline.utils")
        local colors = require("catppuccin.palettes").get_palette()

        conditions.buffer_not_empty = function()
            return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
        end

        conditions.hide_in_width = function(size)
            return vim.api.nvim_get_option("columns") > (size or 140)
        end

        local Align = { provider = "%=", hl = { bg = colors.mantle } }
        local Space = { provider = " " }

        local ViMode = {
            init = function(self)
                self.mode = vim.api.nvim_get_mode().mode
                if not self.once then
                    vim.api.nvim_create_autocmd("ModeChanged", {
                        pattern = "*:*o",
                        command = "redrawstatus",
                    })
                    self.once = true
                end
            end,
            static = {
                mode_colors = {
                    [""] = colors.yellow,
                    [""] = colors.yellow,
                    ["s"] = colors.yellow,
                    ["!"] = colors.maroon,
                    ["R"] = colors.flamingo,
                    ["Rc"] = colors.flamingo,
                    ["Rv"] = colors.rosewater,
                    ["Rx"] = colors.flamingo,
                    ["S"] = colors.teal,
                    ["V"] = colors.lavender,
                    ["Vs"] = colors.lavender,
                    ["c"] = colors.peach,
                    ["ce"] = colors.peach,
                    ["cv"] = colors.peach,
                    ["i"] = colors.green,
                    ["ic"] = colors.green,
                    ["ix"] = colors.green,
                    ["n"] = colors.blue,
                    ["niI"] = colors.blue,
                    ["niR"] = colors.blue,
                    ["niV"] = colors.blue,
                    ["no"] = colors.pink,
                    ["no"] = colors.pink,
                    ["noV"] = colors.pink,
                    ["nov"] = colors.pink,
                    ["nt"] = colors.red,
                    ["null"] = colors.pink,
                    ["r"] = colors.teal,
                    ["r?"] = colors.maroon,
                    ["rm"] = colors.sky,
                    ["s"] = colors.teal,
                    ["t"] = colors.red,
                    ["v"] = colors.mauve,
                    ["vs"] = colors.mauve,
                },
            },
            provider = function()
                return "▋"
            end,
            hl = function(self)
                local mode = self.mode:sub(1, 1)
                return { fg = self.mode_colors[mode], bg = colors.mantle, bold = true }
            end,
            update = {
                "ModeChanged",
            },
        }

        local FileNameBlock = {
            init = function(self)
                self.filename = vim.api.nvim_buf_get_name(0)
            end,
            condition = conditions.buffer_not_empty,
            hl = { bg = colors.mantle, fg = colors.subtext1 },
        }

        local FileIcon = {
            init = function(self)
                local filename = self.filename
                local extension = vim.fn.fnamemodify(filename, ":e")
                self.icon, self.icon_color =
                    require("nvim-web-devicons").get_icon_color(vim.fn.fnamemodify(filename, ":t"), extension, { default = true })
            end,
            provider = function(self)
                return self.icon and (" %s "):format(self.icon)
            end,
            hl = function(self)
                return { fg = self.icon_color }
            end,
        }

        local FileName = {
            provider = function(self)
                local filename = vim.fn.fnamemodify(self.filename, ":t")
                if filename == "" then
                    return "[No Name]"
                end
                if not conditions.width_percent_below(#filename, 0.25) then
                    filename = vim.fn.pathshorten(filename)
                end
                return filename
            end,
            hl = { fg = colors.subtext1, bold = true },
        }

        local FileFlags = {
            {
                condition = function()
                    return vim.bo.modified
                end,
                provider = " ● ",
                hl = { fg = colors.lavender },
            },
            {
                condition = function()
                    return not vim.bo.modifiable or vim.bo.readonly
                end,
                provider = "",
                hl = { fg = colors.red },
            },
        }

        local FileNameModifer = {
            hl = function()
                if vim.bo.modified then
                    return { fg = colors.text, bold = true, force = true }
                end
            end,
        }

        FileNameBlock =
            utils.insert(FileNameBlock, FileIcon, utils.insert(FileNameModifer, FileName), unpack(FileFlags), { provider = "%< " })

        local FileType = {
            provider = function()
                return (" %s "):format(vim.bo.filetype:upper())
            end,
            hl = { bg = colors.mantle, fg = colors.surface2 },
            condition = function()
                return conditions.buffer_not_empty() and conditions.hide_in_width()
            end,
        }

        local FileSize = {
            provider = function()
                local suffix = { "b", "k", "M", "G", "T", "P", "E" }
                local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
                fsize = (fsize < 0 and 0) or fsize
                if fsize < 1024 then
                    return " " .. fsize .. suffix[1] .. " "
                end
                local i = math.floor((math.log(fsize) / math.log(1024)))
                return (" %.2g%s "):format(fsize / math.pow(1024, i), suffix[i + 1])
            end,
            condition = function()
                return conditions.buffer_not_empty() and conditions.hide_in_width()
            end,
            hl = { bg = colors.mantle, fg = colors.surface2 },
        }

        local Ruler = {
            provider = " %7(%l/%3L%):%2c %P ",
            condition = function()
                return conditions.buffer_not_empty() and conditions.hide_in_width()
            end,
            hl = { bg = colors.mantle, fg = colors.surface2 },
        }

        local LSPActive = {
            condition = function()
                return conditions.hide_in_width(120) and conditions.lsp_attached()
            end,
            update = { "LspAttach", "LspDetach" },
            provider = function()
                local names = {}
                for _, server in pairs(vim.lsp.get_active_clients()) do
                    if server.name ~= "null-ls" then
                        table.insert(names, server.name)
                    end
                end

                if #names == 0 then
                    return ""
                end

                return (vim.g.emoji and " 🪐 %s " or "   %s "):format((table.concat(names, " ")):upper())
            end,
            hl = { bg = colors.mantle, fg = colors.subtext1, bold = true, italic = false },
        }

        -- local Diagnostics = {
        --     condition = function()
        --         return conditions.buffer_not_empty() and conditions.hide_in_width() and conditions.has_diagnostics()
        --     end,
        --     static = {
        --         error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
        --         warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
        --         info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
        --         hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
        --     },
        --     init = function(self)
        --         self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        --         self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        --         self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        --         self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
        --     end,
        --     update = { "DiagnosticChanged", "BufEnter" },
        --     hl = { bg = colors.mantle },
        --     Space,
        --     {
        --         provider = function(self)
        --             return self.errors > 0 and ("%s%s "):format(self.error_icon, self.errors)
        --         end,
        --         hl = { fg = colors.red },
        --     },
        --     {
        --         provider = function(self)
        --             return self.warnings > 0 and ("%s%s "):format(self.warn_icon, self.warnings)
        --         end,
        --         hl = { fg = colors.yellow },
        --     },
        --     {
        --         provider = function(self)
        --             return self.info > 0 and ("%s%s "):format(self.info_icon, self.info)
        --         end,
        --         hl = { fg = colors.sapphire },
        --     },
        --     {
        --         provider = function(self)
        --             return self.hints > 0 and ("%s%s "):format(self.hint_icon, self.hints)
        --         end,
        --         hl = { fg = colors.sky },
        --     },
        --     Space,
        -- }
        --
        local Git = {
            condition = function()
                return conditions.buffer_not_empty() and conditions.is_git_repo()
            end,
            init = function(self)
                self.status_dict = vim.b.gitsigns_status_dict
                self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
            end,
            hl = { bg = colors.mantle, fg = colors.mauve },
            Space,
            {
                provider = function(self)
                    return (" %s"):format(self.status_dict.head)
                end,
                hl = { bold = true },
            },
            {
                provider = function(self)
                    local count = self.status_dict.added or 0
                    return count > 0 and ("  %s"):format(count)
                end,
                hl = { fg = colors.green },
            },
            {
                provider = function(self)
                    local count = self.status_dict.removed or 0
                    return count > 0 and ("  %s"):format(count)
                end,
                hl = { fg = colors.red },
            },
            {
                provider = function(self)
                    local count = self.status_dict.changed or 0
                    return count > 0 and ("  %s"):format(count)
                end,
                hl = { fg = colors.peach },
            },
            Space,
        }

        local FileEncoding = {
            provider = function()
                local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
                return (" %s "):format(enc:upper())
            end,
            condition = function()
                return conditions.buffer_not_empty() and conditions.hide_in_width()
            end,
            hl = { bg = colors.mantle, fg = colors.surface2 },
        }

        local FileFormat = {
            provider = function()
                local fmt = vim.bo.fileformat
                if fmt == "unix" then
                    return " LF "
                elseif fmt == "mac" then
                    return " CR "
                else
                    return " CRLF "
                end
            end,
            hl = { bg = colors.mantle, fg = colors.surface2 },
            condition = function()
                return conditions.buffer_not_empty() and conditions.hide_in_width()
            end,
        }

        local IndentSizes = {
            provider = function()
                local indent_type = vim.api.nvim_buf_get_option(0, "expandtab") and "Spaces" or "Tab Size"
                local indent_size = vim.api.nvim_buf_get_option(0, "tabstop")
                return (" %s: %s "):format(indent_type, indent_size)
            end,
            hl = { bg = colors.mantle, fg = colors.surface2 },
            condition = function()
                return conditions.buffer_not_empty() and conditions.hide_in_width()
            end,
        }

        heirline.setup({
            statusline = {
                ViMode,
                FileNameBlock,
                FileType,
                FileSize,
                Ruler,
                Align,
                LSPActive,
                -- Diagnostics,
                FileEncoding,
                FileFormat,
                IndentSizes,
                Git,
            },
        })
    end,
}
