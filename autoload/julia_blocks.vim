function! julia_blocks#init_mappings()
  noremap <buffer> <nowait> <silent> ][ :<C-U>call julia_blocks#moveblock_N()<CR>
  noremap <buffer> <nowait> <silent> ]] :<C-U>call julia_blocks#moveblock_n()<CR>
  noremap <buffer> <nowait> <silent> [[ :<C-U>call julia_blocks#moveblock_p()<CR>
  noremap <buffer> <nowait> <silent> [] :<C-U>call julia_blocks#moveblock_P()<CR>

  noremap <buffer> <nowait> <silent> ]J :<C-U>call julia_blocks#move_N()<CR>
  noremap <buffer> <nowait> <silent> ]j :<C-U>call julia_blocks#move_n()<CR>
  noremap <buffer> <nowait> <silent> [j :<C-U>call julia_blocks#move_p()<CR>
  noremap <buffer> <nowait> <silent> [J :<C-U>call julia_blocks#move_P()<CR>
endfunction

function! julia_blocks#remove_mappings()
  unmap <buffer> ][
  unmap <buffer> ]]
  unmap <buffer> [[
  unmap <buffer> []
  unmap <buffer> ]j
  unmap <buffer> ]J
  unmap <buffer> [j
  unmap <buffer> [J
endfunction

function! s:abort()
  call setpos('.', b:jlblk_save_pos)
  call feedkeys("\<Esc>")
  return 0
endfunction

function! s:set_mark_tick(...)
  let pos = a:0 > 0 ? a:1 : getpos('.')
  call setpos('.', b:jlblk_save_pos)
  normal! m`
  keepjumps call setpos('.', pos)
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

function! s:moveto_block_delim(toend, backwards)
  let pattern = a:toend ? b:julia_end_keywords : b:julia_begin_keywords
  let flags = a:backwards ? 'Wb' : 'W'
  let ret = 0
  for c in range(v:count1)
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
  for c in range(v:count1)
    let last_seen_pos = getpos('.')
    if s:on_end()
      normal! hel
      let save_pos = getpos('.')
      let ret_start = s:moveto_block_delim(0, 0)
      let start1_pos = ret_start ? getpos('.') : [0,0,0,0]
      call setpos('.', save_pos)
      if s:on_end()
	normal! h
      endif
      let ret_end = s:moveto_block_delim(1, 0)
      let end1_pos = ret_end ? getpos('.')  : [0,0,0,0]

      if ret_start && (!ret_end || s:compare_pos(start1_pos, end1_pos) < 0)
	call setpos('.', start1_pos)
      else
	call setpos('.', save_pos)
      endif
    endif

    let moveret = s:moveto_currentblock_end()
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

  let vcount = v:count1

  let moveret = s:moveto_currentblock_end()
  if !moveret
    return s:abort()
  endif

  let ret = 0
  for c in range(vcount)
    let last_seen_pos = getpos('.')
    normal! hel
    let save_pos = getpos('.')
    let ret_start = s:moveto_block_delim(0, 0)
    let start1_pos = ret_start ? getpos('.') : [0,0,0,0]
    call setpos('.', save_pos)
    if s:on_end()
      normal! h
    endif
    let ret_end = s:moveto_block_delim(1, 0)
    let end1_pos = ret_end ? getpos('.') : [0,0,0,0]

    if ret_start && (!ret_end || s:compare_pos(start1_pos, end1_pos) < 0)
      call setpos('.', start1_pos)
      if !s:cycle_until_end()
	call setpos('.', last_seen_pos)
	break
      endif
      let ret = 1
    else
      call setpos('.', last_seen_pos)
      break
    endif
  endfor

  if !ret
    return s:abort()
  endif
  normal %

  call s:set_mark_tick()

  return 1
endfunction

function! julia_blocks#moveblock_p()
  call s:get_save_pos()

  let ret = 0
  for c in range(v:count1)
    let last_seen_pos = getpos('.')
    if s:on_begin()
      normal! lbh
      let save_pos = getpos('.')
      let ret_start = s:moveto_block_delim(0, 1)
      let start1_pos = ret_start ? getpos('.') : [0,0,0,0]
      call setpos('.', save_pos)
      let ret_end = s:moveto_block_delim(1, 1)
      let end1_pos = ret_end ? getpos('.') : [0,0,0,0]

      if ret_end && (!ret_start || s:compare_pos(start1_pos, end1_pos) < 0)
	call setpos('.', end1_pos)
      else
	call setpos('.', save_pos)
      endif
    endif

    let moveret = s:moveto_currentblock_end()
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

  let vcount = v:count1

  let moveret = s:moveto_currentblock_end()
  if !moveret
    return s:abort()
  endif
  normal %
  if !s:on_begin()
    return s:abort()
  endif

  let ret = 0
  for c in range(vcount)
    let last_seen_pos = getpos('.')
    normal! lbh
    let save_pos = getpos('.')
    let ret_start = s:moveto_block_delim(0, 1)
    let start1_pos = ret_start ? getpos('.') : [0,0,0,0]
    call setpos('.', save_pos)
    let ret_end = s:moveto_block_delim(1, 1)
    let end1_pos = ret_end ? getpos('.') : [0,0,0,0]

    if ret_end && (!ret_start || s:compare_pos(start1_pos, end1_pos) < 0)
      call setpos('.', end1_pos)
      normal %
      if !s:on_begin()
	call setpos('.', last_seen_pos)
	break
      endif
      let ret = 1
    else
      call setpos('.', last_seen_pos)
    endif
  endfor

  if !ret
    return s:abort()
  endif
  if !s:cycle_until_end()
    return s:abort()
  endif

  call s:set_mark_tick()

  return 1
endfunction
