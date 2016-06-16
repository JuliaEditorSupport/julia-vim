" Vim syntax file
" Language:	julia
" Maintainer:	Carlo Baldassi <carlobaldassi@gmail.com>
" Last Change:	2013 feb 11

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

scriptencoding utf-8

if !exists("b:julia_syntax_version")
  let b:julia_syntax_version = get(g:, "default_julia_version", "current")
endif
if !exists("b:julia_syntax_highlight_deprecated")
  let b:julia_syntax_highlight_deprecated = get(g:, "julia_syntax_highlight_deprecated", 0)
endif

if b:julia_syntax_version =~? '\<\%(curr\%(ent\)\?\|release\|4\|0\.4\)\>'
  let b:julia_syntax_version = 4
elseif b:julia_syntax_version =~? '\<\%(next\|devel\|5\|0\.5\)\>'
  let b:julia_syntax_version = 5
elseif b:julia_syntax_version =~? '\<\%(prev\%(ious\)\?\|legacy\|3\|0\.3\)\>'
  let b:julia_syntax_version = 3
else
  echohl WarningMsg | echomsg "Unrecognized or unsupported julia syntax version: " . b:julia_syntax_version | echohl None
  let b:julia_syntax_version = 4
endif

syn case match

syntax cluster juliaExpressions		contains=@juliaParItems,@juliaStringItems,@juliaKeywordItems,@juliaBlocksItems,@juliaTypesItems,@juliaConstItems,@juliaMacroItems,@juliaOperatorItems,@juliaNumberItems,@juliaQuotedItems,@juliaCommentItems,@juliaErrorItems
syntax cluster juliaExprsPrintf		contains=@juliaExpressions,@juliaPrintfItems

syntax cluster juliaParItems		contains=juliaParBlock,juliaSqBraBlock,juliaCurBraBlock
syntax cluster juliaKeywordItems	contains=juliaKeyword,juliaRepKeyword,juliaTypedef
syntax cluster juliaBlocksItems		contains=juliaConditionalBlock,juliaRepeatBlock,juliaBeginBlock,juliaFunctionBlock,juliaMacroBlock,juliaQuoteBlock,juliaTypeBlock,juliaImmutableBlock,juliaExceptionBlock,juliaLetBlock,juliaDoBlock,juliaModuleBlock
if b:julia_syntax_version == 3
  syntax cluster juliaTypesItems	contains=@juliaTypesItemsAll,@juliaTypesItems03,@juliaTypesItems0304,@juliaTypesItems0305
elseif b:julia_syntax_version == 4
  syntax cluster juliaTypesItems	contains=@juliaTypesItemsAll,@juliaTypesItems03,@juliaTypesItems0304,@juliaTypesItems0305,@juliaTypesItems04,@juliaTypesItems0405
else
  syntax cluster juliaTypesItems	contains=@juliaTypesItemsAll,@juliaTypesItems03,@juliaTypesItems0304,@juliaTypesItems0305,@juliaTypesItems04,@juliaTypesItems0405,@juliaTypesItems05
endif
syntax cluster juliaTypesItemsAll	contains=juliaBaseTypeBasic,juliaBaseTypeNum,juliaBaseTypeC,juliaBaseTypeError,juliaBaseTypeIter,juliaBaseTypeString,juliaBaseTypeArray,juliaBaseTypeDict,juliaBaseTypeSet,juliaBaseTypeIO,juliaBaseTypeProcess,juliaBaseTypeRange,juliaBaseTypeRegex,juliaBaseTypeFact,juliaBaseTypeFact,juliaBaseTypeSort,juliaBaseTypeRound,juliaBaseTypeSpecial,juliaBaseTypeRandom,juliaBaseTypeDisplay,juliaBaseTypeOther
syntax cluster juliaTypesItems03	contains=juliaBaseTypeBasic03,juliaBaseTypeNum03,juliaBaseTypeError03,juliaBaseTypeArray03,juliaBaseTypeIO03,juliaBaseTypeOther03
syntax cluster juliaTypesItems0304	contains=juliaBaseTypeString0304
syntax cluster juliaTypesItems04	contains=juliaBaseTypeString04
syntax cluster juliaTypesItems0405	contains=juliaBaseTypeBasic0405,juliaBaseTypeNum0405,juliaBaseTypeC0405,juliaBaseTypeError0405,juliaBaseTypeIter0405,juliaBaseTypeString0405,juliaBaseTypeArray0405,juliaBaseTypeIO0405,juliaBaseTypeProcess0405,juliaBaseTypeSort0405,juliaBaseTypeRound0405,juliaBaseTypeRandom0405,juliaBaseTypeDisplay0405,juliaBaseTypeTime0405,juliaBaseTypeOther0405
syntax cluster juliaTypesItems05	contains=juliaBaseTypeString05,juliaBaseTypeArray05,juliaBaseTypeOther05,juliaBaseTypeIO05
syntax cluster juliaTypesItems0305	contains=juliaBaseTypeString0305
if b:julia_syntax_version == 3
  syntax cluster juliaConstItems	contains=@juliaConstItemsAll,@juliaConstItems03
elseif b:julia_syntax_version == 4
  syntax cluster juliaConstItems	contains=@juliaConstItemsAll,@juliaConstItems03,@juliaConstItems0405
else
  syntax cluster juliaConstItems	contains=@juliaConstItemsAll,@juliaConstItems03,@juliaConstItems0405,@juliaConstItems05
endif
syntax cluster juliaConstItemsAll	contains=juliaConstNum,juliaConstBool,juliaConstEnv,juliaConstIO,juliaConstMMap,juliaConstC,juliaConstGeneric
syntax cluster juliaConstItems03	contains=juliaConstEnv03,juliaConstMMap03,juliaConstC03
syntax cluster juliaConstItems0405	contains=juliaConstNum0405
syntax cluster juliaConstItems05	contains=juliaConstEnv05
syntax cluster juliaMacroItems		contains=juliaMacro,juliaDollarVar,juliaPrintfMacro
syntax cluster juliaNumberItems		contains=juliaNumbers
syntax cluster juliaStringItems		contains=juliaChar,juliaString,juliabString,juliavString,juliaipString,juliabigString,juliaMIMEString,juliaTriString,juliaShellString,juliaRegEx
syntax cluster juliaPrintfItems		contains=juliaPrintfParBlock,juliaPrintfString
syntax cluster juliaOperatorItems	contains=juliaArithOperator,juliaBitOperator,juliaRedirOperator,juliaBoolOperator,juliaCompOperator,juliaAssignOperator,juliaRangeOperator,juliaTypeOperator,juliaFuncOperator,juliaCTransOperator,juliaVarargOperator,juliaTernaryRegion
syntax cluster juliaQuotedItems		contains=juliaQuotedEnd,juliaQuotedBlockKeyword,juliaQuotedQuestion
syntax cluster juliaCommentItems	contains=juliaCommentL,juliaCommentM
syntax cluster juliaErrorItems		contains=juliaErrorPar,juliaErrorEnd,juliaErrorElse

syntax match   juliaErrorPar		display "[])}]"
syntax match   juliaErrorEnd		display "\<end\>"
syntax match   juliaErrorElse		display "\<\%(else\|elseif\)\>"
syntax match   juliaErrorCatch		display "\<catch\>"
syntax match   juliaErrorSemicol	display contained ";"

syntax match   juliaQuotedEnd		display ":\@<=end\>"
syntax match   juliaRangeEnd		display contained "\<end\>"

if b:julia_syntax_version >= 5
  syntax region  juliaParBlock		matchgroup=juliaParDelim start="(" end=")" contains=@juliaExpressions,juliaComprehensionFor
else
  syntax region  juliaParBlock		matchgroup=juliaParDelim start="(" end=")" contains=@juliaExpressions
endif
syntax region  juliaParBlockInRange	matchgroup=juliaParDelim contained start="(" end=")" contains=@juliaExpressions,juliaParBlockInRange,juliaRangeEnd
syntax region  juliaSqBraBlock		matchgroup=juliaParDelim start="\[" end="\]" contains=@juliaExpressions,juliaParBlockInRange,juliaRangeEnd,juliaComprehensionFor
syntax region  juliaCurBraBlock		matchgroup=juliaParDelim start="{" end="}" contains=@juliaExpressions

syntax match   juliaKeyword		"\<\%(return\|local\|global\|import\%(all\)\?\|export\|using\|const\|in\)\>"
syntax match   juliaRepKeyword		"\<\%(break\|continue\)\>"
syntax region  juliaConditionalBlock	matchgroup=juliaConditional start="\<if\>" end="\<end\>" contains=@juliaExpressions,juliaConditionalEIBlock,juliaConditionalEBlock fold
syntax region  juliaConditionalEIBlock	matchgroup=juliaConditional transparent contained start="\<elseif\>" end="\<\%(end\|else\|elseif\)\>"me=s-1 contains=@juliaExpressions,juliaConditionalEIBlock,juliaConditionalEBlock
syntax region  juliaConditionalEBlock	matchgroup=juliaConditional transparent contained start="\<else\>" end="\<end\>"me=s-1 contains=@juliaExpressions
syntax region  juliaRepeatBlock		matchgroup=juliaRepeat start="\<\%(while\|for\)\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaBeginBlock		matchgroup=juliaBlKeyword start="\<begin\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaFunctionBlock	matchgroup=juliaBlKeyword start="\<\%(staged\)\?function\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaMacroBlock		matchgroup=juliaBlKeyword start="\<macro\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaQuoteBlock		matchgroup=juliaBlKeyword start="\<quote\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaTypeBlock		matchgroup=juliaBlKeyword start="\<type\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaImmutableBlock	matchgroup=juliaBlKeyword start="\<immutable\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaLetBlock		matchgroup=juliaBlKeyword start="\<let\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaDoBlock		matchgroup=juliaBlKeyword start="\<do\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaModuleBlock		matchgroup=juliaBlKeyword start="\%(\.\s*\)\@<!\<\%(bare\)\?module\>" end="\<end\>" contains=@juliaExpressions fold
syntax region  juliaExceptionBlock	matchgroup=juliaException start="\<try\>" end="\<end\>" contains=@juliaExpressions,juliaCatchBlock,juliaFinallyBlock fold
syntax region  juliaCatchBlock		matchgroup=juliaException transparent contained start="\<catch\>" end="\<end\>"me=s-1 contains=@juliaExpressions,juliaFinallyBlock
syntax region  juliaFinallyBlock	matchgroup=juliaException transparent contained start="\<finally\>" end="\<end\>"me=s-1 contains=@juliaExpressions
syntax match   juliaTypedef		"\<\%(abstract\|typealias\|bitstype\)\>"

syntax match   juliaComprehensionFor	contained "\<for\>"

syntax match   juliaBaseTypeBasic	display "\<\%(Tuple\|NTuple\|Symbol\|\%(Intrinsic\)\?Function\|Union\|Type\%(Name\|Constructor\|Var\)\?\|Any\|ANY\|Vararg\|Top\|None\|Nothing\|Ptr\|Void\|Exception\|Module\|Box\|Expr\|LambdaStaticData\|\%(Data\|Union\)Type\|\%(LineNumber\|Label\|Goto\|Quote\|Top\|Symbol\|Getfield\)Node\|WeakRef\|Associative\|Method\(Table\)\?\)\>"
syntax match   juliaBaseTypeBasic03	display "\<\%(Top\|None\|Nothing\)\>"
syntax match   juliaBaseTypeBasic0405	display "\<\%(UnionType\|GetfieldNode\|Nullable\|Pair\|Ref\|Val\)\>"
syntax match   juliaBaseTypeNum		display "\<\%(Int\%(eger\|8\|16\|32\|64\|128\)\?\|Float\%(16\|32\|64\)\|Complex\%(32\|64\|128\)\?\|Bool\|Char\|Number\|Signed\|Unsigned\|Real\|Rational\|BigInt\|BigFloat\|MathConst\)\>"
syntax match   juliaBaseTypeNum03	display "\<\%(Uint\%(\|8\|16\|32\|64\|128\)\|FloatingPoint\|MathConst\)\>"
syntax match   juliaBaseTypeNum0405	display "\<\%(UInt\%(\|8\|16\|32\|64\|128\)\|AbstractFloat\|Irrational\|Enum\)\>"
syntax match   juliaBaseTypeC		display "\<\%(FileOffset\|C\%(u\?\%(char\|short\|int\|long\(long\)\?\)\|float\|double\|\%(ptrdiff\|s\?size\|wchar\|off\)_t\)\)\>"
syntax match   juliaBaseTypeC0405	display "\<C\%(u\?intmax_t\|w\?string\)\>"
syntax match   juliaBaseTypeError	display "\<\%(\%(Bounds\|Divide\|Domain\|\%(Stack\)\?Overflow\|EOF\|Undef\%(Ref\|Var\)\|System\|Type\|Parse\|Argument\|Key\|Load\|Method\|Inexact\)Error\|\%(Interrupt\|Error\|ProcessExited\)Exception\|DimensionMismatch\)\>"
syntax match   juliaBaseTypeError03	display "\<MemoryError\>"
syntax match   juliaBaseTypeError0405	display "\<\%(\%(OutOfMemory\|Init\|Assertion\|Unicode\)Error\|\%(Captured\|Composite\|InvalidState\|Null\|Remote\)Exception\)\>"
syntax match   juliaBaseTypeIter	display "\<\%(EachLine\|Enumerate\|Zip\|Filter\)\>"
syntax match   juliaBaseTypeIter0405	display "\<\%(Cartesian\%(Index\|Range\)\|LinSpace\)\>"
syntax match   juliaBaseTypeString	display "\<\%(DirectIndex\|UTF\%(16\|32\)\|Sub\|Rep\|Rev\|W\)String\>"
syntax match   juliaBaseTypeString0304	display "\<\(ASCII\|UTF8\|Byte\|Rope\)String\>"
syntax match   juliaBaseTypeString0405	display "\<AbstractString\>"
syntax match   juliaBaseTypeString0305	display "\<String\>"
syntax match   juliaBaseTypeArray	display "\<\%(\%(Sub\)\?Array\|\%(Abstract\|Dense\|Strided\)\?\%(Array\|Matrix\|Vec\%(tor\|OrMat\)\)\|SparseMatrixCSC\|\%(AbstractSparse\|Bit\|Shared\)\%(Array\|Vector\|Matrix\)\|\%\(D\|Bid\|\%(Sym\)\?Trid\)iagonal\|Hermitian\|Symmetric\|UniformScaling\)\>"
syntax match   juliaBaseTypeArray03	display "\<\%(\%(Sub\%(Or\)\?\)\?DArray\|Woodbury\|Triangular\)\>"
syntax match   juliaBaseTypeArray0405	display "\<\%(Lower\|Upper\)Triangular\>"
syntax match   juliaBaseTypeArray05	display "\<SparseVector\>"
syntax match   juliaBaseTypeDict	display "\<\%(WeakKey\|ObjectId\)\?Dict\>"
syntax match   juliaBaseTypeSet		display "\<\%(Int\)\?Set\>"
syntax match   juliaBaseTypeIO		display "\<\%(IO\%(Stream\|Buffer\)\?\|RawFD\|StatStruct\|DevNull\|FileMonitor\|PollingFileWatcher\|Timer\)\>"
syntax match   juliaBaseTypeIO03	display "\<\%(CFILE\|Base64Pipe\|UdpSocket\)\>"
syntax match   juliaBaseTypeIO0405	display "\<\%(Base64\%(Decode\|Encode\)Pipe\|\%(UDP\|TCP\)Socket\|\%(Abstract\)\?Channel\|BufferStream\|ReentrantLock\)\>"
syntax match   juliaBaseTypeIO05	display "\<IOContext\>"
syntax match   juliaBaseTypeProcess	display "\<\%(ProcessGroup\|PipeBuffer\|Cmd\)\>"
syntax match   juliaBaseTypeProcess0405	display "\<Pipe\>"
syntax match   juliaBaseTypeRange	display "\<\%(Dims\|Range\%(Index\)\?\|\%(Ordinal\|Step\|Unit\|Float\)Range\|Colon\)\>"
syntax match   juliaBaseTypeRegex	display "\<Regex\%(Match\)\?\>"
syntax match   juliaBaseTypeFact	display "\<Factorization\>"
syntax match   juliaBaseTypeSort	display "\<\%(Insertion\|Quick\|Merge\)Sort\>"
syntax match   juliaBaseTypeSort0405	display "\<PartialQuickSort\>"
syntax match   juliaBaseTypeRound	display "\<Round\%(ingMode\|FromZero\|Down\|Nearest\|ToZero\|Up\)\>"
syntax match   juliaBaseTypeRound0405	display "\<RoundNearest\%(Ties\%(Away\|Up\)\)\>"
syntax match   juliaBaseTypeSpecial	display "\<\%(LocalProcess\|ClusterManager\)\>"
syntax match   juliaBaseTypeRandom	display "\<\%(AbstractRNG\|MersenneTwister\)\>"
syntax match   juliaBaseTypeRandom0405	display "\<RandomDevice\>"
syntax match   juliaBaseTypeDisplay	display "\<\%(\%(Text\)\?Display\|MIME\)\>"
syntax match   juliaBaseTypeDisplay0405	display "\<\%(Text\|HTML\)\>"
syntax match   juliaBaseTypeTime0405	display "\<\%(Date\%(Time\)\?\)\>"
syntax match   juliaBaseTypeOther	display "\<\%(RemoteRef\|Task\|Condition\|VersionNumber\|IPv[46]\)\>"
syntax match   juliaBaseTypeOther03	display "\<TmStruct\>"
syntax match   juliaBaseTypeOther0405	display "\<\%(SerializationState\|WorkerConfig\)\>"
syntax match   juliaBaseTypeOther05	display "\<\%(Future\|RemoteChannel\|IPAddr\|Stack\%(Trace\|Frame\)\|WorkerPool\)\>"

syntax match   juliaConstNum		display "\<\%(NaN\%(16\|32\)\?\|Inf\%(16\|32\)\?\|eu\?\|pi\|π\|eulergamma\|γ\|catalan\|φ\|golden\)\>"
syntax match   juliaConstNum0405	display "\<\%(NaN64\|Inf64\)\>"
syntax match   juliaConstBool		display "\<\%(true\|false\)\>"
syntax match   juliaConstEnv		display "\<\%(ARGS\|ENV\|CPU_CORES\|OS_NAME\|ENDIAN_BOM\|LOAD_PATH\|VERSION\|JULIA_HOME\)\>"
syntax match   juliaConstEnv03		display "\<DL_LOAD_PATH\>"
syntax match   juliaConstEnv05		display "\<PROGRAM_FILE\>"
syntax match   juliaConstIO		display "\<\%(STD\%(OUT\|IN\|ERR\)\)\>"
syntax match   juliaConstMMap03		display "\<\%(MS_\%(A\?SYNC\|INVALIDATE\)\)\>"
syntax match   juliaConstC		display "\<\%(WORD_SIZE\|C_NULL\)\>"
syntax match   juliaConstC03		display "\<RTLD_\%(LOCAL\|GLOBAL\|LAZY\|NOW\|NOLOAD\|NODELETE\|DEEPBIND\|FIRST\)\>"
syntax match   juliaConstGeneric	display "\<\%(nothing\|Main\)\>"

syntax match   juliaMacro		display "@[_[:alpha:]][_[:alnum:]!]*\%(\.[_[:alpha:]][_[:alnum:]!]*\)*"

syntax match   juliaNumbers		display transparent "\<\d\|\.\d\|\<im\>" contains=juliaNumber,juliaFloat,juliaComplexUnit

"decimal number
syntax match   juliaNumber		display contained "\d\%(_\?\d\)*\%(\>\|im\>\|\ze\D\)" contains=juliaComplexUnit
"hex number
syntax match   juliaNumber		display contained "0x\x\%(_\?\x\)*\%(\>\|im\>\|\ze\X\)" contains=juliaComplexUnit
"bin number
syntax match   juliaNumber		display contained "0b[01]\%(_\?[01]\)*\%(\>\|im\>\|\ze[^01]\)" contains=juliaComplexUnit
"oct number
syntax match   juliaNumber		display contained "0o\o\%(_\?\o\)*\%(\>\|im\>\|\ze\O\)" contains=juliaComplexUnit
"floating point number, starting with a dot, optional exponent
syntax match   juliaFloat		display contained "\.\d\%(_\?\d\)*\%([eEf][-+]\?\d\+\)\?\%(\>\|im\>\|\ze\D\)" contains=juliaComplexUnit
"floating point number, with dot, optional exponent
syntax match   juliaFloat		display contained "\d\%(_\?\d\)*\.\%(\d\%(_\?\d\)*\)\?\%([eEf][-+]\?\d\+\)\?\%(\>\|im\>\|\ze\D\)" contains=juliaComplexUnit
"floating point number, without dot, with exponent
syntax match   juliaFloat		display contained "\d\%(_\?\d\)*[eEf][-+]\?\d\+\%(\>\|im\>\|\ze\D\)" contains=juliaComplexUnit

"hex floating point number, starting with a dot
syntax match   juliaFloat		display contained "0x\.\%\(\x\%(_\?\x\)*\)\?[pP][-+]\?\d\+\%(\>\|im\>\|\ze\X\)" contains=juliaComplexUnit
"hex floating point number, starting with a digit
syntax match   juliaFloat		display contained "0x\x\%(_\?\x\)*\%\(\.\%\(\x\%(_\?\x\)*\)\?\)\?[pP][-+]\?\d\+\%(\>\|im\>\|\ze\X\)" contains=juliaComplexUnit

syntax match   juliaComplexUnit		display	contained "\<im\>"

syntax match   juliaArithOperator	"\%(//\|√\|∛\|\.\?\%(//\|\\\|[-+*%/^÷⋅×⊛⊖⊗⊘⊙⊚⊛⫽]\)\)"
syntax match   juliaSetOperator		"[∪∩∈∉∋∌⊆⊈⊊]"
syntax match   juliaCompOperator	"\.\?[<>]"
syntax match   juliaBitOperator		"\%(<<\|>>>\|>>\|&\||\|\~\|\$\)"
syntax match   juliaRedirOperator	"\%(|>\|<|\)"
syntax match   juliaBoolOperator	"\%(&&\|||\|[∧∨!]\)"
syntax match   juliaCompOperator	"\%(\.\?\%([<>!=]=\|[≤≥≠≡≢]\)\|[≈≉]\)"
syntax match   juliaAssignOperator	"\%([$|\&*/\\%+-]\|<<\|>>>\?\)\?="
syntax match   juliaRangeOperator	":"
syntax match   juliaTypeOperator	"[<:]:"
syntax match   juliaFuncOperator	"->"
syntax match   juliaVarargOperator	"\.\{3\}"
syntax region  juliaTernaryRegion	matchgroup=juliaTernaryOperator start="?" skip="::" end=":" contains=@juliaExpressions,juliaErrorSemicol

" TODO: this is very greedy. Improve?
syntax match   juliaDollarVar		contained "[[:alnum:]_]\@<!$[_[:alpha:]][_[:alnum:]!]*"

syntax match   juliaChar		display "'\\\?.'" contains=juliaSpecialChar
syntax match   juliaChar		display "'\\\o\{3\}'" contains=juliaOctalEscapeChar
syntax match   juliaChar		display "'\\x\x\{2\}'" contains=juliaHexEscapeChar
syntax match   juliaChar		display "'\\u\x\{1,4\}'" contains=juliaUniCharSmall
syntax match   juliaChar		display "'\\U\x\{1,8\}'" contains=juliaUniCharLarge

syntax match   juliaCTransOperator	"[])}[:alnum:]_]\@<=\.\?'"

syntax region  juliaString		matchgroup=juliaStringDelim start=+"+ skip=+\%(\\\\\)*\\"+ end=+"+ contains=@juliaStringVars,@juliaSpecialChars
syntax region  juliabString		matchgroup=juliaStringDelim start=+\<b"+ skip=+\%(\\\\\)*\\"+ end=+"+ contains=@juliaSpecialChars
syntax region  juliavString		matchgroup=juliaStringDelim start=+\<v"+ skip=+\%(\\\\\)*\\"+ end=+"+
syntax region  juliaipString		matchgroup=juliaStringDelim start=+\<ip"+ skip=+\%(\\\\\)*\\"+ end=+"+
syntax region  juliabigString		matchgroup=juliaStringDelim start=+\<big"+ skip=+\%(\\\\\)*\\"+ end=+"+
syntax region  juliaMIMEString		matchgroup=juliaStringDelim start=+\<MIME"+ skip=+\%(\\\\\)*\\"+ end=+"+ contains=@juliaSpecialChars

syntax region  juliaTriString		matchgroup=juliaStringDelim start=+"""+ skip=+\%(\\\\\)*\\"+ end=+"""+ contains=@juliaStringVars,@juliaSpecialChars

syntax region  juliaPrintfMacro		transparent start="@s\?printf(" end=")\@<=" contains=juliaMacro,juliaPrintfParBlock
syntax region  juliaPrintfMacro		transparent start="@s\?printf\s\+" end="\n" contains=@juliaExprsPrintf
syntax region  juliaPrintfParBlock	contained matchgroup=juliaParDelim start="(" end=")" contains=@juliaExprsPrintf
syntax region  juliaPrintfString	contained matchgroup=juliaStringDelim start=+"+ skip=+\%(\\\\\)*\\"+ end=+"+ contains=@juliaSpecialChars,@juliaPrintfChars

syntax region  juliaShellString		matchgroup=juliaStringDelim start=+`+ skip=+\%(\\\\\)*\\`+ end=+`+ contains=@juliaStringVars,juliaSpecialChar

syntax cluster juliaStringVars		contains=juliaStringVarsPar,juliaStringVarsSqBra,juliaStringVarsCurBra,juliaStringVarsPla
syntax region  juliaStringVarsPar	contained matchgroup=juliaStringVarDelim start="$(" end=")" contains=@juliaExpressions
syntax region  juliaStringVarsSqBra	contained matchgroup=juliaStringVarDelim start="$\[" end="\]" contains=@juliaExpressions
syntax region  juliaStringVarsCurBra	contained matchgroup=juliaStringVarDelim start="${" end="}" contains=@juliaExpressions
syntax match   juliaStringVarsPla	contained "$[_[:alpha:]][_[:alnum:]]*"

" TODO improve RegEx
syntax region  juliaRegEx		matchgroup=juliaStringDelim start=+\<r"+ skip=+\%(\\\\\)*\\"+ end=+"[imsx]*+

syntax cluster juliaSpecialChars	contains=juliaSpecialChar,juliaOctalEscapeChar,juliaHexEscapeChar,juliaUniCharSmall,juliaUniCharLarge
syntax match   juliaSpecialChar		contained "\\."
syntax match   juliaOctalEscapeChar	contained "\\\o\{3\}"
syntax match   juliaHexEscapeChar	contained "\\x\x\{2\}"
syntax match   juliaUniCharSmall	contained "\\u\x\{1,4\}"
syntax match   juliaUniCharLarge	contained "\\U\x\{1,8\}"

syntax cluster juliaPrintfChars		contains=juliaErrorPrintfFmt,juliaPrintfFmt
syntax match   juliaErrorPrintfFmt	display contained "\\\?%."
syntax match   juliaPrintfFmt		display contained "%\%(\d\+\$\)\=[-+' #0]*\%(\d*\|\*\|\*\d\+\$\)\%(\.\%(\d*\|\*\|\*\d\+\$\)\)\=\%([hlLjqzt]\|ll\|hh\)\=[aAbdiuoxXDOUfFeEgGcCsSpn]"
syntax match   juliaPrintfFmt		display contained "%%"
syntax match   juliaPrintfFmt		display contained "\\%\%(\d\+\$\)\=[-+' #0]*\%(\d*\|\*\|\*\d\+\$\)\%(\.\%(\d*\|\*\|\*\d\+\$\)\)\=\%([hlLjqzt]\|ll\|hh\)\=[aAbdiuoxXDOUfFeEgGcCsSpn]"hs=s+1
syntax match   juliaPrintfFmt		display contained "\\%%"hs=s+1

syntax match   juliaQuotedBlockKeyword	display ":\s*\%(if\|elseif\|else\|while\|for\|begin\|\%(staged\)\?function\|macro\|quote\|type\|immutable\|try\|catch\|let\|\%(bare\)\?module\|do\)\>"he=s+1 contains=juliaInQuote
syntax match   juliaQuotedQuestion      display ":\s*\%(?\|(\s*?\s*)\)"he=s+1 contains=juliaInQuote
syntax match   juliaInQuote             display contained ":\zs\s*[^])}[:space:],;]\+"

syntax region  juliaCommentL		matchgroup=juliaCommentDelim start="#\ze\%([^=]\|$\)" end="$" keepend contains=juliaTodo,@spell
syntax region  juliaCommentM		matchgroup=juliaCommentDelim start="#=\ze\%([^#]\|$\)" end="=#" contains=juliaTodo,juliaCommentM,@spell
syntax keyword juliaTodo		contained TODO FIXME XXX


hi def link juliaParDelim		juliaNone

hi def link juliaKeyword		Keyword
hi def link juliaRepKeyword		Keyword
hi def link juliaBlKeyword		Keyword
hi def link juliaConditional		Conditional
hi def link juliaRepeat			Repeat
hi def link juliaException		Exception
hi def link juliaTypedef		Typedef
hi def link juliaBaseTypeBasic		Type
hi def link juliaBaseTypeNum		Type
hi def link juliaBaseTypeC		Type
hi def link juliaBaseTypeError		Type
hi def link juliaBaseTypeIter		Type
hi def link juliaBaseTypeString		Type
hi def link juliaBaseTypeArray		Type
hi def link juliaBaseTypeDict		Type
hi def link juliaBaseTypeSet		Type
hi def link juliaBaseTypeIO		Type
hi def link juliaBaseTypeProcess	Type
hi def link juliaBaseTypeRange		Type
hi def link juliaBaseTypeRegex		Type
hi def link juliaBaseTypeFact		Type
hi def link juliaBaseTypeSort		Type
hi def link juliaBaseTypeRound		Type
hi def link juliaBaseTypeSpecial	Type
hi def link juliaBaseTypeRandom		Type
hi def link juliaBaseTypeDisplay	Type
hi def link juliaBaseTypeOther		Type
for t in ["Array","Other","IO"]
  let h = b:julia_syntax_version >= 5 ? "Type" : "NONE"
  exec "hi! def link juliaBaseType" . t . "05 	" . h
endfor
for t in ["String"]
  let h = b:julia_syntax_version == 4 ? "juliaDeprecated" : "Type"
  exec "hi! def link juliaBaseType" . t . "0305 	" . h
endfor
for t in ["Basic","Num","C","Error","Iter","String","Array","IO","Process","Sort","Round","Random","Display","Time","Other"]
  let h = b:julia_syntax_version >= 4 ? "Type" : "NONE"
  exec "hi! def link juliaBaseType" . t . "0405	" . h
endfor
for t in ["String"]
  let h = b:julia_syntax_version > 4 ? "juliaDeprecated" : b:julia_syntax_version == 4 ? "Type" : "NONE"
  exec "hi! def link juliaBaseType" . t . "04 " . h
endfor
for t in ["String"]
  let h = b:julia_syntax_version > 4 ? "juliaDeprecated" : "Type"
  exec "hi! def link juliaBaseType" . t . "0304 " . h
endfor
for t in ["Basic","Num","Error","Array","IO","Other"]
  let h = b:julia_syntax_version > 3 ? "juliaDeprecated" : "Type"
  exec "hi! def link juliaBaseType" . t . "03 	" . h
endfor

hi def link juliaConstNum		Constant
hi def link juliaConstEnv		Constant
hi def link juliaConstIO		Constant
hi def link juliaConstC 		Constant
hi def link juliaConstLimits		Constant
hi def link juliaConstGeneric		Constant
hi def link juliaRangeEnd		Constant
hi def link juliaConstBool		Boolean
for t in ["Env"]
  let h = b:julia_syntax_version >= 5 ? "Constant" : "NONE"
  exec "hi! def link juliaConst" . t . "05	" . h
endfor
for t in ["Num"]
  let h = b:julia_syntax_version >= 4 ? "Constant" : "NONE"
  exec "hi! def link juliaConst" . t . "0405	" . h
endfor
for t in ["Env","MMap","C"]
  let h = b:julia_syntax_version >= 4 ? "juliaDeprecated" : "Constant"
  exec "hi! def link juliaConst" . t . "03	" . h
endfor

hi def link juliaComprehensionFor	Keyword

hi def link juliaDollarVar		Identifier

hi def link juliaMacro			Macro

hi def link juliaNumber			Number
hi def link juliaFloat			Float
hi def link juliaComplexUnit		Constant

hi def link juliaChar			Character

hi def link juliaString			String
hi def link juliabString		String
hi def link juliavString		String
hi def link juliarString		String
hi def link juliaipString		String
hi def link juliabigString		String
hi def link juliaMIMEString		String
hi def link juliaTriString		String
hi def link juliaPrintfString		String
hi def link juliaShellString		String
hi def link juliaStringDelim		String
hi def link juliaStringVarsPla		Identifier
hi def link juliaStringVarDelim		Identifier

hi def link juliaRegEx			String

hi def link juliaSpecialChar		SpecialChar
hi def link juliaOctalEscapeChar	SpecialChar
hi def link juliaHexEscapeChar		SpecialChar
hi def link juliaUniCharSmall		SpecialChar
hi def link juliaUniCharLarge		SpecialChar

hi def link juliaPrintfFmt		SpecialChar

if exists("g:julia_highlight_operators")
  hi! def link juliaOperator		Operator
else
  hi! def link juliaOperator		juliaNone
endif
hi def link juliaArithOperator		juliaOperator
hi def link juliaSetOperator		juliaOperator
hi def link juliaBitOperator		juliaOperator
hi def link juliaRedirOperator		juliaOperator
hi def link juliaBoolOperator		juliaOperator
hi def link juliaCompOperator		juliaOperator
hi def link juliaAssignOperator		juliaOperator
hi def link juliaRangeOperator		juliaOperator
hi def link juliaTypeOperator		juliaOperator
hi def link juliaFuncOperator		juliaOperator
hi def link juliaCTransOperator		juliaOperator
hi def link juliaVarargOperator		juliaOperator
hi def link juliaTernaryOperator	juliaOperator

"hi def link juliaQuotedEnd              juliaOperator
hi def link juliaQuotedBlockKeyword	juliaOperator
hi def link juliaQuotedQuestion 	juliaOperator

hi def link juliaCommentL		Comment
hi def link juliaCommentM		Comment
hi def link juliaCommentDelim		Comment
hi def link juliaTodo			Todo

hi def link juliaErrorPar		juliaError
hi def link juliaErrorEnd		juliaError
hi def link juliaErrorElse		juliaError
hi def link juliaErrorCatch		juliaError
hi def link juliaErrorSemicol		juliaError
hi def link juliaErrorPrintfFmt		juliaError

hi def link juliaError			Error

if b:julia_syntax_highlight_deprecated == 1
  hi! def link juliaDeprecated		Todo
else
  hi! def link juliaDeprecated          NONE
end

syntax sync fromstart

let b:current_syntax = "julia"
