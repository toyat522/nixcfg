vim.g.vimtex_view_method = "zathura"

require("nvim-autopairs").setup({})
require("gitsigns").setup({})
require("blame").setup({})
require("blink.cmp").setup({
    keymap = {
        preset = "enter",
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    },
    appearance = {
        nerd_font_variant = "mono",
    },
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = { implementation = "lua" },
    completion = {
        keyword = { range = "prefix" },
        menu = {
            draw = {
                treesitter = { "lsp" },
            },
        },
        trigger = { show_on_trigger_character = true },
        documentation = {
            auto_show = true,
        },
    },
    signature = { enabled = true },
})
require("telescope").load_extension("fzf")

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        pcall(vim.treesitter.start, args.buf)
    end,
})
