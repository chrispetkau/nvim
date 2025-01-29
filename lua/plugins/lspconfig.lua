local lspconfig = {}

function lspconfig.setup()
	local keymaps = require("keymaps")
	local lspconfig = require('lspconfig')

	-- TODO
	-- 2. folding?
	lspconfig.lua_ls.setup {
		on_attach = keymaps.set_lsp_keymappings,
		settings = {
			Lua = {
				diagnostics = {
					-- Suppress the 'vim is an unrecognized global' error.
					-- TODO would like this to apply to init.lua only.
					globals = { 'vim' },
				},
			},
		},
	}
	lspconfig.rust_analyzer.setup {
		on_attach = keymaps.set_lsp_keymappings,
		-- Server-specific settings. See `:help lspconfig-setup`
		settings = {

		},
	}

	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local bufnr = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client.server_capabilities.completionProvider then
				vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
			end
			if client.server_capabilities.definitionProvider then
				vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
			end
			if client.supports_method('textDocument/inlayHint') then
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end
		end,
	})
end

return lspconfig
