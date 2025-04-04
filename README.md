# Nvim

Install:

```sh
git clone https://github.com/iamajoe/nvim ~/.config/nvim
npm i -g vscode-langservers-extracted
npm install -g @fsouza/prettierd
```

On vim, install dependencies:

```
:Lazy
```

## Shortcuts / Cheatsheet
```
<C-v>                 # Column visual mode
J                     # join lines

<leader>p             # copy without losing last yield
<leader>y             # copy visual selection to system clipboard
<leader>sw            # search and replace cursor word
<leader>s             # search and replace cursor term word

ff                    # Fix / lint all
<leader>/             # comment / uncomment line

<leader>gd            # jump to definition
<leader>gp            # definition with preview
K                     # "hover" symbol
<leader>vws           # workspace_symbol() ???
<leader>vd            # view definition of issue on float
[d                    # go to next diagnostic
]d                    # go to previous diagnostic
<leader>vca           # code action / fix panel
<leader>vrr           # show references
<leader>vrn           # rename symbol
<leader>vo            # show outline

<leader>xq            # quickfix diagnostics
<leader>xd            # document diagnostics
<leader>xw            # workspace diagnostics

<C-w>                 # close quickfix
<C-k>                 # next on the quickfix list
<C-j>                 # previous on the quickfix list
<leader>qlc           # close quicklist

# on diagnostics
q                     # close the list
o                     # jump to the diagnostic and close the list

# while in auto complete float
<C-p>                 # select previous item
<C-n>                 # select next item
<C-y>                 # confirm item
<C-Space>             # open auto complete
```

### Move quickly...

```
f<character>          # search for next character
F<character>          # search for previous character
; / ,                 # goes back and forth between last search

<C-d>                 # jump down
<C-u>                 # jump up
<C-o> || <C-t>        # jump back to file
n                     # go to next highlight
N                     # go to previous highlight

dib                   # delete inside balanced (alias for } ) ])
diq                   # delete inside quotes
dia                   # delete argument
dilb                  # delete inside last balanced
dinb                  # delete inside next balanced
```

### Buffers

```
<C-w>l                # goes to next buffer
<C-w>h                # goes to previous buffer
<C-w>w                # closes current buffer
<C-w>a                # vertical split
<C-w>h                # select buffer on left split
<C-w>l                # select buffer on right split
<leader>bwa           # closes all other buffers
<leader>cf            # duplicate open file
```

### Telescope

```
<C-j>                 # move down
<C-k>                 # move up
<C-o>                 # select
<leader>ba            # list all buffer
<leader>pb            # open file browser
<leader>pf            # find files
<C-p>                 # find files in git / <C-p> from sublime
<leader>ps            # grep and find files
<leader>py            # find symbol in project
<leader>fg            # live grep / search in files
<leader>p             # open yank list
<C-p>                 # under yank list, paste
<C-x>                 # under yank list, remove from yank
<C-r>                 # under yank list, replace current register
```

#### File browser

```
<C-f>c                # create file
<C-f>                 # rename file
<C-f>                 # move file
<C-f>y                # copy file
<C-f>d                # remove file
<C-p>                 # go parent
```

### File tree (netrw)

```
<leader>pv            # open file netrw
<C-p>                 # toggle preview of file
<C-l>                 # refresh list
_                     # open cwd
```

### Visual mode

```
J                     # move line down
K                     # move line up
```

### Input mode

```
<C-h>                 # show signature
<C-o> ...             # do one command in normal mode
```

### Harpoon

```
<leader>a             # mark file for harpoon
<C-e>                 # open harpoon menu
```

### Surround

```
ysiw)                 # (surround_words)
ys$"                  # "make strings"
ds]                   # delete around me!
dst                   # remove HTML tags
cs'"                  # "change quotes"
csth1<CR>             # <h1>or tag types</h1>
dsf                   # function calls
```

### Search and replace

```
<leader>ps            # enters telescope with grep line
<C-q>                 # sends results to quickfix
:cdo s/old/new/gc     # sends command to replace on quicklist buffers one by one
:cdo s/old/new/g      # sends command to replace on all quicklist buffers
:cdo w                # write quicklist buffers
:cdo bd               # close buffers from quicklist
```

### Copilot

```
<C-c>a                # copilot accept
<C-c>q                # copilot dismiss
<C-c>n                # copilot next
<C-c>s                # copilot suggest
```

