local colorscheme = "sonokai"

vim.opt.termguicolors = true
vim.g.sonokai_style = "shusia"
vim.g.sonokai_better_performance = 1

require("lualine").setup({
    options = {
        theme = "sonokai"
    }
})

local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not is_ok then
    vim.notify("colorscheme " .. colorscheme .. " not found!")
    return
end
