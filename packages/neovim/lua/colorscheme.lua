vim.opt.termguicolors = true

vim.cmd("colorscheme dracula")

require("lualine").setup({
    options = { theme = "dracula" }
})
