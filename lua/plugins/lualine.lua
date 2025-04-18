local lualine = {}

local function dap_status()
	local session = require("dap").session()
	-- return session and " DAP Connected" or " DAP Disconnected"
	return session and "" or ""
end

function lualine.setup()
	require('lualine').setup({
		options = {
			icons_enabled = true,
			theme = 'auto',
			component_separators = { left = '', right = ''},
			section_separators = { left = '', right = ''},
			disabled_filetypes = {
				statusline = {},
				winbar = {},
				NvimTree = {},
			},
			ignore_focus = {},
			always_divide_middle = true,
			always_show_tabline = true,
			globalstatus = false,
			refresh = {
				statusline = 100,
				tabline = 100,
				winbar = 100,
			}
		},
		sections = {
			lualine_a = {'mode'},
			lualine_b = {'branch', 'diff', 'diagnostics'},
			lualine_c = {{'filename', path = 1}},
			lualine_x = {dap_status, 'lsp_status'},
			lualine_y = {'filetype'},
			lualine_z = {'progress', 'location'}
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {{'filename', path = 1}},
			lualine_x = {'location'},
			lualine_y = {},
			lualine_z = {}
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = { 'fugitive', 'nvim-dap-ui' },
	})
end

return lualine
