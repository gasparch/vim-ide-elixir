

# Vim-Elixir-IDE

List of defined shortcuts and (some) commands and some useful native Vim
shortcuts/commands:

#### Navigation
 **Between Files**
 * `<Ctrl-P>` to start navigation in current project
    * `<Ctrl-P>` to recall last fuzzy search text
    * enter text to fuzzy filter file names
    * `<Ctrl-z>` allows to select multiple files
    * `<Ctrl-k>`/`<Ctrl-j>` or arrows move up/down in the list
    * `<Ctrl-v>` opens selected files in vertical split
    * `<Ctrl-s>` opens selected files in horizontal split

 **In file**
 * `<F1>` shows Elixir docs for function under cursor.
 * `<Ctrl-@>` opens functions list for fuzzy search
 * `<Leader>l` opens all lines in the file for fuzzy search
 * `<Ctrl-]>` jump to definition of function/module under cursor
 * `<Ctrl-T>` return from previous jump
 * `<Leader>;;` search word under cursor, show match list and propmt to jump
 * `<Ctrl-Enter>` same as above, but only in GVim
 * `%` jumps to matching do/end tag, brackets, braces, etc. Also can be used
   after `<Ctrl-V>` or `v` to select function/text block.

 Use Vim marks `:help marks` to navigate quickly between several positions in
 file or between files.

 * `ma` .. `mz` set mark which is available only in current file
 * `mA` .. `mZ` set global mark which is available across files.
 * ```a`` .. ```z`` jumps between marks in current file (so many files may have `ma` mark)
 * ```A`` .. ```Z`` jumps between global marks and switches buffers if necessary.
 * ```.`` jumps to last edited position
 * ```````` jumps to position before last jump (basically jumps between 2 positions)

 **In file using Tagbar**

 * `<F4>` opens/closes Tagbar window.
 * `<Enter>` or click on function name takes you to function definition.
 * `<p>` on function name takes you to function definition, but focus stays in tagbar.
 * `<P>` on function name opens function in preview window.

 More on [tagbar page](https://majutsushi.github.io/tagbar/).

#### Editing
 * `<F2>` to save current file to disk.
 * `ZZ` to save current file and close it. In GVim it keeps editor open.
 * `:bdd` closes current buffer, but keeps window split.
 * `<F3>` to toggle current fold open/close.
 * `zR` to open all folds.
 * `zM` to close all folds.
 * `<Ctrl-K><Ctrl-L>` highlight word under cursor in whole file.
 
 * `<Ctrl-K><Ctrl-P>` toggles comment on current line/selection
 * `<Ctrl-K><Ctrl-[>` adds comment on current line/selection
 * `<Ctrl-K><Ctrl-]>` removes comment from current line/selection
 *It is impossible at all to map `<Ctrl-/>` in Vim :(. So please get used to these shortcuts.*

 * `<Leader>=` to align vertically `=>` map keys.
 * `<Leader>-` to align vertically `->` function/case clauses.
 * `<Leader>:` to align vertically `:` map or Keyword list keys.
 * `<Leader>eq` to align vertically `=` assignment signs.

 * `<Leader>$` or `<Leader>trailing` to remove trailing spaces from all lines.

#### Compilation
 * `:make` to compile changed files and show only errors
 * `<Leader>xc` to compile changed files and show errors+warnings
 * `<Leader>x!` to compile whole project and show errors+warnings
 * `:cw` to open quickfix window
 * `]e` go to next error/warning
 * `[e` go to previous error/warning

#### ExUnit

 * `<Leader>xa` runs ExUnit tests on whole project
 * `<Leader>xf` runs ExUnit tests on current file
 * `<Leader>xl` runs ExUnit tests on current line of current file
 * `<Leader>xx` repeats last executed command

 * `<Leader>wa` runs in background ExUnit tests on whole project
 * `<Leader>wf` runs in background ExUnit tests on current file
 * `<Leader>wl` runs in background ExUnit tests on current file:line
 * `<Leader>ww` runs again in background last executed command
 * `<Leader>ws` or `<Leader>wc` stop automatic test execution on save.

 * `:cw` to open quickfix window
 * `]e` go to next error
 * `[e` go to previous error

#### Git integration
 * `:Gstatus` - show modified files and staged status
    * `-` (in normal mode) on file name moves between staged/unstaged mode
    * `p` (in normal mode) on file name allows to stage/unstage only parts of the file.
    * `d` (in normal mode) on file name opens diff between working copy and repository
    * `:Gcommit` starts commit of staged files (use save/exit to commit, clear
        message to abort)
 * `:Gdiff` - shows diff between current file and repository

 More on [vim-figutive page](https://github.com/tpope/vim-fugitive).

#### Other

 * `<Ctrl-X>` opens XTerm in current directory
