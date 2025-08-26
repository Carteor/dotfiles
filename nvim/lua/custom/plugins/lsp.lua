-- custom/plugins/lsp.lua - LSP plugin specification for Lazy.nvim
return {
    -- LSP Configuration
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            -- Extend LSP capabilities with nvim-cmp
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- LSP key mappings - only set when LSP is attached
            local function on_attach(client, bufnr)
                local opts = { buffer = bufnr, silent = true }

                -- Key mappings
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', '<leader>f', function()
                    vim.lsp.buf.format { async = true }
                end, opts)
            end

            -- Configure diagnostic display
            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })

            -- Configure Mason LSP Config with explicit handlers
            require("mason-lspconfig").setup({
                capabilities = capabilities,
                ensure_installed = {
                    "lua_ls",
                    "pyright", -- Only pyright, NOT pylsp
                    "ruff",
                    "html",
                    "marksman",
                },
                automatic_installation = true,
                handlers = {
                    -- Default handler for most servers
                    function(server_name)
                        -- Skip pylsp entirely - don't set it up
                        if server_name == "pylsp" then
                            return
                        end

                        require("lspconfig")[server_name].setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                        })
                    end,

                    -- Custom handlers for specific servers
                    ["lua_ls"] = function()
                        require("lspconfig").lua_ls.setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                            settings = {
                                Lua = {
                                    runtime = { version = 'LuaJIT' },
                                    diagnostics = { globals = { 'vim' } },
                                    workspace = {
                                        library = vim.api.nvim_get_runtime_file("", true),
                                        checkThirdParty = false,
                                    },
                                    telemetry = { enable = false },
                                },
                            },
                        })
                    end,

                    ["pyright"] = function()
                        -- Try uv first
                        local uv_python = vim.fn.system("uv venv python"):gsub("%s+$", "")
                        local uv_ok = vim.fn.executable(uv_python) == 1

                        -- Then try local .venv
                        local venv_python = vim.fn.getcwd() .. "/.venv/bin/python"
                        local venv_ok = vim.fn.filereadable(venv_python) == 1 or vim.fn.executable(venv_python) == 1

                        -- Fallback to system python
                        local fallback_python = vim.fn.exepath("python3")

                        -- Final decision
                        local chosen_python = uv_ok and uv_python or (venv_ok and venv_python or fallback_python)

                        require("lspconfig").pyright.setup({
                            on_attach = on_attach,
                            capabilities = capabilities,
                            settings = {
                                python = {
                                    pythonPath = chosen_python,
                                    analysis = {
                                        autoSearchPaths = true,
                                        diagnosticMode = "openFilesOnly",
                                        useLibraryCodeForTypes = true,
                                        typeCheckingMode = "basic",
                                    },
                                },
                            },
                        })
                    end,

                    ["ruff"] = function()
                        require("lspconfig").ruff.setup({
                            capabilities = capabilities,
                            on_attach = function(client, bufnr)
                                -- Disable hover in favor of Pyright
                                client.server_capabilities.hoverProvider = false
                                on_attach(client, bufnr)
                            end,
                        })
                    end,

                    ["html"] = function()
                        require("lspconfig").html.setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                            filetypes = { "html", "templ" },
                            init_options = {
                                configurationSection = { "html", "css", "javascript" },
                                embeddedLanguages = {
                                    css = true,
                                    javascript = true
                                },
                                provideFormatter = true
                            }
                        })
                    end,
                }
            })
        end,
    },

    -- Mason - LSP installer
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
        build = ":MasonUpdate",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        },
    },

    -- Mason LSP Config
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {},
    },
}
