" commentary.vim - Comment stuff out
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      1.2
" GetLatestVimScripts: 3695 1 :AutoInstall: commentary.vim

if exists("g:loaded_commentary") || &cp || v:version < 700
  finish
endif
let g:loaded_commentary = 1

function! s:surroundings() abort
  return split(get(b:, 'commentary_format', substitute(substitute(
        \ &commentstring, '\S\zs%s',' %s','') ,'%s\ze\S', '%s ', '')), '%s', 1)
endfunction

function! s:go(type,...) abort
  if a:0
    let [lnum1, lnum2] = [a:type, a:1]
  else
    let [lnum1, lnum2] = [line("'["), line("']")]
  endif

  let [l, r] = s:surroundings()
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
  let modelines = &modelines
  try
    set modelines=0
    silent doautocmd User CommentaryPost
  finally
    let &modelines = modelines
  endtry
endfunction

function! s:textobject(inner) abort
  let [l, r] = s:surroundings()
  let lnums = [line('.')+1, line('.')-2]
  for [index, dir, bound, line] in [[0, -1, 1, ''], [1, 1, line('$'), '']]
    while lnums[index] != bound && line ==# '' || !(stridx(line,l) || line[strlen(line)-strlen(r) : -1] != r)
      let lnums[index] += dir
      let line = matchstr(getline(lnums[index]+dir),'\S.*\s\@<!')
    endwhile
  endfor
  while (a:inner || lnums[1] != line('$')) && empty(getline(lnums[0]))
    let lnums[0] += 1
  endwhile
  while a:inner && empty(getline(lnums[1]))
    let lnums[1] -= 1
  endwhile
  if lnums[0] <= lnums[1]
    execute 'normal! 'lnums[0].'GV'.lnums[1].'G'
  endif
endfunction

function! s:setcommentaryreg(reg)
  let s:targetreg = a:reg
endfunction
function! s:yankandcomment(type,...)
  " only linewise operations make sense (to me, at least)
  " so I am ignoring `type`
  if a:0
    let [mark1, mark2] = [a:type, a:1]
    let reg = a:2
  else
    let [mark1, mark2] = ["'[", "']"]
    let reg = get(s:, "targetreg", '"')
  endif
  execute 'normal! ' . mark1 . '"' . reg . 'y' . mark2 . ']'
  call <SID>go(line(mark1),line(mark2))
  execute 'normal! ' . mark1
endfunction

function! s:yankcommentpaste(type,...)
  if a:0
    let [mark1, mark2] = [a:type, a:1]
  else
    let [mark1, mark2] = ["'[", "']"]
  endif
  let savereg = @"
  execute "normal " . mark1 ."gcy" . mark2 . "]"
  execute "normal! " . mark2 . "p" . mark1
  let @" = savereg
endfunction

xnoremap <silent> <Plug>Commentary     :<C-U>call <SID>go(line("'<"),line("'>"))<CR>
nnoremap <silent> <Plug>Commentary     :<C-U>set opfunc=<SID>go<CR>g@
nnoremap <silent> <Plug>CommentaryLine :<C-U>set opfunc=<SID>go<Bar>exe 'norm! 'v:count1.'g@_'<CR>
onoremap <silent> <Plug>Commentary        :<C-U>call <SID>textobject(0)<CR>
nnoremap <silent> <Plug>ChangeCommentary c:<C-U>call <SID>textobject(1)<CR>
nmap <silent> <Plug>CommentaryUndo <Plug>Commentary<Plug>Commentary
command! -range -bar Commentary call s:go(<line1>,<line2>)

xnoremap <silent> <Plug>CommentaryYank     :<C-U>call<SID>yankandcomment("'<", "'>", v:register)<CR>
nnoremap <silent> <Plug>CommentaryYank     :<C-U>call <SID>setcommentaryreg(v:register)<CR>:set opfunc=<SID>yankandcomment<CR>g@
nnoremap <silent> <Plug>CommentaryYankLine :<C-U>call <SID>setcommentaryreg(v:register)<CR>:set opfunc=<SID>yankandcomment<Bar>exe 'norm! 'v:count1.'g@_'<CR>

xnoremap <silent> <Plug>CommentaryDupe     :<C-U>call<SID>yankcommentpaste("'<", "'>", v:register)<CR>:normal! '>j<CR>
nnoremap <silent> <Plug>CommentaryDupe     :<C-U>call <SID>setcommentaryreg(v:register)<CR>:set opfunc=<SID>yankcommentpaste<CR>g@
nnoremap <silent> <Plug>CommentaryDupeLine :<C-U>call <SID>setcommentaryreg(v:register)<CR>:set opfunc=<SID>yankcommentpaste<Bar>exe 'norm! 'v:count1.'g@_'<CR>

xnoremap <silent> <Plug>Commentary     :<C-U>call <SID>go(line("'<"),line("'>"))<CR>
if !hasmapto('<Plug>Commentary') || maparg('gc','n') ==# ''
  xmap gc  <Plug>Commentary
  nmap gc  <Plug>Commentary
  omap gc  <Plug>Commentary
  nmap gcc <Plug>CommentaryLine
  nmap cgc <Plug>ChangeCommentary
  nmap gcu <Plug>Commentary<Plug>Commentary
  xmap gcy   <Plug>CommentaryYank
  nmap gcy   <Plug>CommentaryYank
  nmap gcyy  <Plug>CommentaryYankLine
  xmap gcd   <Plug>CommentaryDupe
  nmap gcd   <Plug>CommentaryDupe
  nmap gcdd  <Plug>CommentaryDupeLine
endif
