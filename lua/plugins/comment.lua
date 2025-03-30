local comment = {}

function comment.setup()
	require('Comment').setup(require("keymaps").get_comment_plugin_setup_spec())
end

return comment
