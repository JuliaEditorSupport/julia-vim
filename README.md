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

This plugin adds a mapping to the `Tab` key which makes it behave like the Julia REPL, i.e. when
the cursor is at the end of a recognized LaTeX symbol (e.g. `\alpha`) in insert mode, pressing
the `Tab` key will substitute it with the corresponding Unicode symbol (e.g. `α`).

If no suitabe substitution is found, the action will fall back to whatever mapping was previously
defined: by default, inserting a literal `Tab` character, or invoking some other action if another
plug-in is installed, e.g. syntastic or YouCompleteMe.

A literal tab can always be forced by using `CTRL-V` and then `Tab`.

To disable this mapping, you can use the command `:let g:julia_latex_to_unicode = 0`, e.g. by putting
it into your `.vimrc` file.

Even when the mapping is disabled, the feature is still available via the omnicompletion mechanism,
i.e. by pressing `CTRL-X` and then `CTRL-O`.
