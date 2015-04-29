" Vim filetype plugin file
" Language:	Julia
" Maintainer:	Carlo Baldassi <carlobaldassi@gmail.com>
" Last Change:	2014 may 29

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:save_cpo = &cpo
set cpo-=C

setlocal include="^\s*\%(reload\|include\)\>"
setlocal suffixesadd=.jl
setlocal comments=:#
setlocal commentstring=#=%s=#
setlocal cinoptions+=#1
setlocal define="^\s*macro\>"

" Comment the following line if you don't want operators to be
" syntax-highlightened
let g:julia_highlight_operators = 1

let b:julia_vim_loaded = 1

let b:undo_ftplugin = "setlocal include< suffixesadd< comments< commentstring<"
      \ . " define< shiftwidth< expandtab< indentexpr< indentkeys< cinoptions< omnifunc<"
      \ . " | unlet! b:julia_vim_loaded"

" MatchIt plugin support
if exists("loaded_matchit")
  let b:match_ignorecase = 0

  " note: begin_keywords must contain all blocks in order
  " for nested-structures-skipping to work properly
  let b:julia_begin_keywords = '\%(\.\s*\)\@<!\<\%(\%(staged\)\?function\|macro\|begin\|type\|immutable\|let\|do\|\%(bare\)\?module\|quote\|if\|for\|while\|try\)\>'
  let b:julia_end_keywords = '\<end\>'

  " note: this function relies heavily on the syntax file
  function! JuliaGetMatchWords()
    let s:attr = synIDattr(synID(line("."),col("."),1),"name")
    if s:attr == 'juliaConditional'
      return b:julia_begin_keywords . ':\<\%(elseif\|else\)\>:' . b:julia_end_keywords
    elseif s:attr =~ '\<\%(juliaRepeat\|juliaRepKeyword\)\>'
      return b:julia_begin_keywords . ':\<\%(break\|continue\)\>:' . b:julia_end_keywords
    elseif s:attr == 'juliaBlKeyword'
      return b:julia_begin_keywords . ':' . b:julia_end_keywords
    elseif s:attr == 'juliaException'
      return b:julia_begin_keywords . ':\<\%(catch\|finally\)\>:' . b:julia_end_keywords
    endif
    return ''
  endfunction

  let b:match_words = 'JuliaGetMatchWords()'

  " we need to skip everything within comments, strings and
  " the 'end' keyword when it is used as a range rather than as
  " the end of a block
  let b:match_skip = 'synIDattr(synID(line("."),col("."),1),"name") =~ '
        \ . '"\\<julia\\%(ComprehensionFor\\|RangeEnd\\|QuotedBlockKeyword\\|InQuote\\|Comment[LM]\\|\\%([bv]\\|ip\\|MIME\\|Tri\\|Shell\\)\\?String\\|RegEx\\)\\>"'

  let b:undo_ftplugin = b:undo_ftplugin
        \ . " | unlet! b:match_words b:match_skip b:match_ignorecase"
        \ . " | unlet! b:julia_begin_keywords b:julia_end_keywords"
        \ . " | delfunction JuliaGetMatchWords"
endif

if has("gui_win32")
  let b:browsefilter = "Julia Source Files (*.jl)\t*.jl\n"
  let b:undo_ftplugin = b:undo_ftplugin . " | unlet! b:browsefilter"
endif

let &cpo = s:save_cpo
unlet s:save_cpo
