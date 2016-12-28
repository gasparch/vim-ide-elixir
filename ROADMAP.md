
This is a roadmap of features planned for Vim-Elixir-IDE.

Items marked with x are done.

## Installation/upgrade
 x scripts to fetch Elixir/Erlang sources
 x scripts to download/install powerline fonts
 x scripts to download/install Hack font
 * scripts to pull updates (and switch submodules automatically)
 * make sure it is totally usable standalone, so that I can attract testers
   * test on our team first ;)))

## Functionality
 * make it load w/reasonable defaults in empty vim (top)
 * add sensibleDefaults plugin
 x add indentLine plugin to bundle (top)
 x setup Hack font for GUI + size changes

## Editing

 x compile time errors and jump to them
 x quickfix support for ExUnit test outputs + xterm integration (crashes/test fails)
 x test runner (test/test.watch) on project, file or current function
 x add switching between test/source file (`test file name == source + "_test.exs")

 * templates for GenServer/GenStage/etc modules (may be also snipMate)

 * highlight current identificator under cursor in function

 * syntax highlight for fprof dump file
 * syntax highlight for eprof dump file

 * snippets for ExUnit tests (integrate snipMate) + automatically get module name from alchemist.vim
 * snippets for GenServer callbacks
 * snippets for def/depf/defmodule

 * snippets for tracing fprof/eprof with some meaningful defaults

 * syntax highlights for style problems (missing spaces, too much space,
     trailing space, etc) (low)

 * fold big alias/import blocks
 * fold @moduledoc tags
 * fold big @doc tags (while keeping @spec open!)
 * better syntax highlight for console (desert-style) (low) 
 * signs on left edge - syntax highlight for ExUnit test outputs (crashes/test fails) (low)

 * nested level syntax highlight (like in https://github.com/bigfish/vim-js-context-coloring)

## Navigation

 * faster in-file navigation (ctags?) (top) or fix alchemist :)
 * clone tagbar and create cross reference browsing plugin (based on mix xref output)
 * make tagbar use alchemist.vim for getting tag information from file

## Syntax autofixes

 * fix unused variables warnings automatically
 * integrate with dogma
 * integrate with credo + autocorrection of problems (spacing/indents/arguments definitions and etc)

## Refactoring

 * variable renaming in single function clause
 * renaming of GenServer call atoms
 * renaming all function clauses + callers (using xref)
 * plugin to find large pieces of commented out code, which is not documentation
 * build code prefix trees to find (structurally same) duplicate code blocks

## Documentation
 * based on credo - automatically add @moduledoc tags
 * automatic guessing of signatures from debug traces and generation of @spec

## Erlang support!!!
 * support erlang syntax highlighting/source navigation/etc
