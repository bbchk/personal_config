Here's a comprehensive list of standard Neovim keybindings organized by category. These are the default mappings you should avoid overwriting unless you intentionally want to replace their functionality:


how to w or ww only the selected area?

## Movement
# - `h`, `j`, `k`, `l` - Left, down, up, right
# - `w`, `b`, `e` - Word forward, backward, end of word
# - `W`, `B`, `E` - WORD forward, backward, end of WORD
# - `0`, `^`, `$` - Beginning of line, first non-blank, end of line
# - `gg`, `G` - Top of file, bottom of file

# - `H`, `M`, `L` - Top, middle, bottom of screen

# - `{`, `}` - Previous/next paragraph
- `(`, `)` - Previous/next sentence
- `%` - Matching bracket/parenthesis
# - `f{char}`, `F{char}` - Find character forward/backward
# - `t{char}`, `T{char}` - Till character forward/backward
# - `;`, `,` - Repeat last f/t/F/T forward/backward
# - `*`, `#` - Search word under cursor forward/backward
# - `n`, `N` - Next/previous search result
# - `Ctrl-d`, `Ctrl-u` - Half page down/up
# - `Ctrl-f`, `Ctrl-b` - Full page down/up
# - `Ctrl-e`, `Ctrl-y` - Scroll down/up one line 

## Insert Mode
# - `i`, `I` - Insert before cursor, at beginning of line
# - `a`, `A` - Insert after cursor, at end of line
# - `o`, `O` - Open line below/above
- `s`, `S` - Substitute character/line
- `c{motion}` - Change text object
- `C` - Change to end of line
- `R` - Replace mode

## Delete/Cut
# - `x`, `X` - Delete character under/before cursor
# - `d{motion}` - Delete text object
# - `dd` - Delete line
- `D` - Delete to end of line

## Copy/Paste
# - `y{motion}` - Yank text object
# - `yy` or `Y` - Yank line
- `p`, `P` - Paste after/before cursor
- `"{register}` - Access specific register

## Undo/Redo
# - `u` - Undo
# - `Ctrl-r` - Redo
- `.` - Repeat last command

## Visual Mode
# - `v` - Character visual mode
# - `V` - Line visual mode
# - `Ctrl-v` - Block visual mode
- `gv` - Reselect last visual selection

## Search and Replace
# - `/pattern` - Search forward
- `?pattern` - Search backward
- `:s/old/new/` - Substitute on current line
- `:%s/old/new/g` - Substitute globally
- `:%s/old/new/g` - Substitute on selected text/area

## Marks and Jumps ???
- `m{letter}` - Set mark
- `'{mark}` - Jump to mark line
- `` `{mark}`` - Jump to mark position
- `''` - Jump to previous line
- `` `` `` - Jump to previous position
- `Ctrl-o` - Jump to older position
- `Ctrl-i` - Jump to newer position

## Folding ???
- `zf{motion}` - Create fold
- `zo`, `zc` - Open/close fold
- `zO`, `zC` - Open/close all folds recursively
- `za` - Toggle fold
- `zR`, `zM` - Open/close all folds

## Windows and Tabs ???
- `Ctrl-w` + `h/j/k/l` - Navigate windows
- `Ctrl-w` + `s` - Split horizontally
- `Ctrl-w` + `v` - Split vertically
- `Ctrl-w` + `c` - Close window
- `Ctrl-w` + `o` - Close other windows
- `Ctrl-w` + `=` - Equalize window sizes
- `Ctrl-w` + `+/-` - Resize window
- `gt`, `gT` - Next/previous tab
- `{count}gt` - Go to tab number

## Text Objects (used with operators like d, c, y)
- `iw`, `aw` - Inner/around word
- `is`, `as` - Inner/around sentence
- `ip`, `ap` - Inner/around paragraph
- `i"`, `a"` - Inner/around quotes
- `i'`, `a'` - Inner/around single quotes
- `i(`, `a(` - Inner/around parentheses
- `i[`, `a[` - Inner/around brackets
- `i{`, `a{` - Inner/around braces
- `it`, `at` - Inner/around tags
- `o` - move to either side of selection

## Command Mode
# - `:` - Enter command mode
# - `!` - Execute shell command
- `q:` - Command history window
- `q/` - Search history window

## Recording and Macros ???
- `q{letter}` - Start/stop recording macro
- `@{letter}` - Execute macro
- `@@` - Repeat last macro

## Special Commands
- `ZZ` - Save and quit
- `ZQ` - Quit without saving
# - `gq{motion}` - Format text
- `=` - Auto-indent
# - `>>`, `<<` - Indent/unindent line
- `~` - Toggle case !!!
- `gu{motion}`, `gU{motion}` - Lowercase/uppercase
- `J` - Join lines !!!
- `K` - Lookup keyword !!!
- `gf` - Go to file under cursor
- `Ctrl-a`, `Ctrl-x` - Increment/decrement number
# - `g Ctrl-a`, `g Ctrl-x` - Increment/decrement numbers in visual selection

## Insert Mode Special Keys
- `Ctrl-h` - Backspace
- `Ctrl-w` - Delete word
- `Ctrl-u` - Delete line
- `Ctrl-t`, `Ctrl-d` - Indent/unindent
- `Ctrl-n`, `Ctrl-p` - Next/previous completion
- `Ctrl-x Ctrl-f` - File completion
- `Ctrl-x Ctrl-l` - Line completion
- `Ctrl-r{register}` - Insert register contents

## Ex Commands (commonly used)
# - `:w` - Write/save
# - `:q` - Quit
# - `:wq` - Write and quit
# - `:e {file}` - Edit file
# - `:sp`, `:vsp` - Split window
# - `:tabnew` - New tab
# - `:help` - Help system

## Function Keys and Special
# - `F1` - Help (often mapped)
# - Function keys F2-F12 are typically available for custom mappings

# When creating custom keybindings, it's generally safe to use:
# - `<leader>` key combinations (leader is usually `\` by default)
# - Function keys (F1-F12)
# - Alt/Meta key combinations
# - Custom prefixes like `<Space>` or `,`
# - Unused letter combinations in normal mode (though be careful)

Always check if a key is already mapped with `:map {key}` before overwriting it, and consider using `:help {key}` to understand what functionality you might be replacing.
