

" wrapper around NERDComment to allow automatic commenting of folds without
" need of selecting them first
function vimide#comments#wrap(mode, target) range
  if a:mode == 'x' 
    call NERDComment(a:mode, a:target)
  elseif foldclosed('.') == -1
    call NERDComment(a:mode, a:target)
  else
    let foldStart = foldclosed('.')
    let foldEnd   = foldclosedend('.')
    exe foldStart.",".foldEnd."call NERDComment('".a:mode."', '".a:target."')"
  endif
endfunction

