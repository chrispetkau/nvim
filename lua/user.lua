-- Add this file to your .gitignore and edit it to match the system on which it is installed.

local user = {}

-- The directory where we install Klei projects.
function user.get_klei_directory()
	return "d:"
end

function user.get_project_name()
	return "rotwood"
end

function user.get_project_install_name()
	return "rotwood"
	-- return "rotwood"
end

-- Folder in c:/users to use.
function user.get_user_name()
	return "chris petkau"
end

function user.get_vscode_extensions_directory()
	return 'C:/users/chris petkau/.vscode/extensions/'
end	

-- Directories of interest on this system.
function user.get_project_directories()
	local result = require("util").get_standard_directories()
	local directories = {
		user.get_klei_directory().."/oni/game/assets/scripts",
		user.get_klei_directory().."/oni/game/assets/streamingassets/dlc/dlc4",
		user.get_klei_directory().."/oni",
	}
	for _, directory in ipairs(directories) do
		table.insert(result, directory)
	end
	return result
end

return user
