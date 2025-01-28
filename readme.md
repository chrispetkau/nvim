#Installation
There are additional installation steps after cloning https://github.com/chrispetkau/nvim.git.
1. Run git_add_submodules.bat to install all Neovim packages.
2. Install ripgrep (fast regular expression utility) to support ... Telescope?.
3. Install [Zig](https://ziglang.org/download/) (for compiling parsers for Treesitter). Add its install path to your 
Path Environment Variable.
4. Install fd (fast file finder utility) to support ...Telescope. Add its install path to your Path Environment 
Variable.
5. Install lua-language-server for Lua language server protocol support. Add its install path to your Path Environment 
Variable.

#Tips
1. Use a Vim tutorial to learn the basics. Easiest thing is to just type `:Tutor` from within Neovim.
2. If you have a programmable keyboard, move your arrow keys to the home row (probably via a layer) rather than
learning h, j, k, l navigation. The only point of h, j, k, l is to move your navigation keys to the home row, which
can be done directly with a programmable keyboard. Furthermore, you are then free to choose whatever keyboard layout
you like, e.g. Colemak-DH.
3. Plugins supply 2 things: Vim commands and Lua APIs. Invoke the Vim commands via `:` within Neovim. Use the Lua APIs
from your custom Lua code, driven from init.lua.
4. Ctrl-Tab at the Vim command line is auto-complete. Navigate the list with Ctrl-N for next, Ctrl-P for previous, and
select with Enter.
5. `:``b`uffer `d`elete closes the current buffer.
6. `:``e`dit `.` opens a file browser to allow you to browse and open a file (`<leader>o`pen file is generally better
though).
7. Buffers are not files, but usually buffers contain files. The distinction is there so that Vim can put dynamically
generated text into buffer (e.g. results of a grep search). All buffers can be navigated with standard Vim controls,
which makes interacting with tools feel like editing text.
8. `Ctrl-W`indow followed by a direction key moves to the window in that direction.

#Mnemonics
Here are the mnemonics I use for my keymaps:
code `a`ction {`r`ename}
`d`ebugger {`o`pen, `d`elete, `t`oggle}
`f`ind {`b`uffer, `h`elp tag}
`e`rror {`n`ext, `p`revious}
