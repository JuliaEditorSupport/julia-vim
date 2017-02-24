# Installation instructions

### Using [pathogen]

``` bash
cd ~/.vim
mkdir -p bundle && cd bundle
git clone git://github.com/JuliaEditorSupport/julia-vim.git
```

### Using [vundle]

Add a new plugin line to your `.vimrc`:

``` vim
Plugin 'JuliaEditorSupport/julia-vim'
```

Run `vim` and update your bundles:

``` vim
:PluginInstall!
```

### Using [vim-plug]

Add a new plugin line to your `.vimrc`:

``` vim
Plug 'JuliaEditorSupport/julia-vim'
```

**Note:** do *not* use the on-demand loading feature of vim-plug.
Most of the plugin is loaded on-demand anyway.

Run `vim` and update your bundles:

``` vim
:PlugInstall
```

[pathogen]: https://github.com/tpope/vim-pathogen
[vundle]: https://github.com/gmarik/vundle
[vim-plug]: https://github.com/junegunn/vim-plug

### Manually

Copy (or symlink) the contents of this repository into the vim application support directory:

``` bash
git clone git://github.com/JuliaEditorSupport/julia-vim.git
cd julia-vim
mkdir -p ~/.vim
cp -R * ~/.vim
```

Julia should appear as a file type and be automatically detected for files with the `.jl` extension.

