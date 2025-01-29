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
	-- Define a list of directories
	local directories = {
		"d:/source_control_testing/rotwood/data/scripts",
		"d:/source_control_testing/rotwood/source",
		"c:/users/chris petkau/appdata/local/nvim",
	}

	return util.select("Select Directory", directories, function(directory)
		vim.cmd("cd " .. vim.fn.fnameescape(directory))
		-- TODO this print is not visible
		print("Changed directory to " .. directory)
	end)
end

return util
