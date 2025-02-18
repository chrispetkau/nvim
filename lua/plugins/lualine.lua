local lualine = {}

local function dap_status()
    local session = require("dap").session()
    -- return session and " DAP Connected" or " DAP Disconnected"
    return session and "" or ""
end

function lualine.setup()
	require('lualine').setup({
		extensions = { 'fugitive', 'nvim-dap-ui' },
		sections = {
			lualine_x = { dap_status, 'filetype', },
		},
		-- tabline = {
		-- 	lualine_a = {},
		-- 	lualine_b = {'branch'},
		-- 	lualine_c = {'filename'},
		-- 	lualine_x = {},
		-- 	lualine_y = {},
		-- 	lualine_z = {'tabs'},
		-- },
	})
end

return lualine
