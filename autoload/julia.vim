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

if exists("loaded_matchit")

function! julia#toggle_function_blockassign()
    let sav_pos = getcurpos()
    let l = getline('.')
    let c = match(l, '\C\m\<function\s\+.\+(')
    if c != -1
        return julia#function_block2assign()
    endif
    let c = match(l, '\C\m)\%(::\S\+\)\?\%(\s\+where\s\+.*\)\?\s*=\s*')
    if c == -1
        echohl WarningMsg | echo "Not on a function definition or assignment line" | echohl None
        return
    endif
    return julia#function_assign2block()
endfunction

function! julia#function_block2assign()
    let sav_pos = getcurpos()
    let l = getline('.')
    let c = match(l, '\C\m\<function\s\+.\+(')
    if c == -1
        echohl WarningMsg | echo "Not on a function definition line" | echohl None
        return
    endif
    let fpos = copy(sav_pos)
    let fpos[2] = c+1
    call setpos('.', fpos)
    normal %
    if line('.') != fpos[1]+2 || match(getline('.'), '\C\m^\s*end\s*$') == -1
        echohl WarningMsg | echo "Only works with 3-lines functions" | echohl None
        call setpos('.', sav_pos)
        return
    endif
    call setpos('.', fpos)
    normal! f(
    normal %
    while line('.') == fpos[1] && match(l[col('.')-1:], '\C\m)(') == 0
        normal! l
        normal %
    endwhile
    if line('.') != fpos[1] || match(l[(col('.')-1):], '\C\m)\%(::\S\+\)\?\%(\s\+where\s\+.*\)\?\s*$') != 0
        echohl WarningMsg | echo "Unrecognized function definition format" | echohl None
        call setpos('.', sav_pos)
        return
    endif

    call setpos('.', fpos)
    normal! dwA = J
    if match(getline('.')[(col('.')-1):], '\C\mreturn\>') == 0
        normal! dw
    endif
    if match(getline('.')[(col('.')-1):], '\C\m\s*$') == 0
        normal! F=C= nothing
    endif
    normal! jddk^
    return
endfunction

function! julia#function_assign2block()
    let sav_pos = getcurpos()
    let l = getline('.')
    let c = match(l, '\C\m)\%(::\S\+\)\?\%(\s\+where\s\+.*\)\?\s*=\s*')
    if c == -1
        echohl WarningMsg | echo "Not on a function assignment-definition line" | echohl None
        return
    endif
    normal ^
    while match(l[(col('.')-1):], '\%(\S\+\.\)*@') == 0
        normal! W
    endwhile
    normal! ifunction 
    let l = getline('.')
    let c = match(l, '\C\m)\%(::\S\+\)\?\%(\s\+where\s\+.*\)\?\s*\zs=\s*')
    let eqpos = copy(sav_pos)
    let eqpos[2] = c+1
    call setpos('.', eqpos)
    normal! cwoend
    normal %
    s/\s*$// | noh
    return
endfunction

endif
