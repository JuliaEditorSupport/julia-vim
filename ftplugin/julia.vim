" Vim filetype plugin file
" Language:	Julia
" Maintainer:	Carlo Baldassi <carlobaldassi@gmail.com>
" Last Change:	2011 dec 11

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

" Support for LaTex-to-Unicode conversion as in the Julia REPL

" (The dictionary was generated from within Julia with the following line:
"    println("let g:latex_symbols = {", join([string("'", latex, "': '", unicode, "'") for (latex,unicode) in Base.REPLCompletions.latex_symbols], ','), "}")
" )
let g:latex_symbols = {'\guilsinglright': '›','\blacktriangleright': '▸','\Re': 'ℜ','\pitchfork': '⋔','\Elzinglst': 'ʖ','\urcorner': '⌝','\pi': 'π','\nless': '≮','\sqsubseteq': '⊑','\Updownarrow': '⇕','\nrightarrow': '↛','\Theta': 'Θ','\rightmoon': '☾','\upsilon': 'υ','\copyright': '©','\smile': '⌣','\backsimeq': '⋍','\BbbPi': 'ℿ','\lq': '‘','\perp': '⊥','\textnrleg': 'ƞ','\llcorner': '⌞','\bigtimes': '⨉','\circleddash': '⊝','\leftharpoondown': '↽','\alpha': 'α','\between': '≬','\frown': '⌢','\RoundImplies': '⥰','\precneqq': '⪵','\nsupseteq': '⊉','\iota': 'ι','\overbrace': '︷','\rightharpoondown': '⇁','\tilde': '̃','\rightleftarrows': '⇄','\succapprox': '⪸','\Rsh': '↱','\fdiagovnearrow': '⤯','\original': '⊶','\nBumpeq': '≎̸','\nleftrightarrow': '↮','\clockoint': '⨏','\Im': 'ℑ','\Elzrarrx': '⥇','\leo': '♌','\DownArrowBar': '⤓','\surd': '√','\ge': '≥','\amalg': '⨿','\ElOr': '⩖','\uparrow': '↑','\Game': '⅁','\sterling': '£','\NestedGreaterGreater': '⪢','\bumpeqq': '⪮','\nVDash': '⊯','\leftarrowtriangle': '⇽','\lnsim': '⋦','\yen': '¥','\theta': 'θ','\gnapprox': '⪊','\male': '♂','\LeftUpVectorBar': '⥘','\NotLeftTriangleBar': '⧏̸','\nRightarrow': '⇏','\Elzsqspne': '⋥','\forks': '⫝̸','\Alpha': 'Α','\backepsilon': '϶','\psi': 'ψ','\ng': 'ŋ','\Sampi': 'Ϡ','\textperthousand': '‰','\l': 'ł','\star': '⋆','\Elzbtdl': 'ɬ','\Downarrow': '⇓','\lvertneqq': '≨︀','\S': '§','\NotLessLess': '≪̸','\omega': 'ω','\NotSquareSubset': '⊏̸','\boxcircle': '⧇','\Bumpeq': '≎','\gtreqless': '⋛','\daleth': 'ℸ','\recorder': '⌕','\Elroang': '⦆','\forksnot': '⫝','\Angle': '⦜','\shuffle': '⧢','\ReverseUpEquilibrium': '⥯','\Elzxrat': '℞','\Elztesh': 'ʧ','\Elzsbrhr': '˒','\rightleftharpoons': '⇌','\Elzrtln': 'ɳ','\checkmark': '✓','\Elzsqfnw': '┙','\Elzxh': 'ħ','\nsubseteqq': '⫅̸','\mars': '♂','\ngtr': '≯','\hksearow': '⤥','\lesssim': '≲','\obar': '⌽','\Colon': '∷','\sagittarius': '♐','\dot': '̇','\Omega': 'Ω','\looparrowright': '↬','\Vert': '‖','\fdiagovrdiag': '⤬','\ngeqslant': '⩾̸','\perspcorrespond': '⩞','\twoheadrightarrow': '↠','\beta': 'β','\c': '̧','\Elzrtlr': 'ɽ','\approxnotequal': '≆','\sqrt': '√','\plusdot': '⨥','\bigodot': '⨀','\subsetneqq': '⫋','\neg': '¬','\Elzreglst': 'ʕ','\barwedge': '⌅','\Elzrvbull': '◘','\Rightarrow': '⇒','\textasciicaron': 'ˇ','\Cap': '⋒','\aleph': 'ℵ','\xi': 'ξ','\lessapprox': '⪅','\ddddot': '⃜','\longrightarrow': '⟶','\Elzrais': '˔','\lmoustache': '⎰','\pm': '±','\prec': '≺','\disjquant': '⨈','\DH': 'Ð','\openbracketright': '〛','\Elzsqfr': '◨','\downharpoonleft': '⇃','\phi': 'ϕ','\lozenge': '◊','\L': 'Ł','\ni': '∋','\subseteqq': '⫅','\texttildelow': '˜','\heartsuit': '♡','\Elztrnsa': 'ɒ','\subset': '⊂','\venus': '♀','\thinspace': ' ','\fallingdotseq': '≒','\partialmeetcontraction': '⪣','\NotNestedLessLess': '⪡̸','\approx': '≈','\gtrless': '≷','\ntriangleleft': '⋪','\partial': '∂','\pluto': '♇','\kappa': 'κ','\textTheta': 'ϴ','\Vvdash': '⊪','\hspace': ' ','\leqslant': '⩽','\questeq': '≟','\wp': '℘','\gamma': 'γ','\NotGreaterGreater': '≫̸','\Doteq': '≑','\Elzlmrk': 'ː','\Elzdlcorn': '⎣','\nsubset': '⊄','\Equal': '⩵','\bkarow': '⤍','\intcup': '⨚','\P': '¶','\lneq': '⪇','\napprox': '≉','\Elztrnm': 'ɯ','\bigstar': '★','\lesseqgtr': '⋚','\ngeq': '≱','\varnothing': '∅','\supseteq': '⊇','\eta': 'η','\varrho': 'ϱ','\neptune': '♆','\Vdash': '⊩','\dots': '…','\longleftrightarrow': '⟷','\gemini': '♊','\nsupset': '⊅','\supsetneqq': '⫌','\bigtriangleup': '△','\diagup': '╱','\nexists': '∄','\image': '⊷','\underbrace': '︸','\boxplus': '⊞','\Zeta': 'Ζ','\texthvlig': 'ƕ','\OE': 'Œ','\circledcirc': '⊚','\capricornus': '♑','\towa': '⤪','\in': '∈','\chi': 'χ','\imath': 'ı','\Elzcirfl': '◐','\Elzrttrnr': 'ɻ','\Xi': 'Ξ','\RightUpVectorBar': '⥔','\veebar': '⊻','\nsuccsim': '≿̸','\verymuchless': '⋘','\textphi': 'ɸ','\Elztrnt': 'ʇ','\triangleq': '≜','\Beta': 'Β','\ast': '∗','\bigsqcup': '⨆','\Elzbar': '̶','\nequiv': '≢','\ncong': '≇','\Elzrtls': 'ʂ','\dddot': '⃛','\dotminus': '∸','\oint': '∮','\circlearrowleft': '↺','\diamondsuit': '♢','\nLeftarrow': '⇍','\Elzpscrv': 'ʋ','\Elzltlmr': 'ɱ','\acute': '́','\Elzddfnc': '⦙','\bigtriangledown': '▽','\Longleftarrow': '⟸','\nsucc': '⊁','\square': '□','\succ': '≻','\neovnwarrow': '⤱','\Elzfhr': 'ɾ','\langle': '〈','\DownRightVectorBar': '⥗','\clubsuit': '♣','\Stigma': 'Ϛ','\rightangle': '∟','\backsim': '∽','\Elzsblhr': '˓','\downdownarrows': '⇊','\lowint': '⨜','\Elzminhat': '⩟','\varphi': 'φ','\blacklozenge': '⧫','\Tau': 'Τ','\looparrowleft': '↫','\beth': 'ℶ','\nsim': '≁','\ocirc': '̊','\div': '÷','\Elztrnmlr': 'ɰ','\bigcupdot': '⨃','\bbsum': '⅀','\iiint': '∭','\cancer': '♋','\sqcup': '⊔','\Longrightarrow': '⟹','\subsetneq': '⊊','\dagger': '†','\textdoublepipe': 'ǂ','\textquotedblright': '”','\notlessgreater': '≸','\rightrightarrows': '⇉','\DownRightTeeVector': '⥟','\textturnk': 'ʞ','\allequal': '≌','\female': '♀','\cdotp': '·','\Elzcirfb': '◒','\ntrianglerighteq': '⋭','\ElzTimes': '⨯','\blacktriangle': '▴','\saturn': '♄','\DownLeftRightVector': '⥐','\Elzverti': 'ˌ','\curlyeqsucc': '⋟','\DownLeftTeeVector': '⥞','\Elzpes': '₧','\rdiagovfdiag': '⤫','\Elzxl': '̵','\mapsto': '↦','\maltese': '✠','\hslash': 'ℏ','\blacksquare': '■','\upuparrows': '⇈','\taurus': '♉','\vDash': '⊨','\conjquant': '⨇','\sim': '∼','\RuleDelayed': '⧴','\sum': '∑','\aquarius': '♒','\ggg': '⋙','\uranus': '♅','\rightthreetimes': '⋌','\ElzrLarr': '⥄','\O': 'Ø','\nbumpeq': '≏̸','\dashv': '⊣','\curlywedge': '⋏','\gg': '≫','\sqsupset': '⊐','\nprec': '⊀','\diamond': '⋄','\leftrightarrows': '⇆','\LeftUpTeeVector': '⥠','\eighthnote': '♪','\risingdotseq': '≓','\RightUpTeeVector': '⥜','\textonequarter': '¼','\iint': '∬','\nleqslant': '⩽̸','\textexclamdown': '¡','\nprecsim': '≾̸','\btimes': '⨲','\oe': 'œ','\forall': '∀','\textthreequarters': '¾','\Elztrna': 'ɐ','\rightarrowtriangle': '⇾','\supset': '⊃','\equiv': '≡','\sharp': '♯','\epsilon': 'ϵ','\ae': 'æ','\infty': '∞','\dualmap': '⧟','\bigotimes': '⨂','\eqslantgtr': '⪖','\lrcorner': '⌟','\nwarrow': '↖','\leqq': '≦','\lfloor': '⌊','\Elzdshfnc': '┆','\rightsquigarrow': '↝','\leftarrow': '←','\sphericalangle': '∢','\boxtimes': '⊠','\hkswarow': '⤦','\ElzOr': '⩔','\interleave': '⫴','\complement': '∁','\Ddownarrow': '⤋','\neqsim': '≂̸','\Koppa': 'Ϟ','\angle': '∠','\Eta': 'Η','\ll': '≪','\vartriangle': '▵','\Leftarrow': '⇐','\asymp': '≍','\times': '×','\wr': '≀','\twoheadrightarrowtail': '⤖','\ddotseq': '⩷','\ss': 'ß','\intcap': '⨙','\openbracketleft': '〚','\triangleleft': '◃','\nvdash': '⊬','\oiiint': '∰','\precnsim': '⋨','\UpEquilibrium': '⥮','\Elztrnrl': 'ɺ','\aries': '♈','\intercal': '⊺','\ntrianglelefteq': '⋬','\bigvee': '⋁','\minus': '−','\nleftarrow': '↚','\mho': '℧','\bigwedge': '⋀','\Elzdyogh': 'ʤ','\curlyvee': '⋎','\eth': 'ð','\lesseqqgtr': '⪋','\scorpio': '♏','\Elzrh': '̢','\upharpoonright': '↿','\lessdot': '⋖','\textordfeminine': 'ª','\coprod': '∐','\aa': 'å','\dblarrowupdown': '⇅','\cupdot': '⊍','\Lsh': '↰','\Elzcirfr': '◑','\Elzrtlt': 'ʈ','\trianglelefteq': '⊴','\degree': '°','\ddot': '̈','\ddagger': '‡','\bigcap': '⋂','\Elzpbgam': 'ɤ','\circeq': '≗','\Phi': 'Φ','\guilsinglleft': '‹','\AE': 'Æ','\check': '̌','\intx': '⨘','\Upsilon': 'Υ','\Elzinvw': 'ʍ','\LeftUpDownVector': '⥑','\Elzinvv': 'ʌ','\Dashv': '⫤','\Elzdefas': '⧋','\ltimes': '⋉','\leftrightarrow': '↔','\Mapsto': '⤇','\mid': '∣','\hookleftarrow': '↩','\LeftTriangleBar': '⧏','\swarrow': '↙','\textvisiblespace': '␣','\bar': '̄','\natural': '♮','\mp': '∓','\subseteq': '⊆','\NG': 'Ŋ','\LeftRightVector': '⥎','\gtreqqless': '⪌','\Longleftrightarrow': '⟺','\vdots': '⋮','\Elzltln': 'ɲ','\gimel': 'ℷ','\iiiint': '⨌','\TH': 'Þ','\clwintegral': '∱','\Lleftarrow': '⇚','\hat': '̂','\nearrow': '↗','\vartheta': 'ϑ','\Iota': 'Ι','\th': 'þ','\Elzvrecto': '▯','\kernelcontraction': '∻','\ntriangleright': '⋫','\breve': '̆','\succeq': '⪰','\enspace': ' ','\nwovnearrow': '⤲','\bigcirc': '○','\sigma': 'σ','\leftharpoonup': '↼','\textasciiacute': '´','\int': '∫','\curlyeqprec': '⋞','\Elztdcol': '⫶','\neovsearrow': '⤮','\Leftrightarrow': '⇔','\lceil': '⌈','\UpArrowBar': '⤒','\ne': '≠','\varsubsetneqq': '⊊︀','\bullet': '•','\boxbslash': '⧅','\precnapprox': '⪹','\precapprox': '⪷','\curvearrowright': '↷','\top': '⊤','\Elztrny': 'ʎ','\Elztrnr': 'ɹ','\blacktriangledown': '▾','\Elzhlmrk': 'ˑ','\rasp': 'ʼ','\downharpoonright': '⇂','\sqsubset': '⊏','\succsim': '≿','\dashV': '⫣','\Elzopeno': 'ɔ','\emdash': '—','\delta': 'δ','\rfloor': '⌋','\eqslantless': '⪕','\Elzverts': 'ˈ','\eqcolon': '≕','\nsubseteq': '⊈','\wedge': '∧','\cdots': '⋯','\spadesuit': '♠','\tildetrpl': '≋','\leftrightsquigarrow': '↭','\dbkarow': '⤏','\Sigma': 'Σ','\longmapsto': '⟼','\DownArrowUpArrow': '⇵','\intbar': '⨍','\npreceq': '⪯̸','\virgo': '♍','\boxast': '⧆','\Elzsbbrg': '̪','\drbkarrow': '⤐','\ell': 'ℓ','\tau': 'τ','\Vvert': '⦀','\circledS': 'Ⓢ','\boxdot': '⊡','\twoheadleftarrow': '↞','\textpertenthousand': '‱','\Uparrow': '⇑','\LeftVectorBar': '⥒','\textasciimacron': '¯','\nolinebreak': '⁠','\rangle': '〉','\libra': '♎','\Lambda': 'Λ','\sqsupseteq': '⊒','\odot': '⊙','\supseteqq': '⫆','\boxminus': '⊟','\textasciidieresis': '¨','\k': '̨','\textnumero': '№','\Pi': 'Π','\nparallel': '∦','\Elzpalh': '̡','\Elzsqfse': '◪','\gtrapprox': '⪆','\lessgtr': '≶','\Elzrl': 'ɼ','\coloneq': '≔','\pisces': '♓','\Elzreapos': '‛','\Elzsqfl': '◧','\eqcirc': '≖','\quarternote': '♩','\RightVectorBar': '⥓','\texttrademark': '™','\upharpoonleft': '↾','\wedgeq': '≙','\hookrightarrow': '↪','\supsetneq': '⊋','\succneqq': '⪶','\Elztrnh': 'ɥ','\precsim': '≾','\preceq': '⪯','\Gamma': 'Γ','\tosa': '⤩','\notin': '∉','\circ': '∘','\prime': '′','\cdot': '⋅','\uplus': '⊎','\rtimes': '⋊','\Elzesh': 'ʃ','\nmid': '∤','\DJ': 'Đ','\ElzAnd': '⩓','\DownLeftVectorBar': '⥖','\Supset': '⋑','\RightUpDownVector': '⥏','\Elzpupsil': 'ʊ','\varpi': 'ϖ','\circledast': '⊛','\cap': '∩','\Kappa': 'Κ','\vdash': '⊢','\because': '∵','\biguplus': '⨄','\textbrokenbar': '¦','\eqsim': '≂','\Elzclomeg': 'ɷ','\tona': '⤧','\setminus': '∖','\therefore': '∴','\leftarrowtail': '↢','\rightanglearc': '⊾','\measuredangle': '∡','\LeftTeeVector': '⥚','\longleftarrow': '⟵','\dj': 'đ','\intprod': '⨼','\notgreaterless': '≹','\ElzLap': '⧊','\gtrsim': '≳','\adots': '⋰','\rho': 'ρ','\leftthreetimes': '⋋','\jupiter': '♃','\bumpeq': '≏','\oiint': '∯','\Elzpgamma': 'ɣ','\dotplus': '∔','\searrow': '↘','\Elzlow': '˕','\VDash': '⊫','\boxdiag': '⧄','\varsigma': 'ς','\sqrint': '⨖','\nu': 'ν','\textquotedblleft': '“','\leftrightharpoons': '⇋','\preccurlyeq': '≼','\ddots': '⋱','\flat': '♭','\otimes': '⊗','\Elzrtll': 'ɭ','\lnapprox': '⪉','\vartriangleleft': '⊲','\NotSquareSuperset': '⊐̸','\Psi': 'Ψ','\RightDownVectorBar': '⥕','\ominus': '⊖','\grave': '̀','\bowtie': '⋈','\prod': '∏','\succcurlyeq': '≽','\geqslant': '⩾','\LeftDownVectorBar': '⥙','\bigoplus': '⨁','\nsucceq': '⪰̸','\obslash': '⦸','\H': '̋','\digamma': 'ϝ','\vartriangleright': '⊳','\nsupseteqq': '⫆̸','\Elzglst': 'ʔ','\NestedLessLess': '⪡','\o': 'ø','\divideontimes': '⋇','\triangleright': '▹','\NotNestedGreaterGreater': '⪢̸','\diagdown': '╲','\doteq': '≐','\upint': '⨛','\bigcup': '⋃','\simeq': '≃','\gvertneqq': '≩︀','\rightarrowtail': '↣','\multimap': '⊸','\Delta': 'Δ','\Elzyogh': 'ʒ','\Rho': 'Ρ','\backprime': '‵','\lambda': 'λ','\LeftDownTeeVector': '⥡','\starequal': '≛','\triangledown': '▿','\circlearrowright': '↻','\textquestiondown': '¿','\blacktriangleleft': '◂','\succnsim': '⋩','\cong': '≅','\varsupsetneq': '⊋︀','\quad': ' ','\bigsqcap': '⨅','\lazysinv': '∾','\RightTriangleBar': '⧐','\Subset': '⋐','\sqcap': '⊓','\succnapprox': '⪺','\nleq': '≰','\Elzlpargt': '⦠','\vee': '∨','\approxeq': '≊','\Elzschwa': 'ə','\RightTeeVector': '⥛','\rightharpoonup': '⇀','\hermitconjmatrix': '⊹','\textordmasculine': 'º','\rightarrow': '→','\geqq': '≧','\Mapsfrom': '⤆','\rmoustache': '⎱','\u': '˘','\intBar': '⨎','\Epsilon': 'Ε','\RightDownTeeVector': '⥝','\mu': 'μ','\zeta': 'ζ','\gneq': '⪈','\curvearrowleft': '↶','\mercury': '☿','\le': '≤','\ulcorner': '⌜','\varepsilon': 'ɛ','\Elzrtld': 'ɖ','\intprodr': '⨽','\downarrow': '↓','\minusdot': '⨪','\gtrdot': '⋗','\circledR': '®','\nVdash': '⊮','\nsime': '≄','\parallel': '∥','\NotRightTriangleBar': '⧐̸','\Digamma': 'Ϝ','\leftleftarrows': '⇇','\nvDash': '⊭','\Rrightarrow': '⇛','\toea': '⤨','\seovnearrow': '⤭','\gneqq': '≩','\textonehalf': '½','\ElzRlarr': '⥂','\Elzrtlz': 'ʐ','\oplus': '⊕','\rceil': '⌉','\updownarrow': '↕','\cup': '∪','\rdiagovsearrow': '⤰','\varkappa': 'ϰ','\cbrt': '∛','\trianglerighteq': '⊵','\AA': 'Å','\exists': '∃','\Uuparrow': '⤊','\thickspace': ' ','\endash': '–','\oslash': '⊘','\gnsim': '⋧','\Chi': 'Χ','\nabla': '∇','\models': '⊧','\lneqq': '≨','\Cup': '⋓','\propto': '∝','\rq': '’','\mlcp': '⫛','\leftsquigarrow': '↜'}

function! LaTeXtoUnicode_omnifunc(findstart, base)
    if a:findstart
        let cnum = col('.')
        let l = getline('.')
        let i = match(l[0:cnum-2], '\\[A-Za-z]\+$')
        if i == -1
            let i = -3
        endif
        return i
    else
        if has_key(g:latex_symbols, a:base)
            return [g:latex_symbols[a:base]]
        else
            return []
        end
    endif
endfunction

set omnifunc=LaTeXtoUnicode_omnifunc

let s:JuliaFallbackTabTrigger = "\u0091JuliaFallbackTab"

function! s:JuliaSetFallbackTab(s, k)
    let mmdict = maparg(a:s, 'i', 0, 1)
    if empty(mmdict)
        exe 'inoremap <buffer> ' . a:k . ' <Tab>'
        return
    endif
    let rhs = mmdict["rhs"]
    if rhs == '<Plug>JuliaTab'
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

function! JuliaTab()
    let l = getline('.')
    let cnum = col('.')
    let i = LaTeXtoUnicode_omnifunc(1, '')
    if i >= 0
        let base = l[i : cnum-2]
        let uni = LaTeXtoUnicode_omnifunc(0, base)
        if empty(uni)
            let i = -3
        else
            let b = ''
            for j in range(len(base))
                let b = b . "\b"
            endfor
            return b . uni[0]
        endif
    endif
    if i < 0
        return s:JuliaFallbackTabTrigger
    endif
endfunction

function! s:JuliaSetTab(wait_vim_enter)
    if a:wait_vim_enter && !exists("g:jl_did_vim_enter")
        return
    endif
    let g:jl_did_vim_enter = 1
    call s:JuliaSetFallbackTab('<Tab>', s:JuliaFallbackTabTrigger)
    imap <buffer> <Tab> <Plug>JuliaTab
    imap <buffer><expr> <Plug>JuliaTab JuliaTab()
endfunction

function! JuliaUnsetTab()
    iunmap <buffer> <Tab>
    if empty(maparg("<Tab>", "i"))
        call s:JuliaSetFallbackTab(s:JuliaFallbackTabTrigger, '<Tab>')
    endif
    iunmap <buffer> <Plug>JuliaTab
    exe 'iunmap <buffer> ' . s:JuliaFallbackTabTrigger
endfunction

" try to postpone the first initialization as much as possible,
" by calling s:JuliaSetTab only at VimEnter or later
call s:JuliaSetTab(1)
autocmd VimEnter *.jl call s:JuliaSetTab(0)

let b:undo_ftplugin = "setlocal include< suffixesadd< comments< commentstring<"
	\ . " define< shiftwidth< expandtab< indentexpr< indentkeys< cinoptions< omnifunc<"
        \ . " | call JuliaUnsetTab()"
        \ . " | delfunction LaTeXtoUnicode_omnifunc | delfunction JuliaTab | delfunction JuliaUnsetTab"

if exists("loaded_matchit")
	let b:match_ignorecase = 0

	" note: beginKeywords must contain all blocks in order
	" for nested-structures-skipping to work properly
	let s:beginKeywords = '\<\%(function\|macro\|begin\|type\|immutable\|let\|do\|\%(bare\)\?module\|quote\|if\|for\|while\|try\)\>'
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
		\ . '"\\<julia\\%(ComprehensionFor\\|RangeEnd\\|QuotedBlockKeyword\\|InQuote\\|Comment[LM]\\|\\%(\\|[EILbB]\\|Shell\\)String\\|RegEx\\)\\>"'

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
