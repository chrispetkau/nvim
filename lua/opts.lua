local opts = {}

function _G.MyFoldText()
    -- Gets the first non-whitespace characters of the fold
    local line = vim.fn.getline(vim.v.foldstart)
    -- return " " .. line .. "  (" .. (vim.v.foldend - vim.v.foldstart) .. " lines)"
    return line .. "  (" .. (vim.v.foldend - vim.v.foldstart) .. " lines)"
end

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

	local resolved_home = vim.fn.expand("$HOME")
	vim.opt.rtp:append(resolved_home .. "/AppData/Local/nvim/pack/third_party/start/nui.nvim")
	vim.opt.rtp:append("C:/Users/Chris Petkau/AppData/Local/nvim/pack/third_party/start/nui.nvim")

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
	-- TODO if no treesitter parser available, use "syntax" foldmethod to fold based on indentation
	vim.opt.foldmethod = "expr"
	vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	-- vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()" -- this function does not exist and so returns 0
	-- TODO this is not bad, but is it better than the default?
	vim.opt.foldtext = "v:lua.MyFoldText()"

	-- Ensure folds start open
	vim.opt.foldenable = true
	vim.opt.foldlevel = 99
	vim.opt.foldlevelstart = 99
	vim.opt.fillchars = 'fold: ,foldopen:,foldsep: ,foldclose:'
	vim.opt.foldcolumn = '1'

	-- This from avante.nvim documentation. Setting it to 3 means the last window will always have a status line.
	-- views can only be fully collapsed with the global statusline
	-- TODO ugh, no. We want each window to have its own status line.
	-- vim.opt.laststatus = 3
end

return opts
