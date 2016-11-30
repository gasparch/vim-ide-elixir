
# vim-ide-elixir

Highly opnionated setup of plugins to start programming in Elixir in minutes. 

Aim of the project is to give reasonable preset of defaults for elixir-based development to
avoid laborous tuning of plugins/themes.


## Source browsing

Tagbar most of the time shows correct arity on functions and does not report multiple function clauses.
GenServer callbacks moved to separate group. 

## Shortcuts

`F4` for opening Tagbar.
`Ctrl-@` to use Ctrl-P search on function names and quick jump on them
`<Leader>l` to fuzzy search text in file

## Starting using plugin
Right now initialization from inside the plugin does not work properly.

If you are using pathogen please replace your `pathogen#infect` line with following.

```vim
execute pathogen#infect("bundle/{}", "bundle/vim-ide-elixir/bundle/{}")
```

## how to initialize submodules
```
git submodule update --init --recursive
```

## how to update submodules
```
git submodule update --remote --merge
```


- needs exuberant-ctags installed
```
apt-get install exuberant-ctags
```


