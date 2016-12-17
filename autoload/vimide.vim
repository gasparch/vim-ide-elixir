"
"
"

function! vimide#boot() " {{{
  if g:vimide_manage_indents | call vimide#setIndentSettings() | endif
  if g:vimide_manage_search  | call vimide#setSearchSettings() | endif
  if g:vimide_manage_completition | call vimide#setCompletitionSettings() | endif
  if g:vimide_manage_vimundo | call vimide#setVimUndoSettings() | endif
  if g:vimide_manage_vimbackup | call vimide#setVimBackupSettings() | endif
  if g:vimide_manage_vimdiff | call vimide#setVimDiffSettings() | endif
  if g:vimide_manage_folds | call vimide#setFoldsSettings() | endif
  if g:vimide_manage_restore | call vimide#setRestoreSettings() | endif

  if &filetype == 'elixir'
    call vimide#elixir#boot()
  endif

  if g:vimide_install_shortcuts | call vimide#setShortcuts() | endif
endfunction " }}}

function! vimide#setIndentSettings() "{{{
  set autoindent
  set cindent
  set smartindent
endfunction "}}}

function! vimide#setSearchSettings() "{{{
  set incsearch
  set nohls
  nmap n nzz
  nmap N Nzz
endfunction "}}}

function! vimide#setCompletitionSettings() "{{{
  set noinfercase
  set noerrorbells
endfunction "}}}

function! vimide#setVimUndoSettings() "{{{
  let undoDir = $HOME . "/.vimundo"
  if !isdirectory(undoDir)
    call mkdir(undoDir, "p")
  endif

  set undodir=undoDir
endfunction "}}}

function! vimide#setVimBackupSettings() "{{{
  let backupDir = $HOME . "/.vimbackup"
  if !isdirectory(backupDir)
    call mkdir(backupDir, "p")
  endif

  set backupdir=backupDir
  set writebackup
  set backup
endfunction "}}}

function! vimide#setVimDiffSettings() "{{{
  set diffopt=iwhite
endfunction "}}}

function! vimide#setFoldsSettings() "{{{
  if g:vimide_global_enable
    com! VimIDEToggleFold call vimide#toggleFold()
  else
    com! -buffer VimIDEToggleFold call vimide#toggleFold()
  endif
endfunction "}}}

function! vimide#setRestoreSettings() " {{{
  if g:vimide_global_enable
    augroup vimideRestore
      au!
      au BufReadPost * call vimide#restorePosition()
    augroup END
  else
    augroup vimideRestore
      au!
      au BufReadPost <buffer> call vimide#restorePosition()
    augroup END
  endif
endfunction " }}}

function! vimide#setShortcuts() " {{{
  noremap <F3> :VimIDEToggleFold<CR>
endfunction " }}}

" ######################################################################
" internal functions

function! vimide#toggleFold() "{{{
  if foldlevel('.') == 0
    normal! l
  else
    if foldclosed('.') < 0
      . foldclose
    else
      . foldopen
    endif
  endif
  " Clear status line
  echo
endfunction "}}}

function! vimide#restorePosition() " {{{
  if line("'.") > 0
    if line("'.") <= line("$")
      exe("norm `.zz")
      if foldclosed('.') >= 0
        . foldopen
      endif
    else
      exe "norm $"
    endif
  else
    if line("'\"") > 0
      if line("'\"") <= line("$")
        exe("norm '\"zz")
        if foldclosed('.') >= 0
          . foldopen
        endif
      else
        exe "norm $"
      endif
    endif
  endif
endf " }}}
