local debugger = {}

function debugger.setup()
	require('telescope').load_extension('dap')

	local dap = require("dap")
	vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "SignColumn", linehl = "", numhl = "" })
	local root = require("util").get_project_directory()
	local executable = require("user").get_project_name() .."_steam_r"
	local bin = root.."/bin"
	dap.adapters.lua = {
		type = "executable",
		command = root.."/foreign/tools/VSCodeLuaDebug/Extension/DebugAdapter.exe",
		-- command = "D:/source_control_testing/rotwood/foreign/tools/VSCodeLuaDebug/DebugAdapter/bin/Release/DebugAdapter.exe",
		args = {},
	}
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
	local vstuc_path          = 'C:/users/chris petkau/.vscode/extensions/visualstudiotoolsforunity.vstuc-1.1.0/bin/'
	dap.adapters.vstuc        = {
		type = 'executable',
		command = 'dotnet',
		args = { vstuc_path .. 'UnityDebugAdapter.dll' },
		name = 'Attach to Unity',
	}
	dap.configurations.cs     = {
		{
			type = 'vstuc',
			request = 'attach',
			name = 'Attach to Unity',
			logFile = vim.fs.joinpath(vim.fn.stdpath('data')) .. '/vstuc.log',
			projectPath = function()
				local path = vim.fn.expand('%:p')
				while true do
					local new_path = vim.fn.fnamemodify(path, ':h')
					if new_path == path then
						return ''
					end
					path = new_path
					local assets = vim.fn.glob(path .. '/Assets')
					if assets ~= '' then
						return path
					end
				end
			end,
			endPoint = function()
				local system_obj = vim.system({ 'dotnet', vstuc_path .. 'UnityAttachProbe.dll' }, { text = true })
				local probe_result = system_obj:wait(2000).stdout
				if probe_result == nil or #probe_result == 0 then
					print('No endpoint found (is unity running?)')
					return ''
				end
				for json in vim.gsplit(probe_result, '\n') do
					if json ~= '' then
						local probe = vim.json.decode(json)
						for _, p in pairs(probe) do
							if p.isBackground == false then
								return p.address .. ':' .. p.debuggerPort
							end
						end
					end
				end
				return ''
			end
		},
	}

	require("dapui").setup({
		layouts = {
			{
				elements = {
					-- Left sidebar with breakpoints and stacktrace
					{ id = "scopes",      size = 0.40 },  -- Larger
					{ id = "breakpoints", size = 0.20 },
					{ id = "stacks",      size = 0.20 },
					{ id = "watches",     size = 0.20 },
				},
				size = 100,  -- Width of left sidebar
				position = "left",
			},
			-- {
			-- 	elements = {
			-- 		-- Bottom panel with console and repl
			-- 		{ id = "repl",    size = 0.75 },  -- Make REPL larger
			-- 		{ id = "console", size = 0.25 },  -- Smaller
			-- 	},
			-- 	size = 10,  -- Height of bottom panel
			-- 	position = "bottom",
			-- },
		},
		floating = {
			max_height = 0.8, -- Adjust floating window size
			max_width = 0.8,
			border = "rounded",
		},
		controls = {
			enabled = false, -- Disable DAP controls UI if not needed
		},
	})
end

return debugger
