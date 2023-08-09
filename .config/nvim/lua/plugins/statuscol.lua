return {
    "luukvbaal/statuscol.nvim",
    event = "VeryLazy",
    config = function()
        local builtin = require("statuscol.builtin")

        require("statuscol").setup({
            ft_ignore = { "neo-tree", "NvimTree" },
            segments = {
                {
                    sign = { name = { "Diagnostic" }, maxwidth = 1, auto = false },
                    click = "v:lua.ScSa",
                },
                { text = { " ", builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
                {
                    sign = { name = { ".*" }, maxwidth = 1, colwidth = 1, auto = false },
                    click = "v:lua.ScSa",
                },
                { text = { "%C", " " }, click = "v:lua.ScFa" },
            },
        })
    end,
}
