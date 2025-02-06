local opts = {}

function opts.setup()
	vim.opt.tabstop = 4
	vim.opt.shiftwidth = 4
	vim.opt.number = true
	vim.opt.relativenumber = true
	vim.opt.cursorline = true
	vim.opt.colorcolumn = {120}
	vim.opt.signcolumn = "yes"
	--vim.opt.hover_with_actions = true
	--vim.opt.auto_focus = true
	vim.opt.ignorecase = true
	vim.opt.smartcase = true
	vim.opt.wrap = false
	-- local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	-- vim.opt.rtp:prepend(lazypath)

	--Set completeopt to have a better completion experience
	-- :help completeopt
	-- menuone: popup even when there's only one match
	-- noinsert: Do not insert text until a selection is made
	-- noselect: Do not select, force to select one from the menu
	-- shortness: avoid showing extra messages when using completion
	-- updatetime: set updatetime for CursorHold
	vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
	vim.opt.shortmess = vim.opt.shortmess + { c = true}
	vim.api.nvim_set_option('updatetime', 300)

	-- Enable Treesitter-based folding
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

	-- Ensure folds start open
	vim.opt.foldenable = true
	vim.opt.foldlevel = 99
	vim.opt.foldlevelstart = 2
end

return opts
