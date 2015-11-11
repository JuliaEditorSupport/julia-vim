## How to install

### Using [pathogen]

``` bash
cd ~/.vim
mkdir -p bundle && cd bundle
git clone git://github.com/JuliaLang/julia-vim.git
```

### Using [vundle]

Add a new plugin line to your `.vimrc`:

``` vim
Plugin 'JuliaLang/julia-vim'
```

Run `vim` and update your bundles:

``` vim
:PluginInstall!
```

[pathogen]: https://github.com/tpope/vim-pathogen
[vundle]: https://github.com/gmarik/vundle

### Manually

Copy (or symlink) the contents of this repository into the vim application support directory:

``` bash
git clone git://github.com/JuliaLang/julia-vim.git
cd julia-vim
mkdir -p ~/.vim
cp -R * ~/.vim
```

Julia should appear as a file type and be automatically detected for files with the `.jl` extension.

## Complete documentation

The full documentation is available from Vim. Vundle and other plugin managers will generate the required
help tags automatically, so that you just need to type `:help julia-vim`. Otherwise use `:help helptags`
in ViM and see how to generate them.

The remainder of this README will only give an overview of some of the features.

## LaTeX-to-Unicode substitutions

This plug-in adds some functionality to substitute LaTeX code sequences (e.g. `\alpha`) with corresponding
Unicode symbols (e.g. `α`). By default, these substitutions must be triggered explicitly by pressing the
`<Tab>` key, as in the Julia command line (the REPL); however, an automatic, as-you-type mode can also
be activated.

On the Vim command line, the feature is activated by pressing `Shift-Tab`. This is mostly useful
when searching the files with the `/` or `?` commands.

By default, this feature is only active when editing Julia files. However, it can be also enabled with
other file types, and even turned on/off on the fly regardless of the file type.

These features only work as described with Vim version 7.4 or higher. Tab completion can still be made
available on lower Vim versions, see below for more details.

The following sections provide details on these features. The complete documentation is provided by calling
`:help julia-vim` from within Vim. A complete reference table of the available substitution can be
accessed by calling `:help L2U-ref` from within Vim.

### LaTeX-to-Unicode via Tab key

This plug-in adds a mapping to the `<Tab>` key which makes it behave like the Julia REPL, i.e. when
the cursor is at the end of a recognized LaTeX symbol (e.g. `\alpha`) in insert mode, pressing
the `<Tab>` key will substitute it with the corresponding Unicode symbol (e.g. `α`). If a partial match
is found (e.g. `\al`), a list of possible completions is suggested (e.g. `\aleph`, `\allequal`,
`\alpha`), and it will be refined while you enter more characters; when only one match is left, pressing
`<Tab>` will complete it and pressing it again will perform the substitution to Unicode.

If no suitable substitution is found, the action will fall back to whatever mapping was previously
defined: by default, inserting a literal `<Tab>` character, or invoking some other action if another
plug-in is installed, e.g. [supertab] or [YouCompleteMe].

Note that the [YouCompleteMe] and [neocomplcache] plug-ins do not work well with the suggestion of possible
completions for partial matches, and therefore this feature is disabled if those plug-ins are detected.

A literal tab can always be forced by using `CTRL-V` and then `Tab`.

On the Vim command line, e.g. when searching the file with the `/` or `?` commands, the feature is
activated by `Shift-Tab`.

To disable this mapping, you can use the command `:let g:latex_to_unicode_tab = 0`, e.g. by putting
it into your `.vimrc` file. You can also change this setting from the Vim command-line, but you will
also need to give the command `:call LaTeXtoUnicode#Init()` for the change to take effect.

Even when the mapping is disabled, the feature is still available via the omnicompletion mechanism,
i.e. by pressing `CTRL-X` and then `CTRL-O`.

To disable the suggestions of partial matches completions, use the command
`:let g:latex_to_unicode_suggestions = 0`.

In general, suggestions try not to get in the way, and so if an exact match is detected (e.g. `\ne`) when
`Tab` is pressed, the substitution will be done even when there would be other symbols with the same prefix
(e.g. `\neg`). This behaviour can be changed by the command `:let g:latex_to_unicode_eager = 0`, in
which case hitting `Tab` will first produce a suggestion list, and only pressing it again will trigger the
substitution to Unicode.

[supertab]: https://github.com/ervandew/supertab
[YouCompleteMe]: https://github.com/Valloric/YouCompleteMe
[neocomplcache]: https://github.com/Shougo/neocomplcache.vim

#### Using this feature on Vim versions lower than 7.4

The automatic remapping of the `<Tab>` key is not performed if Vim version is lower than 7.4. However, the
functionality can still be used via the omnicompletion mechanism, i.e. by using `CTRL-X + CTRL-O`. You can
map this to some more convenient key combination, e.g. you may want to add something like this line to your
`.vimrc` file:

```
inoremap <C-Tab> <C-X><C-O>
```

This would map the functionality to `CTRL-Tab`. However, if you try to map this to `<Tab>`, you'd only be
able to use literal `<Tab>` by using `CTRL-V + <Tab>`.

### LaTeX-to-Unicode as you type

An automatic substitution mode can be activated by using the command `:let g:latex_to_unicode_auto = 1`,
e.g. by putting it into your `.vimrc` file. You can also change this setting from the Vim command-line, but
you will also need to give the command `:call LaTeXtoUnicode#Init()` for the change to take effect.

In this mode, symbols will be substituted as you type, as soon as some extra character appears after the symbol
and a LaTeX sequence can unambiguously be identified.

For example, if you type `a \neq b` the `\neq` will be changed to `≠` right after the space, before you input
the `b`.

This does not interfere with the `<Tab>` mapping discussed above.

The `g:latex_to_unicode_auto` setting can also be changed from the Vim command-line, but you will
also need to give the command `:call LaTeXtoUnicode#Init()` for the change to take effect.

This feature is not available with Vim versions lower then 7.4.

### LaTeX-to-Unicode on other file types

By default, the LaTeX-to-Unicode substitutions are only active when editing Julia files. However, you can use
the variable `g:latex_to_unicode_file_types` to specify for which file types this feature is active by default.
The variable must be set to a string containing a pattern (a regular expression) which matches the desired file
types, or to a list of such patterns. For example, to activate the feature on all file types, you could put
`let g:latex_to_unicode_file_types = ".*"` in your `.vimrc` file.
Be aware, however, that enabling the functionality overrides the `omnifunc` setting for that file type.

### Enabling and disabling the LaTeX-to-Unicode functionality

Regardless of the type of the file you are editing and of the `g:latex_to_unicode_file_types` setting, the
LaTeX-to-Unicode substitutions can be enabled/disabled/toggled by calling the functions
`LaTeXtoUnicode#Enable()`, `LaTeXtoUnicode#Disable()`, `LaTeXtoUnicode#Toggle()`. For example, you could use
the mappings:

```
noremap <expr> <F7> LaTeXtoUnicode#Toggle()
inoremap <expr> <F7> LaTeXtoUnicode#Toggle()
```

and then use the `<F7>` key to quickly turn the feature on and off.

## Block-wise movements and block text-objects

This plug-in defines mappings to move around julia blocks (e.g. `if/end`, `function/end` etc.) and to
manipulate them as a whole (analogously to the standard `w`, `b` etc. commands to move on words, and to
the `aw`, `iw` commands which allow to manipulate them). These require the `matchit` plugin, which is usually
distributed with ViM but must be explicitly enabled, e.g. adding this to your `.vimrc` file:

```vim
runtime macros/matchit.vim
```

Or you can use the code at [https://github.com/edsono/matchit] and install it as a plug-in.

The default mappings use `]]`, `][`, `[[`, `[]`, `]j`, `]J`, `[j`, and `[J` for the movements
and `aj`, `ij` for the selections. These can be disabled collectively by setting `g:julia_blocks` to `0`,
or they can be remapped and/or disabled individually by defining a `g:julia_blocks_mapping` variable.
See the documentation for details.

## Changing syntax highlighting depending on the Julia version

The pluign supports syntax highlighting different versions of Julia. By default, the highlighting scheme assumes
the latest stable release of Julia (currently, version 0.4), but the previous one and the latest version under
development are also supported. You can set a global default in your `.vimrc`, e.g. if you follow Julia's master
you can use:

```
let g:default_julia_version = "devel"
```

or if you are still using Julia 0.3 you can use:

```
let g:default_julia_versoin = "0.3"
```

You can also switch version for a particular buffer, by using the `julia#set_syntax_version()` function, e.g.
by typing in Vim:

```
:call julia#set_syntax_version("0.3")
```
