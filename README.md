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
