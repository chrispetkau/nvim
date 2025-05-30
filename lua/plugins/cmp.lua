local mod = {}

function mod.setup()
	-- Completion Plugin Setup
	local cmp = require("cmp")
	cmp.setup({
		completion = {
			-- Make this false to use manual completion only, via Ctrl-Space.
			autocomplete = false,
		},
		-- Enable LSP snippets
		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body)
			end,
		},
		mapping = {
			['<Up>'] = cmp.mapping.select_prev_item(),
			['<Down>'] = cmp.mapping.select_next_item(),
			['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(), -- So this complete() is actually to open the completion dialog.
			['<C-e>'] = cmp.mapping.close(),
			['<Tab>'] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = true,
			}),
			-- Close completion menu with Esc, but stay in Insert mode
			["<Esc>"] = cmp.mapping({
				i = function(fallback)
					if cmp.visible() then
						cmp.abort()  -- Close completion menu
					else
						fallback()  -- Normal Esc behavior when menu is not open
					end
				end,
			}, { "i", "s" }),  -- Apply to Insert and Select mode
		},
		-- Installed sources:
		sources = {
			{ name = 'path' },                              -- file paths
			{ name = 'nvim_lsp', keyword_length = 3 },      -- from language server
			{ name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
			{ name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
			-- Remove buffer source to suppress Text options.
			-- { name = 'buffer', keyword_length = 2 },        -- source current buffer
			{ name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
			{ name = 'calc'},                               -- source for math calculation
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		formatting = {
			fields = {'menu', 'abbr', 'kind'},
			format = function(entry, item)
				local menu_icon ={
					nvim_lsp = 'λ',
					vsnip = '⋗',
					buffer = 'Ω',
					path = '🖫',
				}
				item.menu = menu_icon[entry.source.name]
				return item
			end,
		},
	})
end

return mod
