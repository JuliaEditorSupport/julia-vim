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
let g:julia_highlight_operators=1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Support for LaTex-to-Unicode conversion as in the Julia REPL "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:julia_latex_symbols = julia_latex_symbols#get_dict()

" A hack to forcibly get out of completion mode: feed
" this string with feedkeys()
let s:julia_esc_sequence = "\u0091\<BS>"

" Some data used to keep track of the previous completion attempt.
" Used to detect
" 1) if we just attempted the same completion, or
" 2) if backspace was just pressed while completing
" This function initializes and resets the required info

function! s:JuliaResetLastCompletionInfo()
  let b:julia_completed_once = 0
  let b:julia_bs_while_completing = 0
  let b:julia_last_compl = {
        \ 'line': '',
        \ 'col0': -1,
        \ 'col1': -1,
        \ }
endfunction

call s:JuliaResetLastCompletionInfo()

" Following are some flags used to pass information between the function which
" attempts the LaTeX-to-Unicode completion and the fallback function

" Was a (possibly partial) completion found?
let b:julia_found_completion = 0
" Is the cursor just after a single backslash
let b:julia_singlebslash = 0
" Backup value of the completeopt settings
" (since we temporarily add the 'longest' setting while
"  attempting LaTeX-to-Unicode)
let b:bk_completeopt = &completeopt
" Are we in the middle of a Julia tab completion?
let b:julia_tab_completing = 0
" Are we calling the tab fallback?
let b:julia_in_fallback = 0


" This function only detects whether an exact match is found for a LaTeX
" symbol in front of the cursor
function! LaTeXtoUnicode_match()
  let col1 = col('.')
  let l = getline('.')
  let col0 = match(l[0:col1-2], '\\[^[:space:]\\]\+$')
  if col0 == -1
    return 0
  endif
  let base = l[col0 : col1-1]
  return has_key(g:julia_latex_symbols, base)
endfunction

" Helper function to sort suggestion entries
function! s:partmatches_sort(p1, p2)
  return a:p1.word > a:p2.word ? 1 : a:p1.word < a:p2.word ? -1 : 0
endfunction

" Helper function to fix display of Unicode compose characters
" in the suggestions menu (they are displayed on top of '◌')
function! s:fix_compose_chars(uni)
  let u = matchstr(a:uni, '^.')
  let isc = ("\u0300" <= u && u <= "\u036F") ||
          \ ("\u1DC0" <= u && u <= "\u1DFF") ||
          \ ("\u20D0" <= u && u <= "\u20FF") ||
          \ ("\uFE20" <= u && u <= "\uFE2F")
  return isc ? "\u25CC" . a:uni : a:uni
endfunction

" Helper function to find the longest common prefix among
" partial completion matches (used when suggestions are disabled
" and in command line mode)
function! s:longest_common_prefix(partmatches)
  let common = a:partmatches[0]
  for i in range(1, len(a:partmatches)-1)
    let p = a:partmatches[i]
    if len(p) < len(common)
      common = common[0 : len(p)-1]
    endif
    for j in range(1, len(common)-1)
      if p[j] != common[j]
        let common = common[0 : j-1]
        break
      endif
    endfor
  endfor
  return common
endfunction

" Omnicompletion function. Besides the usual two-stage omnifunc behaviour,
" it has the following peculiar features:
"  *) keeps track of the previous completion attempt
"  *) sets some info to be used by the fallback function
"  *) either returns a list of completions if a partial match is found, or a
"     Unicode char if an exact match is found
"  *) forces its way out of completion mode through a hack in some cases
function! LaTeXtoUnicode_omnifunc(findstart, base)
  if a:findstart
    " first stage
    " avoid infinite loop if the fallback happens to call omnicompletion
    if b:julia_in_fallback
      let b:julia_in_fallback = 0
      return -3
    endif
    let b:julia_in_fallback = 0
    " set info for the callback
    let b:julia_tab_completing = 1
    let b:julia_found_completion = 1
    " analyse current line
    let col1 = col('.')
    let l = getline('.')
    let col0 = match(l[0:col1-2], '\\[^[:space:]\\]\+$')
    " compare with previous completion attempt
    let b:julia_bs_while_completing = 0
    let b:julia_completed_once = 0
    if col0 == b:julia_last_compl['col0']
      let prevl = b:julia_last_compl['line']
      if col1 == b:julia_last_compl['col1'] && l ==# prevl
        let b:julia_completed_once = 1
      elseif col1 == b:julia_last_compl['col1'] - 1 && l ==# prevl[0 : col1-2] . prevl[col1 : -1]
        let b:julia_bs_while_completing = 1
      endif
    endif
    " store completion info for next attempt
    let b:julia_last_compl['col0'] = col0
    let b:julia_last_compl['col1'] = col1
    let b:julia_last_compl['line'] = l
    " is the cursor right after a backslash?
    let b:julia_singlebslash = (match(l[0:col1-2], '\\$') >= 0)
    " completion not found
    if col0 == -1
      let b:julia_found_completion = 0
      call feedkeys(s:julia_esc_sequence)
      let col0 = -2
    endif
    return col0
  else
    " read settings (eager mode is implicit when suggestions are disabled)
    let suggestions = get(g:, "julia_latex_suggestions_enabled", 1)
    let eager = get(g:, "julia_latex_to_unicode_eager", 1) || !suggestions
    " search for matches
    let partmatches = []
    let exact_match = 0
    for k in keys(g:julia_latex_symbols)
      if k ==# a:base
        let exact_match = 1
      endif
      if len(k) >= len(a:base) && k[0 : len(a:base)-1] ==# a:base
        let menu = s:fix_compose_chars(g:julia_latex_symbols[k])
        if suggestions
          call add(partmatches, {'word': k, 'menu': menu})
        else
          call add(partmatches, k)
        endif
      endif
    endfor
    " exact matches are replaced with Unicode
    " exceptions:
    "  *) we reached an exact match by pressing backspace while completing
    "  *) the exact match is one among many, and the eager setting is
    "     disabled, and it's the first time this completion is attempted
    if exact_match && !b:julia_bs_while_completing && (len(partmatches) == 1 || eager || b:julia_completed_once)
      " the completion is successful: reset the last completion info...
      call s:JuliaResetLastCompletionInfo()
      " ...force our way out of completion mode...
      call feedkeys(s:julia_esc_sequence)
      " ...return the Unicode symbol
      return [g:julia_latex_symbols[a:base]]
    endif
    " here, only partial matches were found; either keep just the longest
    " common prefix, or pass them on
    if !suggestions
      let partmatches = [s:longest_common_prefix(partmatches)]
    else
      call sort(partmatches, "s:partmatches_sort")
    endif
    if empty(partmatches)
      call feedkeys(s:julia_esc_sequence)
      let b:julia_found_completion = 0
    endif
    return partmatches
  endif
endfunction

set omnifunc=LaTeXtoUnicode_omnifunc

" Trigger for the previous mapping of <Tab>
let s:JuliaFallbackTabTrigger = "\u0091JuliaFallbackTab"

" Function which saves the current insert-mode mapping of a key sequence `s`
" and associates it with another key sequence `k` (e.g. stores the current
" <Tab> mapping into the Fallback trigger)
function! s:JuliaSetFallbackMapping(s, k)
  let mmdict = maparg(a:s, 'i', 0, 1)
  if empty(mmdict)
    exe 'inoremap <buffer> ' . a:k . ' ' . a:s
    return
  endif
  let rhs = mmdict["rhs"]
  if rhs =~# '^<Plug>Julia'
    return
  endif
  let pre = '<buffer>'
  if mmdict["silent"]
    let pre = pre . '<silent>'
  endif
  if mmdict["expr"]
    let pre = pre . '<expr>'
  endif
  if mmdict["noremap"]
    let cmd = 'inoremap '
  else
    let cmd = 'imap '
  endif
  exe cmd . pre . ' ' . a:k . ' ' . rhs
endfunction

" This is the function which is mapped to <Tab>
function! JuliaTab()
  " the <Tab> is passed through to the fallback mapping if the completion
  " menu is present, and it hasn't been raised by the Julia tab, and there
  " isn't an exact match before the cursor when suggestions are disabled
  if pumvisible() && !b:julia_tab_completing && (get(g:, "julia_latex_suggestions_enabled", 1) || !LaTeXtoUnicode_match())
    call feedkeys(s:JuliaFallbackTabTrigger)
    return ''
  endif
  " temporary change to completeopt to use the `longest` setting, which is
  " probably the only one which makes sense given that the goal of the
  " completion is to substitute the final string
  let b:bk_completeopt = &completeopt
  set completeopt+=longest
  " invoke omnicompletion; failure to perform LaTeX-to-Unicode completion is
  " handled by the CompleteDone autocommand.
  return "\<C-X>\<C-O>"
endfunction

" This function is called at every CompleteDone event, and is meant to handle
" the failures of LaTeX-to-Unicode completion by calling a fallback
function! JuliaFallbackCallback()
  if !b:julia_tab_completing
    " completion was not initiated by Julia, nothing to do
    return
  else
    " completion was initiated by Julia, restore completeopt
    let &completeopt = b:bk_completeopt
  endif
  " at this point Julia tab completion is over
  let b:julia_tab_completing = 0
  " if the completion was successful do nothing
  if b:julia_found_completion == 1 || b:julia_singlebslash == 1
    return
  endif
  " fallback
  let b:julia_in_fallback = 1
  call feedkeys(s:JuliaFallbackTabTrigger)
  return
endfunction

" This is the function which is mapped to <S-Tab> in command-line mode
function! JuliaCmdTab()
  " first stage
  " analyse command line
  let col1 = getcmdpos() - 1
  let l = getcmdline()
  let col0 = match(l[0:col1-1], '\\[^[:space:]\\]\+$')
  let b:julia_singlebslash = (match(l[0:col1-1], '\\$') >= 0)
  " completion not found
  if col0 == -1
    return l
  endif
  let base = l[col0 : col1-1]
  " search for matches
  let partmatches = []
  let exact_match = 0
  for k in keys(g:julia_latex_symbols)
    if k ==# base
      let exact_match = 1
    endif
    if len(k) >= len(base) && k[0 : len(base)-1] ==# base
      call add(partmatches, k)
    endif
  endfor
  if len(partmatches) == 0
    return l
  endif
  " exact matches are replaced with Unicode
  if exact_match
    let unicode = g:julia_latex_symbols[base]
    if col0 > 0
      let pre = l[0 : col0 - 1]
    else
      let pre = ''
    endif
    let posdiff = col1-col0 - len(unicode)
    call setcmdpos(col1 - posdiff + 1)
    return pre . unicode . l[col1 : -1]
  endif
  " no exact match: complete with the longest common prefix
  let common = s:longest_common_prefix(partmatches)
  if col0 > 0
    let pre = l[0 : col0 - 1]
  else
    let pre = ''
  endif
  let posdiff = col1-col0 - len(common)
  call setcmdpos(col1 - posdiff + 1)
  return pre . common . l[col1 : -1]
endfunction

" Did we install the Julia tab mappings?
let b:julia_tab_set = 0

" Setup the Julia tab mapping
function! s:JuliaSetTab(wait_vim_enter)
  " g:julia_did_vim_enter is set from an autocommand in ftdetect
  if a:wait_vim_enter && !get(g:, "julia_did_vim_enter", 0)
    return
  endif
  if !get(g:, "julia_latex_to_unicode", 1)
    return
  endif
  call s:JuliaSetFallbackMapping('<Tab>', s:JuliaFallbackTabTrigger)
  imap <buffer> <Tab> <Plug>JuliaTab
  cmap <buffer> <S-Tab> <Plug>JuliaCmdTab
  inoremap <buffer><expr> <Plug>JuliaTab JuliaTab()
  cnoremap <buffer> <Plug>JuliaCmdTab <C-\>eJuliaCmdTab()<CR>

  augroup JuliaTab
    autocmd!
    " Every time a completion finishes, the fallback may be invoked
    autocmd CompleteDone <buffer> call JuliaFallbackCallback()
  augroup END

  let b:julia_tab_set = 1
endfunction

" Revert the Julia tab mapping settings
function! JuliaUnsetTab()
  if !b:julia_tab_set
    return
  endif
  iunmap <buffer> <Tab>
  if empty(maparg("<Tab>", "i"))
    call s:JuliaSetFallbackMapping(s:JuliaFallbackTabTrigger, '<Tab>')
  endif
  iunmap <buffer> <Plug>JuliaTab
  exe 'iunmap <buffer> ' . s:JuliaFallbackTabTrigger
  autocmd! JuliaTab
  augroup! JuliaTab
  let b:julia_tab_set = 0
endfunction

" Function which looks for viable LaTeX-to-Unicode supstitutions as you type
function! JuliaAutoLaTeXtoUnicode(...)
  let vc = a:0 == 0 ? v:char : a:1
  let col1 = col('.')
  let lnum = line('.')
  if col1 == 1
    if a:0 > 1
      call feedkeys(a:2, 'n')
    endif
    return ''
  endif
  let bs = (vc != "\n")
  let l = getline(lnum)[0 : col1-1-bs] . v:char
  let col0 = match(l, '\\\%([_^]\?[A-Za-z]\+\%' . col1 . 'c\%([^A-Za-z]\|$\)\|[_^]\%([0-9()=+-]\)\%' . col1 .'c\%(.\|$\)\)')
  if col0 == -1
    if a:0 > 1
      call feedkeys(a:2, 'n')
    endif
    return ''
  endif
  let base = l[col0 : -1-bs]
  let unicode = get(g:julia_latex_symbols, base, '')
  if empty(unicode)
    if a:0 > 1
      call feedkeys(a:2, 'n')
    endif
    return ''
  endif
  call feedkeys("\<C-G>u", 'n')
  call feedkeys(repeat("\b", len(base) + bs) . unicode . vc . s:julia_esc_sequence, 't')
  call feedkeys("\<C-G>u", 'n')
  return ''
endfunction

" Did we activate the Julia as-you-type LaTeX-to-Unicode substitutions?
let b:julia_auto_l2u_set = 0

" Setup the Julia auto as-you-type LaTeX-to-Unicode substitution
function! s:JuliaSetAutoLtoU(wait_vim_enter)
  " g:julia_did_vim_enter is set from an autocommand in ftdetect
  if a:wait_vim_enter && !get(g:, "julia_did_vim_enter", 0)
    return
  endif
  if !get(g:, "julia_auto_latex_to_unicode", 0)
    return
  endif
  " Viable substitutions are searched at every character insertion via the
  " autocmd InsertCharPre. The <Enter> key does not seem to be catched in
  " this way though, so we use a mapping for that case.
  imap <buffer> <CR> <Plug>JuliaAutoLtoU
  inoremap <buffer><expr> <Plug>JuliaAutoLtoU JuliaAutoLaTeXtoUnicode("\n", "\<CR>")

  augroup JuliaAutoLtoU
    autocmd!
    autocmd InsertCharPre <buffer> call JuliaAutoLaTeXtoUnicode()
  augroup END

  let b:julia_auto_l2u_set = 1
endfunction

" Revert the Julia auto LaTeX-to-Unicode settings
function! JuliaUnsetAutoLtoU()
  if !b:julia_auto_l2u_set
    return
  endif
  iunmap <buffer> <CR>
  iunmap <buffer> <Plug>JuliaAutoLtoU
  autocmd! JuliaAutoLtoU
  augroup! JuliaAutoLtoU
  let b:julia_auto_l2u_set = 0
endfunction

if v:version < 704
    let g:julia_latex_to_unicode = 0
    let g:julia_auto_latex_to_unicode = 0
endif

" YouCompleteMe and neocomplcache plug-ins do not work well with LaTeX symbols
" suggestions
if exists("g:loaded_youcompleteme") || exists("g:loaded_neocomplcache")
  let g:julia_latex_suggestions_enabled = 0
endif

" Initialization. Can be used to re-init when global settings have changed.
function! JuliaLaTeXtoUnicodeInit(...)
  let wait_vim_enter = a:0 > 0 ? a:1 : 1
  call JuliaUnsetTab()
  call JuliaUnsetAutoLtoU()

  call s:JuliaSetTab(wait_vim_enter)
  call s:JuliaSetAutoLtoU(wait_vim_enter)
endfunction

" Try to postpone the first initialization as much as possible,
" by calling s:JuliaSetTab amd s:JuliaSetAutoLtoU only at VimEnter or later
autocmd VimEnter *.jl call JuliaLaTeXtoUnicodeInit(0)
call JuliaLaTeXtoUnicodeInit()

""""""""""""""[ End of LaTeX-to-Unicode section ]""""""""""""""


let b:undo_ftplugin = "setlocal include< suffixesadd< comments< commentstring<"
      \ . " define< shiftwidth< expandtab< indentexpr< indentkeys< cinoptions< omnifunc<"
      \ . " | call JuliaUnsetTab() | call JuliaUnsetAutoLtoU()"
      \ . " | delfunction LaTeXtoUnicode_omnifunc | delfunction JuliaLaTeXtoUnicodeInit"
      \ . " | delfunction JuliaTab | delfunction JuliaUnsetTab"
      \ . " | delfunction JuliaAutoLaTeXtoUnicode | delfunction JuliaUnsetAutoLtoU"

" MatchIt plugin support
if exists("loaded_matchit")
  let b:match_ignorecase = 0

  " note: beginKeywords must contain all blocks in order
  " for nested-structures-skipping to work properly
  let s:beginKeywords = '\%(\.\s*\)\@<!\<\%(function\|macro\|begin\|type\|immutable\|let\|do\|\%(bare\)\?module\|quote\|if\|for\|while\|try\)\>'
  let s:endKeyowrds = '\<end\>'

  " note: this function relies heavily on the syntax file
  function! JuliaGetMatchWords()
    let s:attr = synIDattr(synID(line("."),col("."),1),"name")
    if s:attr == 'juliaConditional'
      return s:beginKeywords . ':\<\%(elseif\|else\)\>:' . s:endKeyowrds
    elseif s:attr =~ '\<\%(juliaRepeat\|juliaRepKeyword\)\>'
      return s:beginKeywords . ':\<\%(break\|continue\)\>:' . s:endKeyowrds
    elseif s:attr == 'juliaBlKeyword'
      return s:beginKeywords . ':' . s:endKeyowrds
    elseif s:attr == 'juliaException'
      return s:beginKeywords . ':\<\%(catch\|finally\)\>:' . s:endKeyowrds
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
        \ . " | delfunction JuliaGetMatchWords"
endif

if has("gui_win32")
  let b:browsefilter = "Julia Source Files (*.jl)\t*.jl\n"
  let b:undo_ftplugin = b:undo_ftplugin . " | unlet! b:browsefilter"
endif

let &cpo = s:save_cpo
unlet s:save_cpo
