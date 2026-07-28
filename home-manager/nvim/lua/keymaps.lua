-- Telescope
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<C-o>", telescope.find_files)
vim.keymap.set("n", "<C-f>", telescope.live_grep)

-- Ctrl+n to open nvim-tree
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")

-- Move to prev/next buffer
vim.keymap.set("n", "<A-,>", ":BufferPrevious<CR>")
vim.keymap.set("n", "<A-.>", ":BufferNext<CR>")

-- Re-order with prev/next buffer
vim.keymap.set("n", "<A-S-,>", ":BufferMovePrevious<CR>")
vim.keymap.set("n", "<A-S-.>", ":BufferMoveNext<CR>")

-- Close buffer
vim.keymap.set("n", "<A-w>", ":BufferClose<CR>")

-- Format file
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python", "cpp", "cu" },
    callback = function()
        vim.keymap.set("n", "=G", function()
            vim.lsp.buf.format()
        end, { buffer = true })
    end,
})
