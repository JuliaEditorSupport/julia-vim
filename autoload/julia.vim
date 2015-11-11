function! julia#set_syntax_version(jvers)
  syntax clear
  let b:julia_syntax_version = a:jvers
  set filetype=julia
endfunction
