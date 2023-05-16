return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        signs = {
            add = { text = "▎" },
            change = { text = "▎" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
            untracked = { text = " " },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        keymaps = {},
        watch_gitdir = {
            follow_files = true,
            interval = 1000,
        },
        attach_to_untracked = true,
        current_line_blame = true,
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = "eol",
            delay = 1000,
        },
        current_line_blame_formatter_opts = {
            relative_time = true,
        },
        sign_priority = 6,
        update_debounce = 150,
        status_formatter = nil,
        max_file_length = 40000,
        preview_config = {
            border = "single",
            style = "minimal",
            relative = "cursor",
            row = 0,
            col = 1,
        },
        yadm = {
            enable = false,
        },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            map("n", "]g", function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    gs.next_hunk()
                end)
                return "<Ignore>"
            end, { expr = true, desc = "[GIT] Next Hunk" })
            map("n", "[g", function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(function()
                    gs.prev_hunk()
                end)
                return "<Ignore>"
            end, { expr = true, desc = "[GIT] Previous Hunk" })
            map("n", "<leader>gs", "<CMD>Gitsigns toggle_signs<CR>", { desc = "[GIT] Toggle signs" })
            map({ "n", "v" }, "<leader>gr", "<CMD>Gitsigns reset_hunk<CR>", { desc = "[GIT] Reset Hunk" })
            map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "[GIT] Undo Stage Hunk" })
            map("n", "<leader>gh", gs.preview_hunk, { desc = "[GIT] Preview Hunk" })
            map("n", "<leader>gd", gs.diffthis, { desc = "[GIT] Diff This" })
        end,
    },
}
