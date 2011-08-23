" commentary.vim - Comment stuff out
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      1.0
" GetLatestVimScripts: 3695 1 :AutoInstall: commentary.vim

if exists("g:loaded_commentary") || &cp || v:version < 700
  finish
endif
let g:loaded_commentary = 1

function! s:go(type) abort
  if a:type =~ '^\d\+$'
    let [lnum1, lnum2] = [line("."), line(".") + a:type - 1]
  elseif a:type =~ '^.$'
    let [lnum1, lnum2] = [line("'<"), line("'>")]
  else
    let [lnum1, lnum2] = [line("'["), line("']")]
  endif

  let [before, after] = split(substitute(substitute(&commentstring,'\S\zs%s',' %s',''),'%s\ze\S','%s ',''),'%s',1)
  let uncomment = 1
  for lnum in range(lnum1,lnum2)
    let line = matchstr(getline(lnum),'\S.*\s\@<!')
    if line != '' && (stridx(line,before) || line[strlen(line)-strlen(after) : -1] != after)
      let uncomment = 0
    endif
  endfor

  for lnum in range(lnum1,lnum2)
    if uncomment
      let line = substitute(getline(lnum),'\S.*\s\@<!','\=submatch(0)[strlen(before):-strlen(after)-1]','')
    else
      let line = substitute(getline(lnum),'^\%('.matchstr(getline(lnum1),'^\s*').'\|\s*\)\zs.*\S\@<=','\=before.submatch(0).after','')
    endif
    call setline(lnum,line)
  endfor

  if a:type =~ '^\d\+$'
    silent! call repeat#set('\\\',a:type)
  endif
endfunction

xnoremap <silent> \\  :<C-U>call <SID>go(visualmode())<CR>
nnoremap <silent> \\  :<C-U>set opfunc=<SID>go<CR>g@
nnoremap <silent> \\\ :<C-U>call <SID>go(v:count1)<CR>

" vim:set sw=2 sts=2:
