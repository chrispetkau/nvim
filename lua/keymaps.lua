local keymaps = {}

-- TODO either use this everywhere or not at all
local map = function(type, key, value, desc)
	vim.api.nvim_buf_set_keymap(0, type, key, value, { noremap = true, silent = true, desc = desc })
end

-- Set LSP keymaps only when an LSP attaches.
function keymaps.set_lsp_keymappings(client)
	print("LSP started: " .. client.name);
	-- TODO these were in the original copy-pasta, but I don't have these plugins
	-- require'completion'.on_attach(client)
	-- require'diagnostic'.on_attach(client)

	-- TODO use canonical keymapping
	-- TODO add description strings as 4th parameters so we know what they do when we :nmap.

	-- 'g'o
	map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', "Goto declaration")
	-- map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', "Goto definition")
	-- map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', "Goto references")
	map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', "Goto signature help")
	-- map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', "Goto implementation")
	-- map('n', 'gy', '<cmd>lua vim.lsp.buf.type_definition()<CR>', "Goto type definition")
	-- map('n', 'gw', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', "Goto document symbol")
	-- map('n', 'gW', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', "Goto workspace symbol")

	-- code 'a'ction
	map('n', '<leader>ah', '<cmd>lua vim.lsp.buf.hover()<CR>', "Hover")
	map('n', '<leader>af', '<cmd>lua require("util").select_code_action()<CR>', "Code action")
	map('n', '<leader>ar', '<cmd>lua vim.lsp.buf.rename()<CR>', "Rename")
	map('n', '<leader>ai', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', "Incoming calls")
	map('n', '<leader>ao', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', "Outgoing calls")

	-- 'e'rror
	-- TODO delete once verified unneeded...this popup shows on hover already but this command moves the cursor into
	-- it...do we need that functionality?
	-- map('n', '<leader>ee', '<cmd>lua vim.diagnostic.open_float()<CR>', "Show line diagnostics")

	map('n', '<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>', "Format")
end

-- Comment keymaps use 'g' as an arbitrary prefix, then 'c' for linewise and 'b' for block.
function keymaps.get_comment_plugin_setup_spec()
	return {
		toggler = {
			line = 'gc',
			block = 'gb',
		},
		opleader = {
			line = 'gc',
			block = 'gb',
		},
		extra = {
			above = 'gO',
			below = 'go',
			eol = 'gA',
		},
	}
end

function keymaps.install_fugitive_keymaps()
	vim.api.nvim_buf_set_keymap(0, 'n', 'dv', 'O:Gdiffsplit<CR>', { noremap = false, silent = true })
	-- vim.keymap.set("n", "dv", function()
	-- 	local file = vim.fn.expand("<cfile>") -- Get the file under the cursor
	-- 	if file ~= "" then
	-- 		vim.cmd("tab Git diff " .. vim.fn.fnameescape(file)) -- Open in a new tab
	-- 	end
	-- end, { buffer = true, silent = true })
	-- map('n', 'q', '<cmd>:tabclose<CR>', "Close Fugitive diffsplit tab")
end

function keymaps.install_roslyn_keymaps()
	-- Hacky restart of Roslyn on the first .sln.
	vim.keymap.set('n', '-r', ':Roslyn stop<CR>:Roslyn target<CR>1<CR>')
end

function keymaps.setup()
	local util = require("util")

	-- 'w'indow operation
	vim.keymap.set("n", "<leader>w", "<C-w>", { desc = "Window operation" })

	-- 'b'uffer
	vim.keymap.set("n", "<leader>bo", ":%bd|e#|bd#<CR>", { desc = "Close all buffers except current" }) -- buffer only
	vim.keymap.set("n", ",h", "<C-^>", { desc = "Open most recent buffer" })
	vim.keymap.set('n', ",d", ":bd<CR>", { desc = "Close buffer" })

	-- 'f'ind keymaps.
	local tb = require('telescope.builtin')
	vim.keymap.set('n', '<leader>ff', tb.find_files, { desc = 'Telescope find files' })
	vim.keymap.set('n', '<leader>fg', tb.live_grep, { desc = 'Telescope live grep' })
	vim.keymap.set('n', '<leader>fb', tb.buffers, { desc = 'Telescope buffers' })
	vim.keymap.set('n', '<leader>fh', tb.help_tags, { desc = 'Telescope help tags' })
	vim.keymap.set("n", "<leader>fd", util.select_directory, { desc = "Select and change directory" })
	vim.keymap.set('n', 'gr', tb.lsp_references, { desc = 'Telescope find references' })
	vim.keymap.set('n', 'gd', tb.lsp_definitions, { desc = 'Telescope find definitions' })
	vim.keymap.set('n', 'gy', tb.lsp_type_definitions, { desc = 'Telescope find type definitions' })
	vim.keymap.set('n', 'gi', tb.lsp_implementations, { desc = 'Telescope find implementations' })
	vim.keymap.set('n', 'gw', tb.lsp_document_symbols, { desc = 'Telescope find document symbols' })
	vim.keymap.set('n', 'gW', tb.lsp_workspace_symbols, { desc = 'Telescope find workspace symbols' })

	-- local actions = require("telescope.actions")

	-- 'e'rror keymaps.
	vim.keymap.set("n", "<C-->", vim.diagnostic.goto_next, { desc = "Goto next error" } )
	vim.keymap.set("n", "<C-m>", vim.diagnostic.goto_prev, { desc = "Goto previous error" })

	-- 't'erminal
	vim.keymap.set('n', "<leader>to", ":FloatermNew --name=myfloat --height=0.8 --width=0.7 --autoclose=2<CR> ")
	vim.keymap.set('n', "<leader>tt", ":FloatermToggle myfloat<CR>")
	vim.keymap.set('t', "<Esc>", "<C-\\><C-n>:q<CR>")

	-- tab management 
	vim.keymap.set('n', ",<Tab>", ":tabnew<CR>", { desc = "New tab" })
	vim.keymap.set('n', ",v", ":tabc<CR>", { desc = "Close tab" })

	vim.keymap.set('i', "<C-l>", "<Esc>:nohlsearch<CR>a", { desc = "Clear search highlights from Insert mode" })

	-- Ctrl-s to save.
	vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save current buffer" })
	vim.keymap.set("n", "<C-S-s>", ":wa<CR>", { desc = "Save all buffers" })
	vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save current buffer" })
	vim.keymap.set("i", "<C-S-s>", "<Esc>:wa<CR>a", { desc = "Save all buffers" })

	-- Standard chords for cut'n'paste from clipboard.
	vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copy clipboard" })
	vim.keymap.set("v", "<C-x>", '"+d', { desc = "Cut clipboard" })
	vim.keymap.set({"n", "v"}, "<C-p>", '"+p', { desc = "Paste clipboard" }) -- Don't use <C-v> as that is Visual Block.

	-- VisualStudio-style debugging keymaps
	local dap = require("dap")
	vim.keymap.set("", "<F5>", function() dap.continue() end, { desc = "Start/continue debugging" })
	vim.keymap.set("", "<S-F5>", function() dap.terminate() end, { desc = "Stop debugging" })
	vim.keymap.set("", "<F9>", function() dap.toggle_breakpoint() end, { desc = "Toggle breakpoint" })
	vim.keymap.set("", "<F10>", function() dap.step_over() end, { desc = "Step over" })
	vim.keymap.set("", "<F11>", function() dap.step_into() end, { desc = "Step into" })
	vim.keymap.set("", "<S-F11>", function() dap.step_out() end, { desc = "Step out" })
	vim.keymap.set("", "<F7>", function() dap.repl.open() end, { desc = "Read-eval-print" })

	-- 'd'ebugger keymaps
	local dapui = require("dapui")
	vim.keymap.set("n", "<leader>do", function() dapui.open() end, { desc = "Open debugger" })
	vim.keymap.set("n", "<leader>dd", function() dapui.close() end, { desc = "Close debugger" })
	vim.keymap.set("n", "<leader>dt", function() dapui.toggle() end, { desc = "Toggle debugger" })
	vim.keymap.set("n", "<leader>ds", function() util.focus_dap_ui_element("DAP Scopes") end, { desc = "Focus DAP-UI Scopes" })
	vim.keymap.set("n", "<leader>df", function() util.focus_dap_ui_element("DAP Stacks") end, { desc = "Focus DAP-UI Stacks" })
	vim.keymap.set("n", "<leader>db", function() util.focus_dap_ui_element("DAP Breakpoints") end, { desc = "Focus DAP-UI Breakpoints" })
	-- TODO vim.keymap.set("n", "<leader>dr", function() util.focus_dap_ui_element("[dap-repl-3062]") end, { desc = "Focus DAP-UI REPL" })
	vim.keymap.set("n", "<leader>dc", function() util.focus_dap_ui_element("DAP Console") end, { desc = "Focus DAP-UI Console" })
	vim.keymap.set("n", "<leader>dw", function() util.focus_dap_ui_element("DAP Watches") end, { desc = "Focus DAP-UI Watches" })

	-- 'g'it keymaps
	vim.keymap.set("n", "<leader>gl", util.git_log_author_date(), { desc = "One-line git log with author and date" })
end

return keymaps
