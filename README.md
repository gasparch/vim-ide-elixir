# vim-ide-elixir

Highly opinionated setup of plugins to start programming in Elixir in minutes.

Aim of the project is to give reasonable preset of defaults for Elixir-based development to
avoid laborious task of finding and tuning of plugins/themes.

## Features
 * Navigation
  * Jump to module/function definitions
  * Module/function/callback window for navigating in single file
  * Fuzzy search by function/module name in file
  * Fuzzy filename search in project
  * Navigation to Elixir/Erlang source code
 * Editing
  * Line comment/uncomment
  * Autocompletion of module/function names
  * Autodetection of spacing format in your project (tab/spaces)
  * Removal of trailing spaces
  * Reformatting code (hashes, assignments, etc)
 * Other
  * Colorschemes for Elixir programming
  * Git integration directly from Vim.
  * Viewing of Module/function documentation
  * Restore buffer position on load
  * Clutter free vim-airline settings


See sections below for usage instructions and shortcuts.

## Installation

Right now only [pathogen](https://github.com/tpope/vim-pathogen) installation is supported.
Manual and Vundle methods are not supported.
Following command with download plugin and all extras it uses.

```sh
cd ~/.vim/bundle
git clone https://github.com/gasparch/vim-ide-elixir.git vim-ide-elixir
cd ~/.vim/bundle/vim-ide-elixir
git submodule update --init --recursive
```

Update your `~/.vimrc` to contain following line instead of just `pathogen#infect`.

```vim
execute pathogen#infect("bundle/{}", "bundle/vim-ide-elixir/bundle/{}")
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
git pull
git submodule update --remote --merge
```

## Source browsing

Tagbar most of the time shows correct arity on functions and does not report multiple function clauses.
GenServer callbacks moved to separate group.

## Shortcuts

`F4` for opening Tagbar.
`Ctrl-@` to use Ctrl-P search on function names and quick jump on them
`<Leader>l` to fuzzy search text in file





