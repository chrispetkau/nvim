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
	})
end

return lualine
