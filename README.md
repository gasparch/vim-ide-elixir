# vim-ide-elixir

Highly opinionated setup of plugins to start programming in Elixir in minutes.

Aim of the project is to give reasonable preset of defaults for Elixir-based development to
avoid laborious task of finding and tuning of plugins/themes.

## Features
 * Navigation
  * Jump to module/function definitions
  * Module/function/callback list window for navigating in single file
  * Fuzzy search by function/module name in file
  * Fuzzy filename search in project
  * Navigation to Elixir/Erlang source code
  * Jump between source and ExUnit test files automatically
 * Editing
  * Automatic folding of functions and tests
  * Line comment/uncomment shortcuts
  * Autocompletion of module/function names
  * Autodetection of spacing format in your project (tab/spaces)
  * Removal of trailing spaces
  * Reformatting code (hashes, assignments, etc)
 * Compile and testing
  * Compile project from and jump to errors/warnings
  * Run ExUnit tests and jump to errors
  * Run ExUnit tests on source save and just to errors
 * Other
  * Colorschemes for Elixir programming
  * Git integration directly from Vim.
  * Viewing of Module/function documentation
  * Restore buffer position on load
  * Clutter free vim-airline settings


See [cheat sheet](CHEATSHEET.md) for quick overview of functionality and shortcuts offered.
Read below for detailed usage instructions.

## Motivation

Finding, installing and tuning Vim plugins can be quite frustating and time
consuming task.  Especially making sure they do not conflict with each other
and that they use consistent shortcuts.

Also it is easy to miss some useful ones in a wast variety of Vim plugins.
Vim-Ide-Elixir offers curated set of plugins, which are tuned to seamlessly
work together. Also some new pluging/settings provided for more comfortable
work.

Plugin updates also come in (tested) bundles, which assures that changes in one
plugin will not break others.

## Installation

Right now only [pathogen](https://github.com/tpope/vim-pathogen) installation is supported.
Manual and Vundle methods are not supported.
Following command with download plugin and all extras it uses.

```sh
cd ~/.vim/bundle
git clone https://github.com/gasparch/vim-ide-elixir.git vim-ide-elixir
cd ~/.vim/bundle/vim-ide-elixir
./install.sh
```

Follow instructions of install script.

**Manually install**

Update your `~/.vimrc` to contain following line instead of just `pathogen#infect`.

```vim
execute pathogen#infect("bundle/{}", "bundle/vim-ide-elixir/bundle/{}")
```

Also in the very end of the file add
```vim
call vimide#init()
```

### Installing required utilities

In order to properly work this plugin requires number of additional programs installed.

#### Exuberant Ctags
For now you will need [Exuberant Ctags](http://ctags.sourceforge.net/) in order to get function search & tagbar working.
Version 5.5 or higher is required.

**Ubuntu installation**

```sh
sudo apt-get install -y exuberant-ctags
```

#### Checking out Elixir and Erlang source code

In order to be able to just to Elixir/Erlang core libraries sources, you need them checked out from github.
Run provided script to automatically check out matching Erlang/OTP and Elixir versions.

```vim
./get_otp_elixir_sources.sh
```

## Updating plugin & submodules
```sh
cd ~/.vim/bundle/vim-ide-elixir
./update.sh
```

## Editing

Vim-Elixir-IDE tries to smart guess your tabulation settings and set it for the
file using [vim-sleuth](https://github.com/tpope/vim-sleuth).

## Source browsing

Tagbar most of the time shows correct arity on functions and does not report
multiple function clauses.  GenServer callbacks moved to separate group.

## Compiler and ExUnit integration

Compiler and ExUnit integration provided with vim-elixir-exunit module, which
is designed to work with vim-elixir-ide.  All commands can be executed in any
subdirectory of project, it will find closest `mix.exs` in file hierarchy.

Following commands and shortcuts are available:

#### Compiling project

 * `:make` will invoke `mix compile` and show only errors in quickfix list.
    Normal `:cl` `:copen` `:cnext` `:cprev` commands are available, but use of
    `[e` and `]e` is recommended.
 * `:cw` is redefined to show quickfix window always at bottom, even if split exists.
 * `:MixCompile` will compile files (`mix compile`) and show errors and warnings. 
     All messages are loaded in quickfix.
 * `:MixCompile!` will recompile all project (`mix compile --force`) and show
    errors and warnings.  All messages are loaded in quickfix.
 * `<Leader>xc` and `<Leader>x!` invoke `:MixCompile` and `:MixCompile!` respectively
 * `[e` and `]e` provide smart navigation between errors/warnings in quickfix,
    also trying to jump to correct column name (e.g. identificator if warning is
    'variable foo is not used').


#### Running ExUnit

 All ExUnit commands suppress warning messages in quickfix window. If you want
 to check warnings in project - use compile commands above. ExUnit output is
 cluttered by itself, so no need to add more information with warnings.

 I recommend Vim8.x + XTerm as you can have much more with it - see below.

 **Functionality for Vim version 7.x:**

 * `ExUnitQfRunAll` or `<Leader>xa` runs ExUnit tests on whole project 
    (`mix test`) and shows output in quickfix window
 * `ExUnitQfRunFile` or `<Leader>xf` runs ExUnit tests on current file
    (`mix test path/to/file`) and shows output in quickfix window
 * `ExUnitQfRunLine` or `<Leader>xl` runs ExUnit tests on current line of
    current file, effectively running just one test.
    (`mix test path/to/file.exs:123`) and shows output in quickfix window
 * `ExUnitQfRunRerun` or `<Leader>xx` repeats last executed command (ExUnitQfRunAll/File/Line)

 You can navigate with `[e` and `]e` between errors. Both test name and exact
 failed assert lines are available in quickfix list. Latter is more useful most of the time.

 Use `:copen` or `:cw` to check quickfix window, because most relevant ExUnit
 output is available there as well, g.e. assert failure messages, crash messages
 and etc.

 Some less relevant ExUnit output (like GenServer crash logs and etc) are
 stripped to preserve space in quickfix window.


 **Functionality for Vim version 8.x:**

 Vim 8 brings asynchronous jobs and allows to build much more real IDE-like experience.

 This mode allows you to start XTerm (or any other terminal emulator) next to
 your Vim/GVim instance and have all output of ExUnit shown there, while also
 having possiblity to jump over errors using quickfix. This also allows you to
 close/reopen Vim/GVim without closing XTerm and still have output in it.
 Basically you position it once on your screen and then you are free to run
 open and close Vim as much times as you want.

 Also this mode automatically re-runs your tests on any Elixir files saved in
 the project, removing hassle of switching and running them by hand. 

 Test run status is shown in status line, so you don't need to check it manually.

 To check which test is executing now, especially if you just re-run it, see
 XTerm window title - it shows text like 'ExUnit test/foo\_test.esx'.

 If you combine that with [ex\_unit\_notifier](https://github.com/navinpeiris/ex_unit_notifier) it
 becomes very easy to see if your tests fail or pass.

 Available commands: 

 * `ExUnitWatchAll` or `<Leader>wa` runs ExUnit tests on whole project 
    (`mix test`) and shows output in xterm + quickfix window
 * `ExUnitWatchFile` or `<Leader>wf` runs ExUnit tests on current file 
    (`mix test path/to/file`) and shows output xterm + in quickfix window
 * `ExUnitWatchLine` or `<Leader>wl` runs ExUnit tests on current line of
    current file, effectively running just one test.
    (`mix test path/to/file.exs:123`) and shows output in xterm + quickfix window
 * `ExUnitWatchRerun` or `<Leader>ww` runs again last executed command
   (ExUnitWatchAll/File/Line). Most probably you do not need to run it manually,
   as it is executed on each save of Elixir file in current project.
 * `ExUnitWatchStop` or `<Leader>ws` or `<Leader>wc` (both stop/cancel mnemonics) stops
   automatic execution of tests on save.

 Use `[e` and `]e` to navigate test errors.


 **Note**

 All `mix test` commands executed with `--seed 0` parameter which forces
 execution from top to down of test file. If you want randomized execution
 sequence to check hidden errors in tests - you will need to run tests
 manually.


 









