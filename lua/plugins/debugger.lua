local debugger = {}

function debugger.setup()
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
end

return debugger
