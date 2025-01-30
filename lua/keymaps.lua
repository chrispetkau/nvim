local keymaps = {}

-- TODO either use this everywhere or not at all
local map = function(type, key, value, desc)
	vim.api.nvim_buf_set_keymap(0, type, key, value, { noremap = true, silent = true, desc = desc });
end

-- Set LSP keymaps only when an LSP attaches.
function keymaps.set_lsp_keymappings(client)
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

-- TODO these conflict with set_lsp_keymappings(). Consolidate.
-- 'r'efactoring keymaps.
-- vim.keymap.set('n', "<leader>rn", function() vim.lsp.buf.rename() end)
-- vim.keymap.set('n', "<leader>rr", function() vim.lsp.buf.references() end)
-- vim.keymap.set('n', "<leader>rs", function() vim.lsp.buf.signature_help() end)
-- vim.keymap.set('n', "<leader>rh", function() vim.lsp.buf.hover() end)
-- vim.keymap.set('n', "<leader>ri", function() vim.lsp.buf.implementation() end)
-- vim.keymap.set('n', "<c-.>", function() vim.lsp.buf.code_action() end)

-- Comment keymaps use 'g' as an arbitrary prefix, then '/' for linewise and '*' for block.
function keymaps.get_comment_plugin_setup_spec()
	return {
		toggler = {
			line = 'g/',
			block = 'g*',
		},
		opleader = {
			line = 'g/',
			block = 'g*',
		},
		extra = {
			above = 'g/O',
			below = 'g/o',
			eol = 'g/A',
		},
	}
end

function keymaps.setup()
	local util = require("util")

	-- 'f'ind keymaps.
	local tb = require('telescope.builtin')
	vim.keymap.set('n', '<leader>o', tb.find_files, { desc = 'Telescope find files' })
	vim.keymap.set('n', '<leader>t', tb.live_grep, { desc = 'Telescope live grep' })
	vim.keymap.set('n', '<leader>fb', tb.buffers, { desc = 'Telescope buffers' })
	vim.keymap.set('n', '<leader>fh', tb.help_tags, { desc = 'Telescope help tags' })

	-- local actions = require("telescope.actions")

	-- 'd'irectory change.
	vim.keymap.set("n", "<leader>cd", util.select_directory, { desc = "Select and change directory" })

	-- 'e'rror keymaps.
	vim.keymap.set("n", "<leader>en", vim.diagnostic.goto_next)
	vim.keymap.set("n", "<leader>ep", vim.diagnostic.goto_prev)

	-- FloaTerm configuration
	-- 'f' for Float. TODO 'f' is for Find.
	vim.keymap.set('n', "<leader>ft", ":FloatermNew --name=myfloat --height=0.8 --width=0.7 --autoclose=2 fish <CR> ")
	vim.keymap.set('n', "t", ":FloatermToggle myfloat<CR>")
	vim.keymap.set('t', "<Esc>", "<C-\\><C-n>:q<CR>")
	vim.keymap.set('n', "<leader><Tab>", ":tabnew<CR>")

	-- Ctrl-s to save.
	vim.keymap.set("n", "<C-s>", ":w<CR>", { desc = "Save current buffer" })
	vim.keymap.set("n", "<C-S-s>", ":wa<CR>", { desc = "Save all buffers" })
	vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save current buffer" })
	vim.keymap.set("i", "<C-S-s>", "<Esc>:wa<CR>a", { desc = "Save all buffers" })
	
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
	vim.keymap.set("n", "<leader>dr", function() util.focus_dap_ui_element("[dap-repl-3062]") end, { desc = "Focus DAP-UI REPL" })
	vim.keymap.set("n", "<leader>dc", function() util.focus_dap_ui_element("DAP Console") end, { desc = "Focus DAP-UI Console" })
	vim.keymap.set("n", "<leader>dw", function() util.focus_dap_ui_element("DAP Watches") end, { desc = "Focus DAP-UI Watches" })
end

return keymaps
