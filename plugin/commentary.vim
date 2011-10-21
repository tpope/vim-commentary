" commentary.vim - Comment stuff out
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      1.1
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

  let [l, r] = split(substitute(substitute(&commentstring,'\S\zs%s',' %s',''),'%s\ze\S','%s ',''),'%s',1)
  let uncomment = 2
  for lnum in range(lnum1,lnum2)
    let line = matchstr(getline(lnum),'\S.*\s\@<!')
    if line != '' && (stridx(line,l) || line[strlen(line)-strlen(r) : -1] != r)
      let uncomment = 0
    endif
  endfor

  for lnum in range(lnum1,lnum2)
    let line = getline(lnum)
    if strlen(r) > 2 && l.r !~# '\\'
      let line = substitute(line,
            \'\M'.r[0:-2].'\zs\d\*\ze'.r[-1:-1].'\|'.l[0].'\zs\d\*\ze'.l[1:-1],
            \'\=substitute(submatch(0)+1-uncomment,"^0$\\|^-\\d*$","","")','g')
    endif
    if uncomment
      let line = substitute(line,'\S.*\s\@<!','\=submatch(0)[strlen(l):-strlen(r)-1]','')
    else
      let line = substitute(line,'^\%('.matchstr(getline(lnum1),'^\s*').'\|\s*\)\zs.*\S\@<=','\=l.submatch(0).r','')
    endif
    call setline(lnum,line)
  endfor

  if a:type =~ '^\d\+$'
    silent! call repeat#set("\<Plug>CommentaryLine",a:type)
  endif
endfunction

xnoremap <silent> <Plug>Commentary     :<C-U>call <SID>go(visualmode())<CR>
nnoremap <silent> <Plug>Commentary     :<C-U>set opfunc=<SID>go<CR>g@
nnoremap <silent> <Plug>CommentaryLine :<C-U>call <SID>go(v:count1)<CR>

if !hasmapto('<Plug>Commentary') || maparg('\\','n') ==# '' && maparg('\','n') ==# ''
  xmap \\  <Plug>Commentary
  nmap \\  <Plug>Commentary
  nmap \\\ <Plug>CommentaryLine
endif

" vim:set sw=2 sts=2:
