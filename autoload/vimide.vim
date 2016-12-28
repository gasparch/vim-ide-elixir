"
"
"

let s:VIMIDE_BOOT_FINISHED = 0

function! vimide#setDefaults() " {{{
  call s:SetGlobal('g:vimide_global_enable', 0)
  call s:SetGlobal('g:vimide_manage_indents', 1)
  call s:SetGlobal('g:vimide_manage_search', 1)
  call s:SetGlobal('g:vimide_manage_completition', 1)

  "
  " may use different themes for console/gui (console/gui)
  " set to '' disable managing themes
  call s:SetGlobal('g:vimide_colorscheme', 'hybrid/desert')

  call s:setGlobal('g:vimide_terminal', 'xterm')
  call s:setGlobal('g:vimide_terminal_run_args', "-title %TITLE% -e %CMD% ")
  " ESC sequence to change terminal title
  " like :r!echo -n "\033]0;${USER}@${HOST}\007"
  call s:setGlobal('g:vimide_terminal_title_change', "]0;%TITLE%")

  if !exists('&undodir')
    if !exists('g:vimide_manage_vimundo') | let g:vimide_manage_vimundo = 1 | en
  else
    let g:vimide_manage_vimundo = 0
  endif

  if !exists('&backupdir')
    if !exists('g:vimide_manage_vimbackup') | let g:vimide_manage_vimbackup = 1 | en
  else
    let g:vimide_manage_vimbackup = 0
  end

  call s:SetGlobal('g:vimide_manage_vimdiff', 1)
  call s:SetGlobal('g:vimide_manage_folds', 1)
  call s:SetGlobal('g:vimide_manage_restore', 1)
  call s:SetGlobal('g:vimide_manage_airline', 1)
  call s:SetGlobal('g:vimide_install_comment_shortcuts', 1)
  call s:SetGlobal('g:vimide_install_other_shortcuts', 1)
  call s:SetGlobal('g:vimide_manage_misc_settings', 1)
endfunction " }}}

function! vimide#init() " {{{
  " just do minimal amount of work necessary to tune plugins
  " which cannot be tuned later
  call vimide#setDefaults()

  if g:vimide_manage_airline            | call vimide#setAirlineSettings(1)                | endif
endfunction " }}}

function! vimide#boot(setGlobal) " {{{
  if !s:VIMIDE_BOOT_FINISHED
    if g:vimide_colorscheme != ''         | call vimide#setColorscheme(a:setGlobal)          | endif
    if g:vimide_manage_indents            | call vimide#setIndentSettings(a:setGlobal)       | endif
    if g:vimide_manage_search             | call vimide#setSearchSettings(a:setGlobal)       | endif
    if g:vimide_manage_completition       | call vimide#setCompletitionSettings(a:setGlobal) | endif
    if g:vimide_manage_vimundo            | call vimide#setVimUndoSettings(a:setGlobal)      | endif
    if g:vimide_manage_vimbackup          | call vimide#setVimBackupSettings(a:setGlobal)    | endif
    if g:vimide_manage_vimdiff            | call vimide#setVimDiffSettings(a:setGlobal)      | endif
    if g:vimide_manage_folds              | call vimide#setFoldsSettings(a:setGlobal)        | endif
    if g:vimide_manage_restore            | call vimide#setRestoreSettings(a:setGlobal)      | endif
    if g:vimide_install_comment_shortcuts | call vimide#setCommentShortcuts(a:setGlobal)     | endif
    if g:vimide_install_other_shortcuts   | call vimide#setOtherShortcuts(a:setGlobal)       | endif
    if g:vimide_manage_misc_settings      | call vimide#setMiscSettings(a:setGlobal)         | endif
    let s:VIMIDE_BOOT_FINISHED = 1
  endif

  if &filetype == 'elixir'
    call vimide#elixir#boot()
  endif

endfunction " }}}

function! vimide#setIndentSettings(setGlobal) "{{{
  if a:setGlobal
    set autoindent
    set cindent
    set smartindent
  else
    setlocal autoindent
    setlocal cindent
    setlocal smartindent
  endif
endfunction "}}}

function! vimide#setSearchSettings(setGlobal) "{{{
  if a:setGlobal
    set incsearch
    set nohls
    nnoremap n nzz
    nnoremap N Nzz
  else
    setlocal incsearch
    setlocal nohls
    nnoremap <buffer> n nzz
    nnoremap <buffer> N Nzz
  endif
endfunction "}}}

function! vimide#setColorscheme(setGlobal) "{{{
  let useScheme = g:vimide_colorscheme
  let doubleScheme = split(useScheme, '/')
  if len(doubleScheme) == 2
    if has("gui_running")
      let useScheme = doubleScheme[1]
    else
      let useScheme = doubleScheme[0]
    endif
  endif
  exe "colorscheme " . useScheme
endfunction "}}}

function! vimide#setCompletitionSettings(setGlobal) "{{{
  if a:setGlobal
    set noinfercase
    set noerrorbells
  else
    setlocal noinfercase
    setlocal noerrorbells
  endif
endfunction "}}}

function! vimide#setVimUndoSettings(setGlobal) "{{{
  let undoDir = $HOME . "/.vimundo"
  if !isdirectory(undoDir)
    call mkdir(undoDir, "p")
  endif

  if a:setGlobal
    set undodir=undoDir
  else
    setlocal undodir=undoDir
  endif
endfunction "}}}

function! vimide#setVimBackupSettings(setGlobal) "{{{
  let backupDir = $HOME . "/.vimbackup"
  if !isdirectory(backupDir)
    call mkdir(backupDir, "p")
  endif

  if a:setGlobal
    set backupdir=backupDir
    set writebackup
    set backup
  else
    setlocal backupdir=backupDir
    setlocal writebackup
    setlocal backup
  endif
endfunction "}}}

function! vimide#setVimDiffSettings(setGlobal) "{{{
  if a:setGlobal
    set diffopt=iwhite
  else
    setlocal diffopt=iwhite
  endif
endfunction "}}}

function! vimide#setAirlineSettings(setGlobal) "{{{
  " can manage airline only globally
  if a:setGlobal
    set laststatus=2

    let g:airline#extensions#tabline#enabled = 0
    let g:airline#extensions#po#enabled = 0

    let g:airline_powerline_fonts = 1
    let g:airline_mode_map = {
          \ '__' : '-',
          \ 'n'  : 'N',
          \ 'i'  : 'I',
          \ 'R'  : 'R',
          \ 'c'  : 'C',
          \ 'v'  : 'V',
          \ 'V'  : 'V',
          \ '.'  : 'V',
          \ 's'  : 'S',
          \ 'S'  : 'S',
          \ }

    let g:airline_left_sep = ''
    let g:airline_left_alt_sep = ''
    let g:airline_right_sep = ''
    let g:airline_right_alt_sep = ''

    if !exists("g:airline_symbols")
      let g:airline_symbols={}
    endif

    let g:airline_symbols.branch = ''
    let g:airline_symbols.readonly = ''
    let g:airline_symbols.linenr = ''
    let g:airline_symbols.maxlinenr = ''

    let g:airline_section_z = airline#section#create(['%3p%%', 'linenr', 'maxlinenr', '%3v'])
    let g:airline_section_y = ''
    let g:airline_section_x = ''
  endif
endfunction "}}}

function! vimide#setFoldsSettings(setGlobal) "{{{
  if a:setGlobal
    com! VimIDEToggleFold call vimide#toggleFold()
  else
    com! -buffer VimIDEToggleFold call vimide#toggleFold()
  endif
endfunction "}}}

function! vimide#setRestoreSettings(setGlobal) " {{{
  if a:setGlobal
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

function! vimide#setCommentShortcuts(setGlobal) " {{{
  nnoremap <silent> <Plug>VimidecommentsToggle :call vimide#comments#wrap("n", "Toggle" )<CR>
  xnoremap <silent> <Plug>VimidecommentsToggle :call vimide#comments#wrap("x", "Toggle" )<CR>
  nnoremap <silent> <Plug>VimidecommentsNested :call vimide#comments#wrap("n", "Nested" )<CR>
  xnoremap <silent> <Plug>VimidecommentsNested :call vimide#comments#wrap("x", "Nested" )<CR>
  nnoremap <silent> <Plug>VimidecommentsUncomment :call vimide#comments#wrap("n", "Uncomment")<CR>
  xnoremap <silent> <Plug>VimidecommentsUncomment :call vimide#comments#wrap("x", "Uncomment")<CR>

  " WARNING: there is no way to get NERDDefaultAlign per buffer, so messing with global
  " variable now.
  " we want comments to be nicely aligned under each other and not follow
  " indentation
  let g:NERDDefaultAlign = "left"
  " TODO: think of possibility leaving commented area in visual selected mode
  " (if it is good idea at all :)
  if a:setGlobal
    " TODO: copy/paste is recipe for disaster, make function to automate
    " bindings
    nmap <C-K><C-P> <Plug>VimidecommentsToggle
    nmap <C-K><C-[> <Plug>VimidecommentsNested
    nmap <C-K><C-]> <Plug>VimidecommentsUncomment

    vmap <C-K><C-P> <Plug>VimidecommentsToggle
    vmap <C-K><C-[> <Plug>VimidecommentsNested
    vmap <C-K><C-]> <Plug>VimidecommentsUncomment

    imap <C-K><C-P> <Plug>VimidecommentsToggle
    imap <C-K><C-[> <Plug>VimidecommentsNested
    imap <C-K><C-]> <Plug>VimidecommentsUncomment
  else
    nmap <buffer> <C-K><C-P> <Plug>VimidecommentsToggle
    nmap <buffer> <C-K><C-[> <Plug>VimidecommentsNested
    nmap <buffer> <C-K><C-]> <Plug>VimidecommentsUncomment

    vmap <buffer> <C-K><C-P> <Plug>VimidecommentsToggle
    vmap <buffer> <C-K><C-[> <Plug>VimidecommentsNested
    vmap <buffer> <C-K><C-]> <Plug>VimidecommentsUncomment

    imap <buffer> <C-K><C-P> <Plug>VimidecommentsToggle
    imap <buffer> <C-K><C-[> <Plug>VimidecommentsNested
    imap <buffer> <C-K><C-]> <Plug>VimidecommentsUncomment
  endif
endfunction " }}}

function! vimide#setOtherShortcuts(setGlobal) " {{{
  let isGvim = has("gui_running")
  if a:setGlobal
    noremap <F3> :VimIDEToggleFold<CR>
    noremap <silent> <Leader>trailing :call vimide#stripTrailingWhitespace()<CR>
    noremap <silent> <Leader>$ :call vimide#stripTrailingWhitespace()<CR>

    if isGvim
      noremap map ZZ :w<CR>:bd<CR>
      exec "noremap <silent> <C-X> :silent !" . g:vimide_terminal . "&<CR>"
    end
  else
    noremap <buffer> <F3> :VimIDEToggleFold<CR>
    noremap <buffer> <silent> <Leader>trailing :call vimide#stripTrailingWhitespace()<CR>
    noremap <buffer> <silent> <Leader>$ :call vimide#stripTrailingWhitespace()<CR>

    if isGvim
      noremap <buffer> map ZZ :w<CR>:bd<CR>
      exec "noremap <silent> <buffer> <C-X> :silent !" . g:vimide_terminal . "&<CR>"
    end
  endif
endfunction " }}}

function! vimide#setMiscSettings(setGlobal) " {{{
  "let isGvim = has("gui_running")
  if a:setGlobal
    set updatetime=500
    "TODO: set guioptions-=T  "remove toolbar until we know what useful buttons put
    "on it ;-)

  endif
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

function! vimide#stripTrailingWhitespace() " {{{
  " Save cursor position
  let l:save = winsaveview()
  " Remove trailing whitespace
  %s/\s\+$//e
  " Move cursor to original position
  call winrestview(l:save)
endfunction " }}}

function! s:SetGlobal(name, default) " {{{
  if !exists(a:name)
    if type(a:name) == 0 || type(a:name) == 5
      exec "let " . a:name . " = " . a:default
    elseif type(a:name) == 1
      exec "let " . a:name . " = '" . escape(a:default, "\'") . "'"
    endif
  endif
endfunction " }}}
