" commentary.vim - Comment stuff out
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      1.3
" GetLatestVimScripts: 3695 1 :AutoInstall: commentary.vim

if exists("g:loaded_commentary") || &cp || v:version < 700
  finish
endif
let g:loaded_commentary = 1

xnoremap <silent> <Plug>Commentary     :<C-U>call com#go(line("'<"),line("'>"))<CR>
nnoremap <silent> <Plug>Commentary     :<C-U>set opfunc=com#go<CR>g@
nnoremap <silent> <Plug>CommentaryLine :<C-U>set opfunc=com#go<Bar>exe 'norm! 'v:count1.'g@_'<CR>
onoremap <silent> <Plug>Commentary        :<C-U>call com#textobject(0)<CR>
nnoremap <silent> <Plug>ChangeCommentary c:<C-U>call com#textobject(1)<CR>
nmap <silent> <Plug>CommentaryUndo <Plug>Commentary<Plug>Commentary
command! -range -bar Commentary call com#go(<line1>,<line2>)

if !hasmapto('<Plug>Commentary') || maparg('gc','n') ==# ''
  xmap gc  <Plug>Commentary
  nmap gc  <Plug>Commentary
  omap gc  <Plug>Commentary
  nmap gcc <Plug>CommentaryLine
  if maparg('c','n') ==# ''
    nmap cgc <Plug>ChangeCommentary
  endif
  nmap gcu <Plug>Commentary<Plug>Commentary
endif

" vim:set et sw=2:
