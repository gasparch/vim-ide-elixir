" 
" vim: et ts=2 sts=2 sw=2
"


let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
let s:bundle_path = s:path."/bundle"

" for now load by placing this in .vimrc
" find a way to do it from inside module while being loaded
" runtime bundle/vim-pathogen/autoload/pathogen.vim
" execute pathogen#infect("bundle/{}", "bundle/vim-ide-elixir/bundle/{}")

""echom("doing well ". s:path)
""let s:modules = ["vim-desert-programming", "vim-elixir"]
"" we have pathogen as plugin manager
"if exists("g:loaded_pathogen")
""  echom("doing well ". s:bundle_path)
"  execute pathogen#infect(s:bundle_path."/{}")
""  echom(&rtp)
"  "runtime(s:bundle_path)
"endif

let g:tagbar_type_elixir = {
    \ 'ctagstype' : 'elixir',
    \ 'deffile' : s:path . '/extras/elixir-ctags/.ctags',
    \ 'kinds' : [
        \ 'f:functions',
        \ 'functions:functions',
        \ 'c:callbacks',
        \ 'd:delegates',
        \ 'e:exceptions',
        \ 'i:implementations',
        \ 'a:macros',
        \ 'o:operators',
        \ 'm:modules',
        \ 'p:protocols',
        \ 'r:records'
    \ ]
\ }

set updatetime=500
