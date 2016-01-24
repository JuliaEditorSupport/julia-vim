function! julia#set_syntax_version(jvers)
  if &filetype != "julia"
    echo "Not a Julia file"
    return
  endif
  syntax clear
  let b:julia_syntax_version = a:jvers
  set filetype=julia
endfunction

function! julia#toggle_deprecated_syntax()
  if &filetype != "julia"
    echo "Not a Julia file"
    return
  endif
  syntax clear
  let hd = get(b:, "julia_syntax_highlight_deprecated",
      \    get(g:, "julia_syntax_highlight_deprecated", 0))
  let b:julia_syntax_highlight_deprecated = hd ? 0 : 1
  set filetype=julia
  if b:julia_syntax_highlight_deprecated
    echo "Highlighting of deprecated syntax enabled"
  else
    echo "Highlighting of deprecated syntax disabled"
  endif
endfunction
