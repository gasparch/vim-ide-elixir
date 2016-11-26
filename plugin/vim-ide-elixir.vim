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


function! Tag_transform(tags)
  " remove OTP callbacks from ordinary function list
  call filter(a:tags, ' !(v:val.fields.kind == "f" && v:val.name =~ "\\v(handle_call|handle_info|handle_cast|init|terminate)") ')

  function! Arity_extract(idx, tag)
    if a:tag.fields.kind == 'f' || a:tag.fields.kind == 'g'
      let args_string = substitute(a:tag.pattern, "^.*".a:tag.name."[ \t]*", "", "")
      let args_string = substitute(args_string, "do[ \t]*\\\\[$]$", "", "")
      let args_string = substitute(args_string, "[ \t]*", "", "g")

      let args_len = len(args_string)

      if args_len == 0
        let a:tag.name = a:tag.name."/0"
      else
        let old_args_len = -10000
        while args_len != old_args_len
          let args_string = substitute(args_string, "{[^}]*}", "", "g")
          let args_string = substitute(args_string, "\\[[^]]*\\]", "", "g")
          let old_args_len = args_len
          let args_len = len(args_string)
          echo(args_string)
        endwhile

        let comma_count = len(substitute(args_string, "[^,]", "", "g"))
        let a:tag.name = a:tag.name . "/" . (comma_count + 1)
      endif

      return a:tag
    else
      return a:tag
    endif
  endfunction

  " replaces function names with function_name/arity notation
  call map(a:tags, function('Arity_extract'))

  let seen_list = map(copy(a:tags), '[v:val.fields.kind, v:val.name, v:val.fields.line]')

  let seen_fnames = {}
  for [kind, fname, line] in seen_list
    if ! has_key(seen_fnames, kind.fname)
      let seen_fnames[kind.fname] = line
    endif
  endfor

  " leaves only first definition of function with same arity
  function! Filter_fun(seen_hash, idx, tag)
    let key = a:tag.fields.kind . a:tag.name
    let line = a:tag.fields.line

    return a:seen_hash[key] == line
  endfunction

  call filter(a:tags, function('Filter_fun', [seen_fnames]))

  return a:tags
endfunction


let g:tagbar_type_elixir = {
    \ 'ctagstype' : 'elixir',
    \ 'deffile' : s:path . '/extras/elixir-ctags/.ctags',
    \ 'transform': function("Tag_transform"),
    \ 'kinds' : [
        \ 'm:modules',
        \ 'O:OTP callbacks',
        \ 't:tests',
        \ 'f:functions (public)',
        \ 'g:functions (private)',
        \ 'c:callbacks',
        \ 'd:delegates',
        \ 'e:exceptions',
        \ 'i:implementations',
        \ 'a:macros',
        \ 'o:operators',
        \ 's:structs',
        \ 'p:protocols',
        \ 'r:records',
        \ 'T:types',
        \ 'z:foo'
    \ ]
\ }

set updatetime=500

" keyboard shortcuts
nmap <F4> :TagbarToggle<CR>

