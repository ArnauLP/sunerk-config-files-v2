local plugins = {
    {
        "neovim/nvim-lspconfig",
        config = function()
            require('lspconfig').clangd.setup{}
        end,
    },
    -- Añade más plugins aquí si es necesario
}

return plugins

