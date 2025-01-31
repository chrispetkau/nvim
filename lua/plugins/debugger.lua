local debugger = {}

function debugger.setup()
	require('telescope').load_extension('dap')

	local dap = require("dap")
	vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "SignColumn", linehl = "", numhl = "" })
	local root = require("util").get_project_directory()
	local executable = require("user").get_project_name() .."_steam_r"
	local bin = root.."/bin"
	dap.configurations.lua = {
		{
			name= executable.." [slow]",
			type= "lua",
			request= "launch",
			workingDirectory= bin,
			sourceBasePath= root.."/data",
			executable= bin.."/"..executable..".exe",
			arguments= "-enable_lua_debugger",
			listenPublicly= false,
			listenPort= 56789,
			encoding= "UTF-8",
			env= {}
		},
	}
	dap.adapters.lua = {
		type = "executable",
		command = root.."/foreign/tools/VSCodeLuaDebug/Extension/DebugAdapter.exe",
		-- command = "D:/source_control_testing/rotwood/foreign/tools/VSCodeLuaDebug/DebugAdapter/bin/Release/DebugAdapter.exe",
		args = {},
	}

	require("dapui").setup()
end

return debugger
