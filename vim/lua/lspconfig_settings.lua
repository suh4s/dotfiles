local lspconfig = require 'lspconfig'
local cmp = require 'cmp_nvim_lsp'
local lsp_installer = require 'nvim-lsp-installer'
local navic = require("nvim-navic")

lsp_installer.setup {
  automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗"
    }
  }
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local custom_on_attach = function(client, bufnr)
    if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, bufnr)
    end
end

local completion_capabilities = cmp.default_capabilities(capabilities)

lspconfig.intelephense.setup { capabilities = completion_capabilities, on_attach = custom_on_attach }
lspconfig.jsonls.setup { capabilities = completion_capabilities, on_attach = custom_on_attach }
lspconfig.rust_analyzer.setup { capabilities = completion_capabilities, on_attach = custom_on_attach }
lspconfig.cssls.setup { capabilities = completion_capabilities, on_attach = custom_on_attach }
lspconfig.gopls.setup { capabilities = capabilities, on_attach = custom_on_attach }
lspconfig.tsserver.setup { capabilities = completion_capabilities, on_attach = custom_on_attach }
lspconfig.vimls.setup { capabilities = completion_capabilities, on_attach = custom_on_attach }
lspconfig.metals.setup { capabilities = completion_capabilities, on_attach = custom_on_attach }
lspconfig.bashls.setup { capabilities = completion_capabilities, on_attach = custom_on_attach }
lspconfig.graphql.setup { capabilities = completion_capabilities, on_attach = custom_on_attach }
lspconfig.vimls.setup { capabilities = completion_capabilities }
lspconfig.yamlls.setup {
  capabilities = completion_capabilities,
  schemaStore = { url = "https://www.schemastore.org/api/json/catalog.json" }
}

-- Lua LSP Setup
-- Install Help:
-- Clone the relevant git repo in ~/personal
-- https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
local sumneko_root_path = "~/personal/lua-language-server"
local sumneko_binary = sumneko_root_path .. "/bin" .. "/lua-language-server"
local runtime_path = vim.split(package.path, ';')

lspconfig.sumneko_lua.setup {
	cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" };
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { 'vim' },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			}
		}
	}
}

vim.api.nvim_set_keymap('n', '<Leader>gd', ':lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>gd', ':lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>td', ':lua vim.lsp.buf.type_definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>fr', ':lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>rn', ':lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>ac', ':lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>gg', ':lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gn', ':lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gp', ':lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>s',  ':lua vim.lsp.buf.workspace_symbol()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'K',          ':lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'tt',         ':lua vim.lsp.buf.document_symbol()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>c',  ':lua vim.lsp.buf.formatting()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>ee', ':lua vim.diagnostic.setqflist()<CR>', { noremap = true, silent = true });
-- " nmap <silent> <Leader>ee <Plug>(coc-refactor)
