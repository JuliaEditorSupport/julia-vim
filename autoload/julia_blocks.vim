" Facilities for moving around Julia blocks (e.g. if/end, function/end etc.)

let s:default_mappings = {
  \  "moveblock_n" : "]]",
  \  "moveblock_N" : "][",
  \  "moveblock_p" : "[[",
  \  "moveblock_P" : "[]",
  \
  \  "move_n" : "]j",
  \  "move_N" : "]J",
  \  "move_p" : "[j",
  \  "move_P" : "[J",
  \  }

function! s:getmapchars(function)
  if exists("g:julia_blocks_mappings") && has_key(g:julia_blocks_mappings, a:function)
    return s:escape(g:julia_blocks_mappings[a:function])
  else
    return s:escape(s:default_mappings[a:function])
  endif
endfunction

function! s:map(function, toend, backwards)
  let chars = s:getmapchars(a:function)
  if empty(chars)
    return
  endif
  let fn = "julia_blocks#" . a:function
  let lhs = "<buffer> <nowait> <silent> " . chars
  let cnt = " :<C-U>let b:jlblk_count=v:count1"
  exe "nnoremap " . lhs . cnt
    \ . " <Bar> call " . fn . "()<CR>"
  exe "onoremap " . lhs . cnt
    \ . "<CR><Esc>:call julia_blocks#owrapper(v:operator, \"" . fn . "\", " . a:toend . ", " . a:backwards . ")<CR>"
  exe "xnoremap " . lhs . cnt
    \ . "<CR>gv<Esc>:call julia_blocks#vwrapper(\"" . fn . "\")<CR>"
endfunction

function! julia_blocks#owrapper(oper, function, toend, backwards)
  let F = function(a:function)

  let save_redraw = &lazyredraw
  let save_select = &selection

  let restore_cmds = "\<Esc>"
    \ . ":let &l:selection = \"" . save_select . "\"\<CR>"
    \ . ":let &l:lazyredraw = " . save_redraw . "\<CR>"
    \ . ":\<BS>"

  setlocal lazyredraw

  let start_pos = getpos('.')
  let b:jlblk_abort_calls_esc = 0
  call F()
  let b:jlblk_abort_calls_esc = 1
  let end_pos = getpos('.')
  if start_pos == end_pos
    call feedkeys(restore_cmds)
  endif

  if a:backwards || !a:toend
    let &l:selection = "exclusive"
  endif
  if a:toend && a:backwards
    let end_pos[2] += 1
  endif

  if s:compare_pos(start_pos, end_pos) > 0
    let [start_pos, end_pos] = [end_pos, start_pos]
  endif

  call setpos("'<", start_pos)
  call setpos("'>", end_pos)

  call feedkeys("gv" . a:oper . restore_cmds . (a:oper == "c" ? "i" : ""))
endfunction

function! julia_blocks#vwrapper(function)
  let F = function(a:function)

  let s = getpos('.')
  let b1 = getpos("'<")
  let b2 = getpos("'>")

  let b = b1 == s ? b2 : b1
  call setpos('.', s)
  let b:jlblk_abort_calls_esc = 0
  call F()
  let b:jlblk_abort_calls_esc = 1
  let e = getpos('.')
  call setpos('.', b)
  exe "normal " . visualmode()
  call setpos('.', e)
endfunction

function! s:unmap(function)
  let chars = s:getmapchars(a:function)
  if empty(chars)
    return
  endif
  let fn = "julia_blocks#" . a:function
  let cmd = "<buffer> " . chars
  for m in ["n", "x", "o"]
    exe m . "unmap " . cmd
  endfor
endfunction

function! s:escape(chars)
  let c = a:chars
  let c = substitute(c, '<', '<LT>', 'g')
  let c = substitute(c, '|', '<Bar>', 'g')
  return c
endfunction

let g:julia_blocks_functions = [
      \  ["moveblock_N", 1, 0],
      \  ["moveblock_n", 0, 0],
      \  ["moveblock_p", 0, 1],
      \  ["moveblock_P", 1, 1],
      \
      \  ["move_N", 1, 0],
      \  ["move_n", 0, 0],
      \  ["move_p", 0, 1],
      \  ["move_P", 1, 1]]

function! julia_blocks#init_mappings()
  for [f,te,bw] in g:julia_blocks_functions
    call s:map(f, te, bw)
  endfor
endfunction

function! julia_blocks#remove_mappings()
  for [f;rest] in g:julia_blocks_functions
    call s:unmap(f)
  endfor
  unlet! b:jlblk_save_pos b:jlblk_count b:jlblk_abort_calls_esc
endfunction

function! s:abort()
  call setpos('.', b:jlblk_save_pos)
  if get(b:, "jlblk_abort_calls_esc", 1)
    call feedkeys("\<Esc>")
  endif
  return 0
endfunction

function! s:set_mark_tick(...)
  let pos = a:0 > 0 ? a:1 : getpos('.')
  call setpos("''", b:jlblk_save_pos)
  "normal! m`
  "keepjumps call setpos('.', pos)
endfunction

function! s:get_save_pos()
  let b:jlblk_save_pos = getpos('.')
endfunction

function! s:on_end()
  return getline('.')[col('.')-1] =~# '\k' && expand("<cword>") =~# b:julia_end_keywords
endfunction

function! s:on_begin()
  return getline('.')[col('.')-1] =~# '\k' && expand("<cword>") =~# b:julia_begin_keywords
endfunction

function! s:cycle_until_end()
  let pos = getpos('.')
  while !s:on_end()
    normal %
    let c = 0
    if getpos('.') == pos || c > 1000
      " shouldn't happen, but let's avoid infinite loops anyway
      return 0
    endif
    let c += 1
  endwhile
  return 1
endfunction

function! s:moveto_block_delim(toend, backwards, ...)
  let pattern = a:toend ? b:julia_end_keywords : b:julia_begin_keywords
  let flags = a:backwards ? 'Wb' : 'W'
  let cnt = a:0 > 0 ? a:1 : b:jlblk_count
  let ret = 0
  for c in range(cnt)
    if a:toend && a:backwards && s:on_end()
      normal! bh
    endif
    while 1
      let searchret = search(pattern, flags)
      if !searchret
	return ret
      endif
      exe "let skip = " . b:match_skip
      if !skip
	let ret = 1
	break
      endif
    endwhile
  endfor
  return ret
endfunction

function! s:compare_pos(pos1, pos2)
  if a:pos1[1] < a:pos2[1]
    return -1
  elseif a:pos1[1] > a:pos2[1]
    return 1
  elseif a:pos1[2] < a:pos2[2]
    return -1
  elseif a:pos1[2] > a:pos2[2]
    return 1
  else
    return 0
  endif
endfunction

function! julia_blocks#move_N()
  call s:get_save_pos()

  let ret = s:moveto_block_delim(1, 0)
  if !ret
    return s:abort()
  endif

  normal! e
  call s:set_mark_tick()

  return 1
endfunction

function! julia_blocks#move_n()
  call s:get_save_pos()

  let ret = s:moveto_block_delim(0, 0)
  if !ret
    return s:abort()
  endif

  call s:set_mark_tick()

  return 1
endfunction

function! julia_blocks#move_p()
  call s:get_save_pos()

  let ret = s:moveto_block_delim(0, 1)
  if !ret
    return s:abort()
  endif

  call s:set_mark_tick()

  return 1
endfunction

function! julia_blocks#move_P()
  call s:get_save_pos()

  let ret = s:moveto_block_delim(1, 1)
  if !ret
    return s:abort()
  endif

  normal! e
  call s:set_mark_tick()

  return 1
endfunction

function! s:moveto_currentblock_end()
  let flags = 'W'
  if s:on_end()
    let flags .= 'c'
    " NOTE: using "normal! lb" fails at the end of the file (?!)
    normal! l
    normal! b
  endif

  let ret = searchpair(b:julia_begin_keywords, '', b:julia_end_keywords, flags, b:match_skip)
  if ret <= 0
    return s:abort()
  endif

  normal! e
  return 1
endfunction

function! julia_blocks#moveblock_N()
  call s:get_save_pos()

  let ret = 0
  for c in range(b:jlblk_count)
    let last_seen_pos = getpos('.')
    if s:on_end()
      normal! hel
      let save_pos = getpos('.')
      let ret_start = s:moveto_block_delim(0, 0, 1)
      let start1_pos = ret_start ? getpos('.') : [0,0,0,0]
      call setpos('.', save_pos)
      if s:on_end()
	normal! h
      endif
      let ret_end = s:moveto_block_delim(1, 0, 1)
      let end1_pos = ret_end ? getpos('.')  : [0,0,0,0]

      if ret_start && (!ret_end || s:compare_pos(start1_pos, end1_pos) < 0)
	call setpos('.', start1_pos)
      else
	call setpos('.', save_pos)
      endif
    endif

    let moveret = s:moveto_currentblock_end()
    if !moveret && c == 0
      let moveret = s:moveto_block_delim(0, 0, 1) && s:cycle_until_end()
      if moveret
        normal! e
      endif
    endif
    if !moveret
      call setpos('.', last_seen_pos)
      break
    endif

    let ret = 1
  endfor
  if !ret
    return s:abort()
  endif

  call s:set_mark_tick()

  return 1
endfunction

function! julia_blocks#moveblock_n()
  call s:get_save_pos()

  let ret = 0
  for c in range(b:jlblk_count)
    let last_seen_pos = getpos('.')

    call s:moveto_currentblock_end()
    if s:on_end()
      normal! hel
    endif
    if s:moveto_block_delim(0, 0, 1)
      let ret = 1
    else
      call setpos('.', last_seen_pos)
      break
    endif
  endfor

  if !ret
    return s:abort()
  endif

  call s:set_mark_tick()

  return 1
endfunction

function! julia_blocks#moveblock_p()
  call s:get_save_pos()

  let ret = 0
  for c in range(b:jlblk_count)
    let last_seen_pos = getpos('.')
    if s:on_begin()
      normal! lbh
      let save_pos = getpos('.')
      let ret_start = s:moveto_block_delim(0, 1, 1)
      let start1_pos = ret_start ? getpos('.') : [0,0,0,0]
      call setpos('.', save_pos)
      let ret_end = s:moveto_block_delim(1, 1, 1)
      let end1_pos = ret_end ? getpos('.') : [0,0,0,0]

      if ret_end && (!ret_start || s:compare_pos(start1_pos, end1_pos) < 0)
	call setpos('.', end1_pos)
      else
	call setpos('.', save_pos)
      endif
    endif

    let moveret = s:moveto_currentblock_end()
    if !moveret && c == 0
      let moveret = s:moveto_block_delim(1, 1, 1)
    endif
    if !moveret
      call setpos('.', last_seen_pos)
      break
    endif

    normal %
    let ret = 1
  endfor
  if !ret
    return s:abort()
  endif

  call s:set_mark_tick()

  return 1
endfunction

function! julia_blocks#moveblock_P()
  call s:get_save_pos()

  let ret = 0
  for c in range(b:jlblk_count)
    let last_seen_pos = getpos('.')

    call s:moveto_currentblock_end()
    if s:on_end()
      normal %
    endif

    if s:on_begin()
      normal! lbh
    endif
    if s:moveto_block_delim(1, 1, 1)
      normal! he
      let ret = 1
    else
      call setpos('.', last_seen_pos)
    endif
  endfor

  if !ret
    return s:abort()
  endif

  call s:set_mark_tick()

  return 1
endfunction
