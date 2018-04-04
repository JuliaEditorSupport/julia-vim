let s:FALSE = 0
let s:TRUE = 1

" path to the julia binary to communicate with
let g:julia#doc#juliapath = get(g:, 'julia#doc#juliapath', 'julia')

" command to open a new juliadoc buffer
" for example, :split, :vert split, :edit, :tabedit etc.
" if it is empty, split the current window depending on its size -> s:opencmd()
let g:julia#doc#opencmd = get(g:, 'julia#doc#opencmd', '')

" height of a juliadoc window (in case of horizontal split window by g:julia#doc#opencmd)
" if it is a positive number, adjust the height to the number of lines
" if is is a negative number, adjust the height to the percentage of &lines
" otherwise do nothing, see s:adjustwinsize()
let g:julia#doc#winheight = get(g:, 'julia#doc#winheight', -30)

" width of a juliadoc window (in case of vertical split window by g:julia#doc#opencmd)
" if it is a positive number, adjust the width to the number of columns
" if is is a negative number, adjust the height to the percentage of &columns
" otherwise do nothing, see s:adjustwinsize()
let g:julia#doc#winwidth = get(g:, 'julia#doc#winwidth', 80)

" a boolean option to control the location of cursor after opening a juliadoc window
" if it is TRUE, the cursor is moved to the original window
" if it is FALSE, the cursor is left in the juliadoc window
let g:julia#doc#cursorback = get(g:, 'julia#doc#cursorback', s:TRUE)



function! s:version() abort
  if !executable(g:julia#doc#juliapath)
    return 0.0
  endif

  let cmd = printf('%s -v', g:julia#doc#juliapath)
  let output = system(cmd)
  let versionstr = matchstr(output, '\m\C^julia version \zs\d\+\.\d\+\ze')
  return str2float(versionstr)
endfunction

let s:VERSION = s:version()
let s:NODOCPATTERN = '\m\C\VNo documentation found.'

function! julia#doc#lookup(keyword, ...) abort
  let juliapath = get(a:000, 0, 'julia')
  let cmd = printf('%s -E "@doc %s"', juliapath, a:keyword)
  return systemlist(cmd)
endfunction

function! julia#doc#open(keyword) abort
  if empty(a:keyword)
    call s:warn('Not an appropriate keyword.')
    return
  endif

  if !executable(g:julia#doc#juliapath)
    call s:warn('%s command is not executable', g:julia#doc#juliapath)
    return
  endif

  let buffername = printf('juliadoc://%s', a:keyword)
  let originaltabnr = tabpagenr()
  let originalwinnr = winnr()
  if s:isbufferexists(buffername)
    call s:openjuliadocwin(buffername)
  else
    let doc = julia#doc#lookup(a:keyword, g:julia#doc#juliapath)
    if empty(doc) || match(doc[0], s:NODOCPATTERN) > -1
      call s:warn('No documentation found for "%s".', a:keyword)
      return
    endif

    call s:openjuliadocwin(buffername)
    setlocal modifiable
    call s:writedoc(doc)
    setlocal nobackup noswapfile nomodifiable nobuflisted buftype=nofile bufhidden=hide
    setfiletype juliadoc
  endif

  if g:julia#doc#cursorback && tabpagenr() == originaltabnr && winnr() != originalwinnr
    execute originalwinnr . 'wincmd w'
  endif

  call filter(s:HELPHISTORY, 'v:val isnot# a:keyword')
  call add(s:HELPHISTORY, a:keyword)
endfunction

function! s:isbufferexists(buffername) abort
  return !empty(filter(map(getbufinfo(), 'v:val.name'), 'v:val is# a:buffername'))
endfunction

function! s:openjuliadocwin(buffername) abort
  let existingwinnr = s:existingwindow()
  if existingwinnr != 0
    " move to the existing window
    execute existingwinnr . 'wincmd w'
    if bufname('%') isnot# a:buffername
      execute printf('silent edit %s', a:buffername)
    endif
  else
    " open a new window
    let originaltabnr = tabpagenr()
    let originalwinnr = winnr()
    let originalheight = winheight(originalwinnr)
    let originalwidth = winwidth(originalwinnr)
    if !empty(g:julia#doc#opencmd)
      let opencmd = g:julia#doc#opencmd
    else
      let opencmd = s:opencmd(g:julia#doc#winwidth * 2)
    endif
    execute printf('silent %s %s', opencmd, a:buffername)

    call s:adjustwinsize(g:julia#doc#winheight, g:julia#doc#winwidth,
                       \ originalheight, originalwidth, originalwinnr,
                       \ originaltabnr)
  endif
endfunction

function! s:existingwindow() abort
  for winnr in range(1, winnr('$'))
    if bufname(winbufnr(winnr)) =~# '\m\C^juliadoc://'
      return winnr
    endif
  endfor
  return 0
endfunction

function! s:opencmd(thr_width) abort
  if a:thr_width != 0 && winwidth('%') >= a:thr_width
    return 'vert split'
  endif
  return 'split'
endfunction

function! s:adjustwinsize(height, width, originalheight, originalwidth,
                        \ originalwinnr, originaltabnr) abort
  if winnr() == a:originalwinnr
    " same window
    return
  endif
  if tabpagenr() != a:originaltabnr
    " another tabpage
    return
  endif

  if winwidth(winnr()) == a:originalwidth
    " horizontal split
    if a:height > 0
      execute 'resize ' . a:height
    elseif a:height < 0
      let winmaxheight = &lines
      execute 'resize' . float2nr(round(winmaxheight * abs(a:height) / 100.0))
    endif
  endif

  if winheight(winnr()) == a:originalheight
    " vertical split
    if a:width > 0
      execute 'vertical resize ' . a:width
    elseif a:width < 0
      let winmaxwidth = &columns
      execute 'vertical resize ' . float2nr(round(winmaxwidth * abs(a:width) / 100.0))
    endif
  endif
endfunction

function! s:writedoc(doc) abort
  silent %delete
  call append(0, a:doc)
  silent $delete
  normal! gg
endfunction

function! s:warn(...) abort
  if a:0 == 0
    return
  endif

  echohl WarningMsg
  if a:0 == 1
    echo a:1
  else
    echo call('printf', a:000)
  endif
  echohl None
endfunction



let s:KEYWORDPATTERN = '\m\%(@\h\k*\|\h\k*!\?\)'

function! julia#doc#keywordprg(...) abort
  if a:0 > 0 && a:1 isnot# expand('<cword>')
    " 'K' in visual mode
    if a:1 is# ''
      return
    endif
    let keyword = a:1
  else
    " 'K' in normal mode
    " NOTE: Because ! and @ is not in 'iskeyword' option, this func ignore
    "       the argument to recognize keywords like "@time" and "push!"
    let view = winsaveview()
    let curpos = getpos('.')
    let lnum = curpos[1]
    let tail = searchpos(s:KEYWORDPATTERN, 'ce', lnum)
    let head = searchpos(s:KEYWORDPATTERN, 'bc', lnum)
    call winrestview(view)
    if head == [0, 0] || tail == [0, 0]
      return
    else
      let start = head[1] - 1
      let end = tail[1] - 1
      let keyword = getline(lnum)[start : end]
    endif
  endif
  call julia#doc#open(keyword)
endfunction



let s:HELPPROMPT = 'help?> '
let s:HELPHISTORY = []

function! julia#doc#prompt() abort
  let inputhist = s:savehistory('input')
  try
    call s:restorehistory('input', s:HELPHISTORY)
    echohl MoreMsg
    let keyword = input(s:HELPPROMPT, '', 'customlist,julia#doc#complete')
    echohl NONE

    " Clear the last prompt
    normal! :
  finally
    call s:restorehistory('input', inputhist)
  endtry

  if empty(keyword)
    return
  endif

  call julia#doc#open(keyword)
endfunction

function! s:savehistory(name) abort
  if histnr(a:name) == -1
    return []
  endif

  let history = []
  for i in range(1, histnr(a:name))
    let item = histget(a:name, i)
    if !empty(item)
      call add(history, item)
    endif
  endfor
  return history
endfunction

function! s:restorehistory(name, history) abort
  call histdel(a:name)
  for item in a:history
    call histadd(a:name, item)
  endfor
endfunction



if s:VERSION > 0.6
  let s:REPL_SEARCH = 'import REPL.repl_search; repl_search'
else
  let s:REPL_SEARCH = 'Base.Docs.repl_search'
endif

function! julia#doc#complete(ArgLead, CmdLine, CursorPos) abort
  return s:likely(a:ArgLead)
endfunction

function! s:likely(str) abort
  let cmd = printf('%s -E "%s(\"%s\")"', g:julia#doc#juliapath, s:REPL_SEARCH, a:str)
  let output = systemlist(cmd)
  return split(matchstr(output[0], '\m\C^search: \zs.*'))
endfunction
