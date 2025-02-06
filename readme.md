# Installation
1. Clone with `git clone https://github.com/chrispetkau/nvim.git --recurse-submodules`. This installs all Neovim
plugins.
2. Install ripgrep (fast regular expression utility) to support ... Telescope?.
3. Install [Zig](https://ziglang.org/download/) (for compiling parsers for Treesitter). Add its install path to your 
Path Environment Variable.
4. Install fd (fast file finder utility) to support ...Telescope?. Add its install path to your Path Environment 
Variable.
5. Install lua-language-server for Lua language server protocol support. Add its install path to your Path Environment 
Variable.
6. Install the Roslyn C# LSP binaries in nvim-data as per the ["Installation: Manually"](https://github.com/seblyng/roslyn.nvim).

# Tips
1. Use a Vim tutorial to learn the basics. Easiest thing is to just type `:Tutor` from within Neovim.
2. If you have a programmable keyboard, move your arrow keys to the home row rather than learning hjkl navigation.  
You are then free to choose whatever keyboard layout you like, e.g. Colemak-DH.
3. Plugins supply 2 things: Vim commands and Lua APIs. Invoke the Vim commands via `:` within Neovim. Use the Lua APIs
from your custom Lua code, driven from init.lua.
4. `Ctrl-Tab` at the Vim command line is auto-complete. Navigate the list with `Ctrl-N` for next, `Ctrl-P` for previous, and
select with Enter.
5. `:b`uffer `d`elete closes the current buffer.
6. `:e`dit `.` opens a file browser to allow you to browse and open a file (`<leader>o`pen file is generally better
though).
7. Buffers are not files, but usually buffers contain files. The distinction is there so that Vim can put dynamically
generated text into buffer (e.g. results of a grep search). All buffers can be navigated with standard Vim controls,
which makes interacting with tools feel like editing text.
8. `Ctrl-W`indow followed by a direction key moves to the window in that direction. Can also follow with `v`ertical
split or horizontal `s`plit. You can also `c`lose a window.
9. Use vim.api.nvim_create_user_command(name, lua_function, TODO_params?) to bind any of your custom lua functions
to commands you can execute on Neovim's command line.

# Mnemonics
Here are the mnemonics I use for my keymaps:
- code `<leader>a`ction {`r`ename, `h`over, `f`ix}
- `<leader>d`ebugger {`o`pen, `d`elete, `t`oggle}
- `<leader>f`ind {`b`uffer, `h`elp tag, `f`ile, `d`irectory, `g`rep}
- `<leader>e`rror {`n`ext, `p`revious, `e`rror of current}
- `<leader>g`o {`f`ile, `r`eferences, `g`it, `i`ncoming, `o`utgoing, `d`efinition}
- `g`o do an arbitrary thing because g is convenient {`c`omment line, comment `b`lock}
