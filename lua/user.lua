-- Add this file to your .gitignore and edit it to match the system on which it is installed.

local user = {}

-- The directory where we install Klei projects.
function user.get_klei_directory()
	return "c:/klei"
end

function user.get_project_name()
	return "rotwood"
end

function user.get_project_install_name()
	return "rotwood_svn_volcano"
	-- return "rotwood"
end

-- Folder in c:/users to use.
function user.get_user_name()
	return "chris petkau"
end

-- Directories of interest on this system.
function user.get_project_directories()
	local result = require("util").get_standard_directories()
	local directories = {
		user.get_klei_directory().."/rust",
		"c:/src/aoc-2024",
		"c:/src/qmk",
	}
	for _, directory in ipairs(directories) do
		table.insert(result, directory)
	end
	return result
end

return user
