local lspconfig = {}

local function setup_lsp(client)
	require("keymaps").set_lsp_keymappings(client)
end

function lspconfig.setup()
	local lspconfig_plugin = require('lspconfig')

	lspconfig_plugin.lua_ls.setup {
		on_attach = setup_lsp,
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
	lspconfig_plugin.rust_analyzer.setup {
		on_attach = setup_lsp,
		settings = {
			['rust-analyzer'] = {
				diagnostics = {
					enable = false
				}
			}
		}
	}
	require("roslyn").setup({
		config = {
			on_attach = setup_lsp,
			settings = {
				["csharp|inlay_hints"] = {
					csharp_enable_inlay_hints_for_implicit_object_creation = true,
					csharp_enable_inlay_hints_for_implicit_variable_types = true,
					csharp_enable_inlay_hints_for_lambda_parameter_types = true,
					csharp_enable_inlay_hints_for_types = true,
					dotnet_enable_inlay_hints_for_indexer_parameters = true,
					dotnet_enable_inlay_hints_for_literal_parameters = true,
					dotnet_enable_inlay_hints_for_object_creation_parameters = true,
					dotnet_enable_inlay_hints_for_other_parameters = true,
					dotnet_enable_inlay_hints_for_parameters = true,
					dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
					dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
					dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
				},
				["csharp|code_lens"] = {
					dotnet_enable_references_code_lens = true,
				},
			},
		},
	})

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
			if client.supports_method('textDocument/foldingRange') then
				vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
				-- TODO you would think this would be awesome, but both lua-lsp and Roslyn are worse than
				-- treesitter IMHO
				vim.opt.foldtext = "v:lua.vim.lsp.foldtext()"
			end
		end,
	})
end

return lspconfig
