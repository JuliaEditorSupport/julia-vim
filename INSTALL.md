# Installation instructions

It is recommended to install the plugin using a plugin manager. Pick your favorite, here are
instructions for some common ones.

### Using [vim-plug]

Add a new plugin line to your `.vimrc` (or `init.vim` on neovim):

```vim
Plug 'JuliaEditorSupport/julia-vim'
```

**Note:** do *not* use the on-demand loading feature of vim-plug.
Most of the plugin is loaded on-demand anyway.

Run `vim` and update your bundles:

```vim
:PlugInstall
```

### Using [vundle]

Add a new plugin line to your `.vimrc` (or `init.vim` on neovim):

```vim
Plugin 'JuliaEditorSupport/julia-vim'
```

Run `vim` and update your bundles:

```vim
:PluginInstall!
```

### Using [pathogen]

(Note: if you are on Vim 8 or later you may as well use the built-in package management instead of
pathogen, `:help packages`.)

```bash
mkdir -p ~/.vim/pack/julia-vim/start
cd ~/.vim/pack/julia-vim/start
git clone git://github.com/JuliaEditorSupport/julia-vim.git
```

[pathogen]: https://github.com/tpope/vim-pathogen
[vundle]: https://github.com/gmarik/vundle
[vim-plug]: https://github.com/junegunn/vim-plug

### Manually

**It is advised not to use manual installation** unless you use the built-in package managment of
Vim version 8 or later, see `:help packages`.

Otherwise, since julia-vim follows the standard runtime path structure, you can copy (or symlink)
the relevant portions of this repository into the vim application support directory (`~/.vim` or
`~/.config/nvim` or whatever your system uses), as appropriate.
