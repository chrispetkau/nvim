--[[ init.lua ]]
-- To reload init.lua from within Neovim: >:source $MYVIMRC
-- To change "projects" from within Neovim you can change its root directory: >:cd c:\klei\rotwood\data\script
--
-- FAQ
-- Q: Why do I have to double-escape to exit a Telescope dialog?
-- A: Because everything in Neovim is a buffer. You start the dialog in Insert mode so you can type into your grep box.
-- That creates the list of options. Then you <Esc> to enter Normal mode to navigate to your choice. It only feels
-- unnatural when you just want to abort.

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("opts").setup()

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error 
-- Show inlay_hints more frequently 
vim.cmd([[
	autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

	" Automatically resize buffers on window resize
	autocmd VimResized * wincmd = 

	" Auto update buffers if reloaded from outside
	autocmd FocusGained,BufEnter * :checktime
]])

require("plugins.lspconfig").setup()

-- Completion Plugin Setup
local cmp = require('cmp')
cmp.setup({
	-- Enable LSP snippets
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = {
		['<Up>'] = cmp.mapping.select_prev_item(),
		['<Down>'] = cmp.mapping.select_next_item(),
		-- ['<C-p>'] = cmp.mapping.select_prev_item(),
		-- ['<C-n>'] = cmp.mapping.select_next_item(),
		-- Add tab support
		-- ['<S-Tab>'] = cmp.mapping.select_prev_item(),
		-- ['<Tab>'] = cmp.mapping.select_next_item(),
		['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.close(),
		['<Tab>'] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		})
	},
	-- Installed sources:
	sources = {
		{ name = 'path' },                              -- file paths
		{ name = 'nvim_lsp', keyword_length = 3 },      -- from language server
		{ name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
		{ name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
		{ name = 'buffer', keyword_length = 2 },        -- source current buffer
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

-- LSP Diagnostics Options Setup 
local sign = function(opts)
	vim.fn.sign_define(opts.name, {
		texthl = opts.name,
		text = opts.text,
		numhl = ''
	})
end

sign({name = 'DiagnosticSignError', text = ''})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = ''})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	update_in_insert = true,
	underline = true,
	severity_sort = false,
	float = {
		border = 'rounded',
		source = 'always',
		header = '',
		prefix = '',
	},
})

-- TODO these conflict with custom_attach(). Consolidate.
-- 'r'efactoring keymaps.
-- vim.keymap.set('n', "<leader>rn", function() vim.lsp.buf.rename() end)
-- vim.keymap.set('n', "<leader>rr", function() vim.lsp.buf.references() end)
-- vim.keymap.set('n', "<leader>rs", function() vim.lsp.buf.signature_help() end)
-- vim.keymap.set('n', "<leader>rh", function() vim.lsp.buf.hover() end)
-- vim.keymap.set('n', "<leader>ri", function() vim.lsp.buf.implementation() end)
-- vim.keymap.set('n', "<c-.>", function() vim.lsp.buf.code_action() end)

-- Use Zig to compile parsers because C++ always builds the wrong binary.
require ('nvim-treesitter.install').compilers = { "zig" }

-- TODO I would like to specify parsers that should be automatically installed but I get a lot of warnings with this
-- spec as written.
-- require'nvim-treesitter.configs'.setup {
-- 	-- A list of parser names, or "all" (the listed parsers MUST always be installed)
-- 	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
--
-- 	-- Install parsers synchronously (only applied to `ensure_installed`)
-- 	sync_install = false,
--
-- 	-- Automatically install missing parsers when entering buffer
-- 	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
-- 	auto_install = true,
--
-- 	-- List of parsers to ignore installing (or "all")
-- 	ignore_install = { "javascript" },
--
-- 	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
-- 	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
-- 	modules = {
-- 		highlight = {
-- 			enable = true,
--
-- 			-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
-- 			-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
-- 			-- the name of the parser)
-- 			-- list of language that will be disabled
-- 			disable = { "c", "rust" },
-- 			-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
-- 			disable = function(lang, buf)
-- 				local max_filesize = 100 * 1024 -- 100 KB
-- 				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
-- 				if ok and stats and stats.size > max_filesize then
-- 					return true
-- 				end
-- 			end,
--
-- 			-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
-- 			-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
-- 			-- Using this option may slow down your editor, and you may see some duplicate highlights.
-- 			-- Instead of true it can also be a list of languages
-- 			additional_vim_regex_highlighting = false,
-- 		},
-- 	},
-- }

-- 'c'omment keymaps: 'l'inewise or 'b'lock.
-- TODO all keymaps go in keymaps.lua
require('Comment').setup({
	toggler = {
		line = 'cl',
		block = 'cb',
	},
	opleader = {
		line = 'cl',
		block = 'cb',
	},
	extra = {
		above = 'cO',
		below = 'co',
		eol = 'cA',
	},
})

-- Format on save!
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.rs",
	callback = function()
		vim.lsp.buf.format({ async = false })
	end
})

require('onedark').setup {
	style = 'darker'
}
require('onedark').load()

-- Decrease font size a bit so we can fit 2 120-line windows side by side.
vim.o.guifont = "Cascadia Code:h13:#h-slight"

require('telescope').load_extension('dap')

local dap = require("dap")
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "SignColumn", linehl = "", numhl = "" })
local rotwood = "D:/source_control_testing/rotwood"
dap.configurations.lua = {
	{
		name= "rotwood_steam_r [slow]",
		type= "lua",
		request= "launch",
		workingDirectory= rotwood.."/bin",
		sourceBasePath= rotwood.."/data",
		executable= rotwood.."/bin/rotwood_steam_r.exe",
		arguments= "-enable_lua_debugger",
		listenPublicly= false,
		listenPort= 56789,
		encoding= "UTF-8",
		env= {}
	},
}
dap.adapters.lua = {
	type = "executable",
	command = rotwood.."/foreign/tools/VSCodeLuaDebug/Extension/DebugAdapter.exe",
	-- command = "D:/source_control_testing/rotwood/foreign/tools/VSCodeLuaDebug/DebugAdapter/bin/Release/DebugAdapter.exe",
	args = {},
}

require("dapui").setup()

require("keymaps").setup()

-- require("config.lazy")
