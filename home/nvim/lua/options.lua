vim.opt.exrc = true               -- load .nvim.lua from project directories
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.mouse = "a" 		      -- allow the mouse to be used in vim
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

-- Disable netrw file explorer
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Tab
vim.opt.tabstop = 4	      -- number of visual spaces per TAB
vim.opt.softtabstop = 4   -- number of spaces in TAB when editing
vim.opt.shiftwidth = 4	  -- insert 4 spaces on a TAB
vim.opt.expandtab = true  -- tabs are spaces

-- UI config
vim.opt.number = true	  -- show absolute number
vim.opt.cursorline = true -- highlight cursor line underneath the cursor
vim.opt.wrap = false      -- prevent wrapping
vim.opt.scrolloff = 12    -- keep cursor centered vertically

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99

-- Searching
vim.opt.incsearch = true  -- search as characters are entered
vim.opt.ignorecase = true -- ignore case in searches by default
vim.opt.smartcase = true  -- but case sensitive if uppercase is entered

-- ASM syntax highlight
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = "*.asm",
    command = "set filetype=masm"
})

-- Show diagnostics on cursor hold
vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        show_header = false,
        source = "if_many",
        border = "rounded",
    },
})
vim.o.updatetime = 500
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        local opts = {
            focusable = false,
            header = nil,  -- remove "Diagnostics:" header line
        }
        local line_diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
        if #line_diagnostics > 0 then
            vim.diagnostic.open_float(opts)
        end
    end,
})
