local util = {}

function util.focus_dap_ui_element(element)
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

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values

-- Use telescope to select from a list of options and execute an action with the selection as the argument.
-- The text box is a grep to filter options; direction keys to navigate options; enter to select.
function util.select(title, options, action)
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
function util.select_directory()
	return util.select("Select Directory", require("user").get_project_directories(), function(directory)
		-- TODO modify this so we can use it with :wcd and :tcd for window-local and tab-local directories respectively
		vim.cmd("cd " .. vim.fn.fnameescape(directory))
		-- TODO this print is not visible
		print("Changed directory to " .. directory)
	end)
end

function util.select_code_action()
	vim.lsp.buf.code_action()
    --[[ local params = vim.lsp.util.make_range_params()
    params.context = {
		apply = false,
		-- only = { "quickfix", }, -- Optional filters
		only = { "source", "quickfix", "refactor" }, -- Optional filters
		diagnostics = vim.diagnostic.get(0),
		-- diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
	}
	vim.lsp.buf_request_all(0, "textDocument/codeAction", params, function(response_messages)
		local function handle_response(response_message)
			local err = response_message.error
			if err then
				print(err.message or "Error message for non-nil error is nil!?!?")
				return
			end
			local code_actions = response_message.result
			if not code_actions or vim.tbl_isempty(code_actions) then
				print("No available code actions")
				return
			end

			-- Extract action titles
			local options = {}
			for i, action in ipairs(code_actions) do
				options[i] = action.title
			end

			local function execute_action(action)
				if action.edit then
					print("execute_action: edit")
					vim.lsp.util.apply_workspace_edit(action.edit, ctx.client_id)
				end
				if action.command then
					print("Execute code action: "..action.title)
					vim.lsp.buf.execute_command(action.command)
				else
					print("Failed to execute code action: "..action.title)
				end
				-- -- If the action contains edits, apply them
				-- if action.edit then
				-- 	print("execute_action: edit")
				-- 	vim.lsp.util.apply_workspace_edit(action.edit, ctx.client_id)
				-- end
				-- -- If the action is a command, execute it
				-- if action.command then
				-- 	local command = action.command
				-- 	if type(command) == "table" and command.command then
				-- 		print("execute_action: command as table")
				-- 		vim.lsp.buf.execute_command(command)
				-- 	else
				-- 		print("execute_action: command as string")
				-- 		vim.lsp.buf.execute_command(action)
				-- 	end
				-- end
				-- if action.edit or type(action.command) == "table" then
				-- 	vim.lsp.buf.execute_command(action)
				-- else
				-- 	vim.lsp.buf_request(0, "workspace/executeCommand", action)
				-- end
			end

			-- Use util.select() to present actions
			util.select("Select Code Action", options, function(selected)
				for _, action in ipairs(code_actions) do
					if action.title == selected then
						execute_action(action)
						return
					end
				end
			end)
		end
		for _, response_message in pairs(response_messages) do
			handle_response(response_message)
		end
    end) ]]
end

function util.get_project_directory()
	local user = require("user")
	return user.get_klei_directory().."/"..user.get_project_install_name()
end

function util.get_standard_directories()
	local user = require("user")
	local project = util.get_project_directory()
	return {
		project.."/data/scripts",
		project.."/source",
		user.get_klei_directory(),
		"c:/users/"..user.get_user_name().."/appdata/local/nvim",
	}
end

function util.git_log_author_date()
	return ':G log --graph --all --decorate --pretty=format:"%h %ad | %an | %s" --date=format:"%Y-%m-%d %H:%M:%S"<CR>'
end

function util.reload_nvim_lua_file(filepath)
	local filename = filepath:gsub("%.lua$", ""):gsub("lua\\", ""):gsub("/", "."):gsub("\\", ".")
    package.loaded[filename] = nil
    require(filename)
    vim.cmd("source " .. vim.fn.expand("$MYVIMRC"))
    print("Reloaded:", filename)
end

return util
