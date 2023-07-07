return {
    "lervag/vimtex",
    lazy = false,
    keys = {
        {
            "<leader>c",
            "<CMD>VimtexCompile<CR>",
            desc = "[Vimtex] Compile"
        },
    },
    init = function()
        vim.g.vimtex_view_general_viewer = "okular"
        vim.g.vimtex_compiler_method = "tectonic"
        vim.g.vimtex_quickfix_enabled = 0
    end,
}
