local copilot = {}

function copilot.setup()
	-- Basic setup for copilot.lua (not the official GitHub one)
	require("copilot").setup({
		suggestion = {
			enabled = true,
			auto_trigger = true,
			keymap = {
				-- Use a different key for dismiss, as Esc will be handled separately
				dismiss = "<M-]>", -- Alt+]
				-- Other keymaps
				accept = "<Tab>",
				accept_word = "<C-]>",
				accept_line = "<C-l>",
				next = "<C-j>",
				prev = "<C-k>",
			},
		},
	})
end

return copilot
