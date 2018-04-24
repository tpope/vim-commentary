" commentary.vim - Comment stuff out
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      1.3
" GetLatestVimScripts: 3695 1 :AutoInstall: commentary.vim

if exists("g:loaded_commentary") || v:version < 700
  finish
endif
let g:loaded_commentary = 1

command! -range -bar Commentary call commentary#go(<line1>,<line2>)
xnoremap <silent> <Plug>Commentary     :Commentary<CR>
nnoremap <expr>   <Plug>Commentary     commentary#go()
nnoremap <expr>   <Plug>CommentaryLine commentary#go() . '_'
onoremap <silent> <Plug>Commentary        :<C-U>call commentary#textobject(0)<CR>
nnoremap <silent> <Plug>ChangeCommentary c:<C-U>call commentary#textobject(1)<CR>
nmap <silent> <Plug>CommentaryUndo :echoerr "Change your <Plug>CommentaryUndo map to <Plug>Commentary<Plug>Commentary"<CR>

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
