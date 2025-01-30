--[[ init.lua ]]
-- To reload init.lua from within Neovim: >:source $MYVIMRC
-- To change "projects" from within Neovim you can change its root directory: >:cd c:\klei\rotwood\data\script
--
-- FAQ
-- Q: Why do I have to double-escape to exit a Telescope dialog?
-- A: Because everything in Neovim is a buffer. You start the dialog in Insert mode so you can type into your grep box.
-- That creates the list of options. Then you <Esc> to enter Normal mode to navigate to your choice. It only feels
-- unnatural when you just want to abort.

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("opts").setup()

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error 
-- Show inlay_hints more frequently 
vim.cmd([[
	autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

	" Automatically resize buffers on window resize
	autocmd VimResized * wincmd = 

	" Auto update buffers if reloaded from outside
	autocmd FocusGained,BufEnter * :checktime
]])

require("plugins.lspconfig").setup()
require("plugins.cmp").setup()
require("plugins.diagnostic").setup()
require("plugins.treesitter").setup()
require("plugins.debugger").setup()

require('Comment').setup(require("keymaps").get_comment_plugin_setup_spec())

-- Format on save!
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.rs",
	callback = function()
		vim.lsp.buf.format({ async = false })
	end
})

require('onedark').setup {
	style = 'darker'
}
require('onedark').load()

-- Decrease font size a bit so we can fit 2 120-line windows side by side.
vim.o.guifont = "Cascadia Code:h13:#h-slight"

-- Setup keymaps after everything else, so we can bind to anything that we set up.
require("keymaps").setup()
