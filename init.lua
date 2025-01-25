--[[ init.lua ]]
-- To reload init.lua from within Neovim: >:source $MYVIMRC
-- To change "projects" from within Neovim you can change its root directory: >:cd c:\klei\rotwood\data\script
--
-- TODO
-- : Navigate directly to a tab somehow
-- : Have buffers open into new tabs by default
-- : Better display of tabs (they are too texty right now)
-- : Figure out a better UI for debug-repl.
-- : Start using a package manager.
-- : Make it so you can sync neovim environments across computers easily.
-- : Make it so another team member could easily start using your config with a minimum of reconfiguration.
-- : Completion for : commands on the command line.
-- : Factor init.lua into multiple files. It is getting to be a bit of a beast.
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

-- IMPORTS
-- require('vars')      -- Variables
-- require('opts')      -- Options
-- require('keys')      -- Keymaps
-- require('plug')      -- Plugins

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.colorcolumn = {120}
vim.opt.signcolumn = "yes"
--vim.opt.hover_with_actions = true
--vim.opt.auto_focus = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = false
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300)

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

-- TODO either use this everywhere or not at all
local map = function(type, key, value, desc)
	vim.api.nvim_buf_set_keymap(0, type, key, value, { noremap = true, silent = true, desc = desc });
end

-- Set LSP keymaps only when an LSP attaches.
local set_lsp_keymappings = function(client)
	print("LSP started: " .. client.name);
	-- TODO these were in the original copy-pasta, but I don't have these plugins
	-- require'completion'.on_attach(client)
	-- require'diagnostic'.on_attach(client)

	-- TODO use canonical keymapping
	-- TODO add description strings as 4th parameters so we know what they do when we :nmap.
	map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', "Goto declaration")
	map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', "Goto definition")
	map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', "Goto references")
	map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', "Goto signature help")
	map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', "Goto implementation")
	map('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', "Goto type definition")
	map('n', '<leader>gw', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', "Goto document symbol")
	map('n', '<leader>gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', "Goto workspace symbol")
	map('n', '<leader>ah', '<cmd>lua vim.lsp.buf.hover()<CR>', "Hover")
	map('n', '<leader>af', '<cmd>lua vim.lsp.buf.code_action()<CR>', "Code action")
	map('n', '<leader>ee', '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>', "Show line diagnostics")
	map('n', '<leader>ar', '<cmd>lua vim.lsp.buf.rename()<CR>', "Rename")
	map('n', '<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>', "Format")
	map('n', '<leader>ai', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', "Incoming calls")
	map('n', '<leader>ao', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', "Outgoing calls")
end

-- TODO
-- 2. folding?
local lspconfig = require('lspconfig')
lspconfig.lua_ls.setup {
	on_attach = set_lsp_keymappings,
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
	on_attach = set_lsp_keymappings,
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

-- 'e'rror keymaps.
vim.keymap.set("n", "<leader>en", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>ep", vim.diagnostic.goto_prev)

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

-- 'f'ind keymaps.
local tb = require('telescope.builtin')
vim.keymap.set('n', '<leader>o', tb.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>t', tb.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', tb.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', tb.help_tags, { desc = 'Telescope help tags' })

-- local actions = require("telescope.actions")

-- FloaTerm configuration
-- 'f' for Float. TODO 'f' is for Find.
vim.keymap.set('n', "<leader>ft", ":FloatermNew --name=myfloat --height=0.8 --width=0.7 --autoclose=2 fish <CR> ")
vim.keymap.set('n', "t", ":FloatermToggle myfloat<CR>")
vim.keymap.set('t', "<Esc>", "<C-\\><C-n>:q<CR>")
vim.keymap.set('n', "<leader><Tab>", ":tabnew<CR>")

-- 'c'omment keymaps: 'l'inewise or 'b'lock.
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

-- Ctrl-s to save.
vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save current buffer" })
vim.keymap.set("n", "<C-S-s>", ":wa<CR>", { desc = "Save all buffers" })
vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save current buffer" })
vim.keymap.set("i", "<C-S-s>", "<Esc>:wa<CR>a", { desc = "Save all buffers" })

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

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values

-- Use telescope to select from a list of options and execute an action with the selection as the argument.
-- The text box is a grep to filter options; direction keys to navigate options; enter to select.
local function select(title, options, action)
    pickers.new({}, {
        prompt_title = title,
        finder = finders.new_table {
            results = options,
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(_, map_fn)
            map_fn("i", "<CR>", function(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
				action(selection.value)
            end)
            return true
        end,
    }):find()
end

-- Function to create a picker for directory selection
local function select_directory()
	-- Define a list of directories
	local directories = {
		"d:/source_control_testing/rotwood/data/scripts",
		"d:/source_control_testing/rotwood/source",
		"c:/users/chris petkau/appdata/local/nvim",
	}

	return select("Select Directory", directories, function(directory)
		vim.cmd("cd " .. vim.fn.fnameescape(directory))
		-- TODO this print is not visible
		print("Changed directory to " .. directory)
	end)
end

-- 'd'irectory change.
vim.keymap.set("n", "<leader>cd", select_directory, { desc = "Select and change directory" })

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
-- VisualStudio-style debugging keymaps
vim.keymap.set("", "<F5>", function() dap.continue() end, { desc = "Start/continue debugging" })
vim.keymap.set("", "<S-F5>", function() dap.terminate() end, { desc = "Stop debugging" })
vim.keymap.set("", "<F9>", function() dap.toggle_breakpoint() end, { desc = "Toggle breakpoint" })
vim.keymap.set("", "<F10>", function() dap.step_over() end, { desc = "Step over" })
vim.keymap.set("", "<F11>", function() dap.step_into() end, { desc = "Step into" })
vim.keymap.set("", "<S-F11>", function() dap.step_out() end, { desc = "Step out" })
vim.keymap.set("", "<F7>", function() dap.repl.open() end, { desc = "Read-eval-print" })

local dapui = require("dapui")
dapui.setup()

local function focus_dap_ui_element(element)
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name:match(element) then
            vim.api.nvim_set_current_win(win)
            return
        end
    end
    print("DAP-UI element '" .. element .. "' not found")
end

-- 'd'ebugger keymaps
vim.keymap.set("n", "<leader>do", function() dapui.open() end, { desc = "Open debugger" })
vim.keymap.set("n", "<leader>dd", function() dapui.close() end, { desc = "Close debugger" })
vim.keymap.set("n", "<leader>dt", function() dapui.toggle() end, { desc = "Toggle debugger" })
vim.keymap.set("n", "<leader>ds", function() focus_dap_ui_element("DAP Scopes") end, { desc = "Focus DAP-UI Scopes" })
vim.keymap.set("n", "<leader>df", function() focus_dap_ui_element("DAP Stacks") end, { desc = "Focus DAP-UI Stacks" })
vim.keymap.set("n", "<leader>db", function() focus_dap_ui_element("DAP Breakpoints") end, { desc = "Focus DAP-UI Breakpoints" })
vim.keymap.set("n", "<leader>dr", function() focus_dap_ui_element("[dap-repl-3062]") end, { desc = "Focus DAP-UI REPL" })
vim.keymap.set("n", "<leader>dc", function() focus_dap_ui_element("DAP Console") end, { desc = "Focus DAP-UI Console" })
vim.keymap.set("n", "<leader>dw", function() focus_dap_ui_element("DAP Watches") end, { desc = "Focus DAP-UI Watches" })

-- require("config.lazy")
