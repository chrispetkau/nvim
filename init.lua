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

vim.cmd([[
	" TODO delete, I think. We don't need this. It shows up when we arrive at an error. It interferes with hover text.
	" Show error when cursor is on it
	" autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

	" Automatically resize buffers on window resize
	autocmd VimResized * wincmd = 

	" Auto update buffers if reloaded from outside
	autocmd FocusGained,BufEnter * :checktime

	" Format *.rs files on save
	autocmd BufWritePre *.rs lua vim.lsp.buf.format({ async = false })

	" Keep folds open after saving
	autocmd BufWritePost * silent! mkview | silent! loadview

	" TODO does so many weird things and doesn't seem to work.
	" Re-source Neovim configuration Lua files.
	" ** means any sub-folderr
	" <afile> is file that triggered the event.
	" autocmd BufWritePost $HOME/AppData/Local/nvim/**/*.lua lua require("util").reload_nvim_lua_file(vim.fn.expand("<afile>"))

	" Add some keymaps specific to Fugitive buffers.
	autocmd FileType fugitive lua require("keymaps").install_fugitive_keymaps()

	autocmd FileType copilot-chat lua require("keymaps").install_copilot_chat_keymaps()

	" Add some keymaps for working with Cargo.toml files via cargo.vim.
	autocmd BufRead,BufNewFile Cargo.toml lua require("keymaps").install_cargo_toml_keymaps()
]])

require("plugins.lspconfig").setup() -- Language Server Protocol
require("plugins.cmp").setup() -- Auto-completion
require("plugins.diagnostic").setup() -- ???
require("plugins.treesitter").setup() -- File-type-based formatting??
require("plugins.debugger").setup() -- Debugger Adapter Protocol
require("plugins.crates").setup() -- Cargo.toml support
require("plugins.trouble").setup() -- Diagnostics
require("plugins.dressing").setup() -- UI improvements
require("plugins.render_markdown").setup() -- Improved .md rendering
require("plugins.img_clip").setup() -- Embed images in .md
require("plugins.copilot_chat").setup() -- Chat with Copilot

require('Comment').setup(require("keymaps").get_comment_plugin_setup_spec())

require('onedark').setup {
	style = 'darker'
}
require('onedark').load()

-- Decrease font size a bit so we can fit 2 120-line windows side by side.
vim.o.guifont = "Cascadia Code:h13:#h-slight"

require('plugins.lualine').setup()

-- Setup keymaps after everything else, so we can bind to anything that we set up.
require("keymaps").setup()
