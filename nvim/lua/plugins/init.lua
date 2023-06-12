local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
    spec = {
        { import = "plugins.autopairs" },
        { import = "plugins.blankline" },
        { import = "plugins.bufferline" },
        { import = "plugins.colorizer" },
        { import = "plugins.colorscheme" },
        { import = "plugins.comment" },
        { import = "plugins.gitsigns" },
        { import = "plugins.heirline" },
        { import = "plugins.lsp" },
        { import = "plugins.neotree" },
        { import = "plugins.null-ls" },
        { import = "plugins.smart-splits" },
        { import = "plugins.telescope" },
        { import = "plugins.toggleterm" },
        { import = "plugins.treesitter" },
        { import = "plugins.zen-mode" },
    },
    defaults = {
        lazy = true,
        version = false,
    },
    install = {
        missing = true,
        colorscheme = { "catppuccin" },
    },
    ui = {
        border = "single",
    },
    performance = {
        cache = {
            enabled = true,
        },
        rtp = {
            reset = true,
            disabled_plugins = {
                "2html_plugin",
                "fzf",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logiPat",
                "matchit",
                "matchparen",
                "netrw",
                "netrwFileHandlers",
                "netrwPlugin",
                "netrwSettings",
                "rrhelper",
                "spellfile",
                "tar",
                "tarPlugin",
                "tohtml",
                "tutor",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
            },
        },
    },
})
