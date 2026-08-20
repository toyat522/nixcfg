require("options")
require("setup")
require("colorscheme")
require("keymaps")
require("nvim-tree").setup({
    actions = {
        open_file = {
            quit_on_open = true
        }
    },
    view = {
        width = 50
    }
})
require("lsp")
