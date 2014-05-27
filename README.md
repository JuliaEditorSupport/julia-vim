## How to install

### Using [pathogen](https://github.com/tpope/vim-pathogen)

``` bash
cd ~/.vim
mkdir -p bundle && cd bundle
git clone git://github.com/JuliaLang/julia-vim.git
```

### Using [vundle](https://github.com/gmarik/vundle)

Add a new bundle to your `.vimrc`:

``` vim
Bundle 'JuliaLang/julia-vim'
```

Run `vim` and update your bundles:

``` vim
:BundleInstall!
```

### Manually

Copy (or symlink) the contents of this repository into the vim application support directory:

``` bash
git clone git://github.com/JuliaLang/julia-vim.git
cd julia-vim
cp -R * ~/.vim
```

Julia should appear as a file type and be automatically detected for files with the `.jl` extension.

## LaTeX-to-Unicode substitution via Tab key

This plug-in adds a mapping to the `Tab` key which makes it behave like the Julia REPL, i.e. when
the cursor is at the end of a recognized LaTeX symbol (e.g. `\alpha`) in insert mode, pressing
the `Tab` key will substitute it with the corresponding Unicode symbol (e.g. `α`). If a partial match
is found (e.g. `\al`), a list of possible completions is suggested (e.g. `\aleph`, `\allequal`,
`\alpha`), and it will be refined while you enter more characters; when only one match is left, pressing
`Tab` will complete it and pressing it again will perform the substitution to Unicode.

If no suitable substitution is found, the action will fall back to whatever mapping was previously
defined: by default, inserting a literal `Tab` character, or invoking some other action if another
plug-in is installed, e.g. [supertab] or [YouCompleteMe].

Note that the [YouCompleteMe] and [neocomplcache] plug-ins do not work well with the suggestion of possible
completions for partial matches, and therefore this feature is disabled if those plug-ins are detected.

A literal tab can always be forced by using `CTRL-V` and then `Tab`.

To disable this mapping, you can use the command `:let g:julia_latex_to_unicode = 0`, e.g. by putting
it into your `.vimrc` file.

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
