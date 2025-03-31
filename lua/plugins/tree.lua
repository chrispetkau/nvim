local tree = {}

function tree.disable_netrw()
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1
end

function tree.setup()
	require("nvim-tree").setup({
		update_focused_file = {
			enable = true,
		},
	})
end

return tree
