" Vim indent file
" Language:	Julia
" Maintainer:	Carlo Baldassi <carlobaldassi@gmail.com>
" Last Change:	2011 dec 11
" Notes:        based on Bram Moneaar's indent file for vim

"set nocindent
"set smartindent
set autoindent

setlocal indentexpr=GetJuliaIndent()
setlocal indentkeys+==end,=else,=catch
setlocal indentkeys-=0#,:,0{,0}

" Only define the function once.
if exists("*GetJuliaIndent")
  finish
endif

let s:skipPatterns = '\<julia\%(ComprehensionFor\|RangeEnd\|CommentL\|\%([EILbf]\|Shell\)\=String\|RegEx\)\>'

function JuliaMatch(lnum, str, regex, st)
  let s = a:st
  while 1
    let f = match(a:str, a:regex, s)
    if f > 0
      let attr = synIDattr(synID(a:lnum,f+1,1),"name")
      if attr =~ s:skipPatterns
        let s = f+1
        continue
      endif
    endif
    break
  endwhile
  return f
endfunction

function GetJuliaNestingStruct(lnum)
  let line = getline(a:lnum)
  let s = 0
  let blocks_stack = []
  let num_closed_blocks = 0
  while 1
    let fb = JuliaMatch(a:lnum, line, '@\@<!\<\%(if\|else\%[if]\|while\|for\|try\|catch\|function\|macro\|begin\|type\|let\|module\|quote\|do\)\>', s)
    let fe = JuliaMatch(a:lnum, line, '@\@<!\<end\>', s)

    if fb < 0 && fe < 0
      break
    end

    if fb >= 0 && (fb < fe || fe < 0)

      let i = JuliaMatch(a:lnum, line, '@\@<!\<if\>', s)
      if i >= 0 && i == fb
        let s = i+1
        call add(blocks_stack, 'if')
        continue
      endif
      let i = JuliaMatch(a:lnum, line, '@\@<!\<elseif\>', s)
      if i >= 0 && i == fb
        let s = i+1
        if len(blocks_stack) > 0 && blocks_stack[-1] == 'if'
          let blocks_stack[-1] = 'elseif'
        elseif len(blocks_stack) > 0 && blocks_stack[-1] != 'elseif'
          call add(blocks_stack, 'elseif')
          let num_closed_blocks += 1
        endif
        continue
      endif
      let i = JuliaMatch(a:lnum, line, '@\@<!\<else\>', s)
      if i >= 0 && i == fb
        let s = i+1
        if len(blocks_stack) > 0 && blocks_stack[-1] == 'if'
          let blocks_stack[-1] = 'else'
        elseif len(blocks_stack) > 0 && blocks_stack[-1] == 'elseif'
          let blocks_stack[-1] = 'else'
        else
          call add(blocks_stack, 'else')
          let num_closed_blocks += 1
        endif
        continue
      endif

      let i = JuliaMatch(a:lnum, line, '@\@<!\<try\>', s)
      if i >= 0 && i == fb
        let s = i+1
        call add(blocks_stack, 'try')
        continue
      endif
      let i = JuliaMatch(a:lnum, line, '@\@<!\<catch\>', s)
      if i >= 0 && i == fb
        let s = i+1
        if len(blocks_stack) > 0 && blocks_stack[-1] == 'try'
          let blocks_stack[-1] = 'catch'
        else
          call add(blocks_stack, 'catch')
          let num_closed_blocks += 1
        endif
        continue
      endif

      let i = JuliaMatch(a:lnum, line, '@\@<!\<\%(while\|for\|function\|macro\|begin\|type\|let\|module\|quote\|do\)\>', s)
      if i >= 0 && i == fb
        let s = i+1
        call add(blocks_stack, 'other')
        continue
      endif

    else

      let i = fe
      if len(blocks_stack) == 0
        let s = i+1
        let num_closed_blocks += 1
        continue
      end

      if blocks_stack[-1] == 'if'
        call remove(blocks_stack, -1)
        let s = i+1
        continue
      end
      if blocks_stack[-1] == 'elseif'
        call remove(blocks_stack, -1)
        let s = i+1
        continue
      end
      if blocks_stack[-1] == 'else'
        call remove(blocks_stack, -1)
        let s = i+1
        continue
      end
      if blocks_stack[-1] == 'try'
        call remove(blocks_stack, -1)
        let s = i+1
        continue
      end
      if blocks_stack[-1] == 'catch'
        call remove(blocks_stack, -1)
        let s = i+1
        continue
      end
      if blocks_stack[-1] == 'other'
        call remove(blocks_stack, -1)
        let s = i+1
        continue
      end
    end

    " note: we shouldn't get here (?)
    break
  endwhile
  return [blocks_stack, num_closed_blocks]
endfunction

function GetJuliaIndent()
  " Find a non-blank line above the current line.
  let lnum = prevnonblank(v:lnum - 1)

  " At the start of the file use zero indent.
  if lnum == 0
    return 0
  endif

  let ind = indent(lnum)

  let [blocks_stack, num_closed_blocks] = GetJuliaNestingStruct(lnum)

  let num_open_blocks = len(blocks_stack)
  while num_open_blocks > 0
    let ind += &sw
    let num_open_blocks -= 1
  endwhile

  let [blocks_stack, num_closed_blocks] = GetJuliaNestingStruct(v:lnum)

  while num_closed_blocks > 0
    let ind -= &sw
    let num_closed_blocks -= 1
  endwhile

  return ind
endfunction
