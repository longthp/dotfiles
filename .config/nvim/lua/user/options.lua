-------------------------------------- options ------------------------------------------
vim.opt.laststatus = 3
vim.opt.showmode = false

vim.opt.cmdheight = 1
vim.opt.conceallevel = 0

vim.opt.showtabline = 0
vim.opt.pumheight = 10

vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true

-- Indenting
vim.opt.autoindent = true                       
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smartindent = true                      
vim.opt.smarttab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

vim.opt.fillchars = { fold = " ", vert = "│", eob = " ", msgsep = "‾" }
vim.opt.ignorecase = true
vim.opt.smartcase = true                        
vim.opt.mouse = "a"

-- Numbers
vim.opt.number = true
vim.opt.numberwidth = 1
vim.opt.relativenumber = true
vim.opt.ruler = false

-- disable nvim intro
vim.opt.shortmess:append "scI"

vim.opt.backup = false
vim.opt.swapfile = false                        
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.fileencoding = "utf-8"

vim.opt.hlsearch = true
vim.opt.termguicolors = true                    
vim.opt.background = "dark"

vim.opt.timeoutlen = 1000
vim.opt.updatetime = 300

vim.opt.undofile = true
vim.opt.writebackup = false

vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.splitbelow = true                       
vim.opt.splitright = true                       
vim.opt.wrap = false

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append "<>[]hl"
vim.opt.iskeyword:append "-"

-- disable some default providers
for _, provider in ipairs { "node", "perl", "python3", "ruby" } do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- add binaries installed by mason.nvim to path
local is_windows = vim.loop.os_uname().sysname == "Windows_NT"
vim.env.PATH = vim.fn.stdpath "data" .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH
