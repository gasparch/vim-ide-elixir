

if !exists('g:vimide_global_enable') | let g:vimide_global_enable = 0 | en
if !exists('g:vimide_manage_indents') | let g:vimide_manage_indents = 1 | en
if !exists('g:vimide_manage_search') | let g:vimide_manage_search = 1 | en
if !exists('g:vimide_manage_completition') | let g:vimide_manage_completition = 1 | en

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

if !exists('g:vimide_manage_vimdiff') | let g:vimide_manage_vimdiff = 1 | en
if !exists('g:vimide_manage_folds') | let g:vimide_manage_folds = 1 | en
if !exists('g:vimide_manage_restore') | let g:vimide_manage_restore = 1 | en
if !exists('g:vimide_install_shortcuts') | let g:vimide_install_shortcuts = 1 | en

if g:vimide_global_enable | call vimide#boot() | en

"
" vim: et ts=2 sts=2 sw=2
"
