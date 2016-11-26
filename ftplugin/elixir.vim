

"set expandtab
"set tabstop=2
"set shiftwidth=2


nmap <F1> K

let g:alchemist#elixir_erlang_src = "/home/nm/dev/github"

let g:ConqueTerm_CloseOnEnd=1
let g:alchemist_iex_term_size = 15

"map <F12> :IEx<CR>

"function! ErlBalloonExpr()
"	"	return 'Cursor is at line ' . v:beval_lnum .
"	"	\', column ' . v:beval_col .
"	"	\ ' of file ' .  bufname(v:beval_bufnr) .
"	"	\ ' on word "' . v:beval_text . '"'
"
"	let text = alchemist#get_doc(v:beval_text)
"	return text
"endfunction
"
"set bexpr=ErlBalloonExpr()
"set ballooneval

" tabularize both => and =
map <Leader>= =:Tabularize /=><CR>
map <Leader>eq =:Tabularize /=/<CR>
" tabularize case clauses
map <Leader>- =:Tabularize /-><CR>
" tabularize hashmaps and similar
map <Leader>: =:Tabularize /\v(:)@<=\s/l0<CR>


