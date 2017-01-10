
"
" check vimide#init() is set in vimrc
"

function! s:checkVimRC()
  let vimrcContent = readfile($MYVIMRC)

  let lines = filter(deepcopy(vimrcContent), "v:val =~ 'bundle/vim-ide-elixir/bundle/{}'")

  if len(lines) == 0
    call confirm("You need to add pathogen load path in the beginning of your .vimrc file\n".
          \ "See plugin homepage or install.sh script\n".
          \ "Vim-Elixir-IDE will not work properly otherwise.")
  endif

  let lines = filter(deepcopy(vimrcContent), "v:val =~ '^\\s*call\\s\\+vimide#init()'")

  if len(lines) == 0
    call confirm("You need to add 'call vimide#init()' in the end of your .vimrc file\nVim-Elixir-IDE will not work properly otherwise.")
  endif
endfunction

call vimide#setDefaults()
if g:vimide_global_enable
  call s:checkVimRC()
  call vimide#boot(1)
endif

"
" vim: et ts=2 sts=2 sw=2
"
