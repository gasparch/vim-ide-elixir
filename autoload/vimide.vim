"
"
"

let s:VIMIDE_BOOT_FINISHED = 0
let s:UPDATE_CHECK_FINISHED = 0

let s:rootPath = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
let s:bundlePath = s:rootPath . "/bundle"

function! vimide#getRootPath() " {{{
  return s:rootPath
endfunction " }}}

function! vimide#getBundlePath() " {{{
  return s:bundlePath
endfunction " }}}

function! vimide#setDefaults() " {{{
  call s:setGlobal('g:vimide_update_check_period', 24*60*60) " check updates once a day
  call s:setGlobal('g:vimide_update_channel', '') " valid values are production/beta/dev

  call s:setGlobal('g:vimide_global_enable', 0)
  call s:setGlobal('g:vimide_manage_indents', 1)
  call s:setGlobal('g:vimide_manage_search', 1)
  call s:setGlobal('g:vimide_manage_completition', 1)

  "
  " may use different themes for console/gui (console/gui)
  " set to '' disable managing themes
  call s:setGlobal('g:vimide_colorscheme', 'hybrid/desert')

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

  call s:setGlobal('g:vimide_manage_vimdiff', 1)
  call s:setGlobal('g:vimide_manage_encoding', 1)
  call s:setGlobal('g:vimide_manage_folds', 1)
  call s:setGlobal('g:vimide_manage_restore', 1)
  call s:setGlobal('g:vimide_manage_airline', 1)
  call s:setGlobal('g:vimide_manage_ctrlp', 1)
  call s:setGlobal('g:vimide_manage_indentline', 1)
  call s:setGlobal('g:vimide_install_comment_shortcuts', 1)
  call s:setGlobal('g:vimide_install_align_shortcuts', 1)
  call s:setGlobal('g:vimide_install_other_shortcuts', 1)
  call s:setGlobal('g:vimide_install_elixir_shortcuts', 1)
  call s:setGlobal('g:vimide_manage_misc_settings', 1)
  call s:setGlobal('g:vimide_install_hack_font', 1)
endfunction " }}}

function! vimide#init() " {{{
  " just do minimal amount of work necessary to tune plugins
  " which cannot be tuned later
  call vimide#setDefaults()

  if g:vimide_manage_airline            | call vimide#setAirlineSettings(1)                | endif
endfunction " }}}

function! vimide#boot(setGlobal) " {{{
  " run update check just once on editor start
  if !s:UPDATE_CHECK_FINISHED
    call s:checkUpdates()
    call s:checkSubscription()
    let s:UPDATE_CHECK_FINISHED = 1
  endif

  let bootVarName = (a:setGlobal ? "s:VIMIDE_BOOT_FINISHED" : "b:VIMIDE_BOOT_FINISHED")
  let bootFinished =  s:VIMIDE_BOOT_FINISHED || (exists(bootVarName) && execute("echo ".bootVarName) == 1)

  if !bootFinished
    if g:vimide_colorscheme != ''         | call vimide#setColorscheme(a:setGlobal)          | endif
    if g:vimide_manage_encoding           | call vimide#setVimEncodingSettings(a:setGlobal)  | endif
    if g:vimide_manage_indents            | call vimide#setIndentSettings(a:setGlobal)       | endif
    if g:vimide_manage_search             | call vimide#setSearchSettings(a:setGlobal)       | endif
    if g:vimide_manage_completition       | call vimide#setCompletitionSettings(a:setGlobal) | endif
    if g:vimide_manage_vimundo            | call vimide#setVimUndoSettings(a:setGlobal)      | endif
    if g:vimide_manage_vimbackup          | call vimide#setVimBackupSettings(a:setGlobal)    | endif
    if g:vimide_manage_vimdiff            | call vimide#setVimDiffSettings(a:setGlobal)      | endif
    if g:vimide_manage_folds              | call vimide#setFoldsSettings(a:setGlobal)        | endif
    if g:vimide_manage_restore            | call vimide#setRestoreSettings(a:setGlobal)      | endif
    if g:vimide_manage_indentline         | call vimide#setIndentLineSettigns(a:setGlobal)   | endif
    if g:vimide_manage_ctrlp              | call vimide#setCtrlPSettings(a:setGlobal)        | endif
    if g:vimide_install_comment_shortcuts | call vimide#setCommentShortcuts(a:setGlobal)     | endif
    if g:vimide_install_align_shortcuts   | call vimide#setTabularizeShortcuts(a:setGlobal)  | endif
    if g:vimide_install_other_shortcuts   | call vimide#setOtherShortcuts(a:setGlobal)       | endif
    if g:vimide_install_hack_font         | call vimide#setHackFont(a:setGlobal)             | endif
    if g:vimide_manage_misc_settings      | call vimide#setMiscSettings(a:setGlobal)         | endif
    execute("let " . bootVarName . "= 1")
  endif

  if &filetype == 'elixir'
    " filetype specific initialization goes here, but it is basically very
    " small piece of code
    call vimide#elixir#boot()
  endif

endfunction " }}}

function! vimide#setVimEncodingSettings(setGlobal) "{{{
  if a:setGlobal
    set encoding=utf-8
    set termencoding=utf-8
  else
    setlocal encoding=utf-8
    setlocal termencoding=utf-8
  endif
endfunction "}}}

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

function! vimide#setIndentLineSettigns(setGlobal) "{{{
  " can manage indentonly globally
  if a:setGlobal
    let g:indentLine_char = '⋮'
    let g:indentLine_color_gui = '#000000'
    nnoremap <silent> <C-K><C-I> :IndentLinesToggle<CR>
    " let g:indentLine_char = '⎥' straigh line
    " let g:indentLine_char = '⎸' (needs FreeSerif)
  else
    nnoremap <silent> <buffer> <C-K><C-I> :IndentLinesToggle<CR>
  endif
endfunction "}}}

function! vimide#setCtrlPSettings(setGlobal) "{{{
  " can manage CtrlP only globally
  if a:setGlobal
    let g:ctrlp_custom_ignore = {
          \ 'dir': 'node_modules|\v[\/]\.(git|hg|svn)$'
    \}
    let g:ctrlp_user_command = {
          \ 'types': {
            \ 1: ['.git', 'cd %s && git ls-files -co --exclude-standard'],
            \ 2: ['.hg', 'hg --cwd %s locate -I .'],
          \ },
        \ 'ignore': 1
        \ }
        "\ 'fallback': 'find %s -type f',
    let g:ctrlp_extensions = ['line', 'tagbar']
    let g:ctrlp_root_markers = ['mix.exs']
  else
    " TODO: add BufferEnter/Exit logic to manage b:ctrlp_user_command only in
    " elixir buffers
    let pass = 1
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
  let g:NERDCommentEmptyLines = 1

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

function! vimide#setTabularizeShortcuts(setGlobal) " {{{
  " ####################################################################
  " Integration with Tabularize

  " TODO: may be remove all indenting funcitonality alltogether, as it may be
  " extremely annoying

  if a:setGlobal
    " tabularize both => and =
    nmap <Leader>= ==:Tabularize /=><CR>
    nmap <Leader>eq ==:Tabularize /=/<CR>
    " tabularize case clauses
    nmap <Leader>- ==:Tabularize /-><CR>
    " tabularize : in hashmaps and similar
    nmap <Leader>: ==:Tabularize /\v(:)@<=\s/l0<CR>

    " tabularize both => and =
    vmap <Leader>= =:'<,'>Tabularize /=><CR>
    vmap <Leader>eq =:'<,'>Tabularize /=/<CR>
    " tabularize case clauses
    vmap <Leader>- =:'<,'>Tabularize /-><CR>
    " tabularize : in hashmaps and similar
    vmap <Leader>: =:'<,'>Tabularize /\v(:)@<=\s/l0<CR>
  else
    " tabularize both => and =
    nmap <buffer> <Leader>= ==:Tabularize /=><CR>
    nmap <buffer> <Leader>eq ==:Tabularize /=/<CR>
    " tabularize case clauses
    nmap <buffer> <Leader>- ==:Tabularize /-><CR>
    " tabularize : in hashmaps and similar
    nmap <buffer> <Leader>: ==:Tabularize /\v(:)@<=\s/l0<CR>

    " tabularize both => and =
    vmap <buffer> <Leader>= =:'<,'>Tabularize /=><CR>
    vmap <buffer> <Leader>eq =:'<,'>Tabularize /=/<CR>
    " tabularize case clauses
    vmap <buffer> <Leader>- =:'<,'>Tabularize /-><CR>
    " tabularize : in hashmaps and similar
    vmap <buffer> <Leader>: =:'<,'>Tabularize /\v(:)@<=\s/l0<CR>
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

    " general Tagbar integration
    " keyboard shortcuts
    nmap <F4> :TagbarToggle<CR>
    nmap <C-@> :CtrlPTagbar<CR>
    nmap <Leader>l :CtrlPLine<CR>

    " save file like in `borland-ides`
    nmap <F2> :w<CR>
    imap <F2> <Esc>:w<CR>a

    " lookup item under the cursor in file and show the list of
    " entries
    "
    " map ctrl-enter to jump to n-th match in list (gvim)
    map <C-CR> [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
    " for vim
    map <Leader>;; [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    map <C-K><C-l> :exec 'match NonText /\<' . expand("<cword>") . '\>/'<CR>

    " delete buffer and keep split
    cab bdd bp\|bd #

    " refactoring support
    map <C-K><C-w> :%s#\<<c-r><c-w>\>#
    map <C-K><C-a> :%s#\<<c-r><c-a>\>#

    " -------------------------------------------------------
    " buffer management commands
    "
    " buffer switch commands for *normal* mode
    nmap <C-space><Left> :bN<CR>
    nmap <C-space><Right> :bn<CR>
    nmap <C-space><Down> :wa<CR>
    nmap <C-space><Up> :bd<CR>

    " buffer switch commands for *insert* mode
    imap <C-space><Left> <Esc>:bN<CR>a
    imap <C-space><Right> <Esc>:bn<CR>a
    imap <C-space><Down> <Esc>:wa<CR>a
    imap <C-space><Up> <Esc>:bd<CR>a
    " mapping to allow keep Ctrl key presed when issuing commands
    map <C-Space><C-Left> <C-Space><Left>
    map <C-Space><C-Right> <C-Space><Right>
    map <C-Space><C-Down> <C-Space><Down>
    map <C-Space><C-Up> <C-Space><Up>

    " list all buffers
    nmap <C-Space><Space> :buffers<CR>
    imap <C-Space><Space> <Esc>:buffers<CR>a
    map <C-Space><C-Space> <C-Space><Space>

    map <F11> <C-space><Left>
  else
    noremap <buffer> <F3> :VimIDEToggleFold<CR>
    noremap <buffer> <silent> <Leader>trailing :call vimide#stripTrailingWhitespace()<CR>
    noremap <buffer> <silent> <Leader>$ :call vimide#stripTrailingWhitespace()<CR>

    if isGvim
      noremap <buffer> map ZZ :w<CR>:bd<CR>
      exec "noremap <silent> <buffer> <C-X> :silent !" . g:vimide_terminal . "&<CR>"
    end

    " general Tagbar integration
    " keyboard shortcuts
    nmap <buffer> <F4> :TagbarToggle<CR>
    nmap <buffer> <C-@> :CtrlPTagbar<CR>
    nmap <buffer> <Leader>l :CtrlPLine<CR>

    " save file like in `borland-ides`
    nmap <buffer> <F2> :w<CR>
    imap <buffer> <F2> <Esc>:w<CR>a

    " delete buffer and keep split
    cab <buffer> bdd bp\|bd #

    " lookup item under the cursor in file and show the list of
    " entries
    "
    " map ctrl-enter to jump to n-th match in list (gvim)
    map <buffer> <C-CR> [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
    " for vim
    map <buffer> <Leader>;; [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    map <buffer> <C-K><C-l> :exec 'match NonText /\<' . expand("<cword>") . '\>/'<CR>
  endif
endfunction " }}}

function! vimide#setHackFont(setGlobal) " {{{
  let isGvim = has("gui_running")
  if a:setGlobal && isGvim
    set guifont=Hack\ 10

    map <Leader>--- :set guifont=Ubuntu\ Mono\ 9<CR>
    map <Leader>-- :set guifont=Ubuntu\ Mono\ 10<CR>
    map <Leader>0 :set guifont=Hack\ 10<CR>
    map <Leader>++ :set guifont=Hack\ 11<CR>
    map <Leader>+++ :set guifont=Hack\ 12<CR>
  endif
endfunction " }}}

function! vimide#setMiscSettings(setGlobal) " {{{
  "let isGvim = has("gui_running")
  if a:setGlobal
    set updatetime=500
    set wildignore=*.o,*.obj,*.beam,*.swp
    "TODO: set guioptions-=T  "remove toolbar until we know what useful buttons put
    "on it ;-)
    set backspace=indent,eol,start
    set showmatch
    set matchtime=2
  else
    setlocal wildignore=*.o,*.obj,*.beam,*.swp
    setlocal backspace=indent,eol,start
    setlocal showmatch
    setlocal matchtime=2

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

" TODO: consolidate in lib
function! s:setGlobal(name, default) " {{{
  if !exists(a:name)
    if type(a:name) == 0 || type(a:name) == 5
      exec "let " . a:name . " = " . a:default
    elseif type(a:name) == 1
      exec "let " . a:name . " = '" . escape(a:default, "\'") . "'"
    endif
  endif
endfunction " }}}

function! s:checkUpdates() " {{{
  " check now much times we run already
  let currentTs = strftime("%s")

  let tsFileName = vimide#getRootPath() . "/.last_update_ts"

  let runUpdateCheck = 0
  if !file_readable(tsFileName)
    let runUpdateCheck = 1
  else
    let lastUpdateTs = join(readfile(tsFileName), "")
    if lastUpdateTs + g:vimide_update_check_period < currentTs
      runUpdateCheck = 1
    endif
  endif

  if !runUpdateCheck | return | endif

  call writefile([currentTs], tsFileName, "w")

  let checkOutput = system(vimide#getRootPath() . "/check_update.sh " . g:vimide_update_channel)

  if checkOutput !~ '^update,' | return | endif

  let matches = split(checkOutput, ',')

  let msg = "Update available for Vim-IDE-Elixir, version " . matches[3] . "\n" .
        \ "Please cd " . vimide#getRootPath() . " and run \n".
        \ "./update.sh " . g:vimide_update_channel . " "

  let answer = confirm(msg, "&Run now,Run &manually later", -999)

  if (answer != -999) | return | endif

  let updateOutput = system(vimide#getRootPath() . "/update.sh " . g:vimide_update_channel)

  echo updateOutput
  call confirm("Restart Vim for updated version")
endfunction " }}}

function! s:checkSubscription() " {{{
  let tsFileName = vimide#getRootPath() . "/.seen_subscribe_question"

  let seenSubscribeCheck = file_readable(tsFileName)
  if seenSubscribeCheck | return | endif

  let msg = "Hi! Thank you for trying out Vim-IDE-Elixir.\n" .
        \ "Your support is essential for project to stay alive and develop, \n" .
        \ "so please take your time and subscribe to mailing list here: \n".
        \ "http://gasparchilingarov.com/vim-ide-updates/ \n".
        \ "\n" .
        \ "Also send me your feedback in a few days after you use this plugin, please! \n" .
        \ "\n" .
        \ "This is one-time message, you can find subscription URL later in README.md."

  let answer = confirm(msg)

  call writefile([''], tsFileName, "w")
endfunction " }}}
