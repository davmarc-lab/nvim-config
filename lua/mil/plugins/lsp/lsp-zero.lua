return {
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
        config = false,
        init = function()
            -- Disable automatic setup
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_cmp()

            require('luasnip.loaders.from_vscode').lazy_load()

            local cmp = require('cmp')

            cmp.setup({
                formatting = lsp_zero.cmp_format(),
                completion = {
                    completeopt = 'menu,menuone,preview,noselect'
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end
                },
                window = {
                    completion = cmp.config.window.bordered()
                },
                mapping = cmp.mapping.preset.insert({
                    ["<TAB>"] = cmp.mapping.select_next_item(),
                    ["<S-TAB>"] = cmp.mapping.select_prev_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    { name = 'bufffer' },
                }),
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        config = function()
            local lsp_zero = require('lsp-zero')
            lsp_zero.extend_lspconfig()

            lsp_zero.on_attach(function(_, bufnr)
                local opts = { buffer = bufnr, remap = false }

                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

                vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
                vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
                vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

                vim.keymap.set('n', '<leader>hl', vim.lsp.buf.hover, opts)

                vim.keymap.set('n', '<leader>df', vim.diagnostic.open_float, opts)
                vim.keymap.set('n', '<leader>db', '<Cmd>Telescope diagnostics bufnr=0<CR>', opts)
                vim.keymap.set('n', '[d', vim.diagnostic.goto_next, opts)
                vim.keymap.set('n', ']d', vim.diagnostic.goto_prev, opts)

                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

                vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
            end)

            require('mason-lspconfig').setup({
                ensure_installed = {},
                handlers = {
                    lsp_zero.default_setup,
                    lua_ls = function()
                        require('lspconfig').lua_ls.setup({
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        globals = { "vim" },
                                    },
                                    workspace = {
                                        library = {
                                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                            [vim.fn.stdpath("config") .. "/lua"] = true,
                                        },
                                    },
                                },
                            },
                        })
                    end,
                }
            })
        end
    }
}
