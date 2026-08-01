vim.lsp.config('pylsp', {
    cmd = { 'pylsp' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile' },
    settings = {
        pylsp = {
            plugins = {
                black = { enabled = true },
                pycodestyle = {
                    enabled = true,
                    maxLineLength = 100,
                },
            }
        }
    }
})
vim.lsp.config('clangd', {
    cmd = { 'clangd' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },
    root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt', 'configure.ac' },
})
vim.lsp.enable({ 'pylsp', 'clangd' })
