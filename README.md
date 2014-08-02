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

## LaTeX-to-Unicode substitutions

This plug-in adds some functionality to substitute LaTeX code sequences (e.g. `\alpha`) with corresponding
Unicode symbols (e.g. `α`). By default, these substitutions must be triggered explicitly by pressing the
`<Tab>` key, as in the Julia command line (the REPL); however, an automatic, as-you-type mode can also
be activated.

On the Vim command line, the feature is activated by pressing `Shift-Tab`. This is mostly useful
when searching the files with the `/` or `?` commands.

These features only work as described with Vim version 7.4 or higher. Tab completion can still be made
available on lower Vim versions, see below for more details.

The following sections provide details on this features. The complete documentation is provided by calling
`:help julia-vim` from within Vim.

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

To disable this mapping, you can use the command `:let g:julia_latex_to_unicode = 0`, e.g. by putting
it into your `.vimrc` file. You can also change this setting from the Vim command-line, but you will
also need to give the command `:call JuliaLaTeXtoUnicodeInit()` for the change to take effect.

Even when the mapping is disabled, the feature is still available via the omnicompletion mechanism,
i.e. by pressing `CTRL-X` and then `CTRL-O`.

To disable the suggestions of partial matches completions, use the command
`:let g:julia_latex_suggestions_enabled = 0`.

In general, suggestions try not to get in the way, and so if an exact match is detected (e.g. `\ne`) when
`Tab` is pressed, the substitution will be done even when there would be other symbols with the same prefix
(e.g. `\neg`). This behaviour can be changed by the command `:let g:julia_latex_to_unicode_eager = 0`, in
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

An automatic substitution mode can be activated by using the command `:let g:julia_auto_latex_to_unicode = 1`,
e.g. by putting it into your `.vimrc` file. You can also change this setting from the Vim command-line, but
you will also need to give the command `:call JuliaLaTeXtoUnicodeInit()` for the change to take effect.

In this mode, symbols will be substituted as you type, as soon as some extra character appears after the symbol
and a LaTeX sequence can unambiguously be identified.

For example, if you type `a \neq b` the `\neq` will be changed to `≠` right after the space, before you input
the `b`.

This does not interfere with the `<Tab>` mapping discussed above.

The `g:julia_auto_latex_to_unicode` setting can also be changed from the Vim command-line, but you will
also need to give the command `:call JuliaLaTeXtoUnicodeInit()` for the change to take effect.

This feature is not available with Vim versions lower then 7.4.
