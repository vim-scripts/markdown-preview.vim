if !has('python')
    echo 'Error: Required vim compile with +python'
    finish
endif

" the target resource files folder
if !exists('g:MarkDownResDir')
    let g:MarkDownCSSDir='~/.vim/MarkDownRes'
endif

" the source resource files folder
if !exists('g:SourceMarkDownResDir')
    let g:SourceMarkDownCssDir='~/.vim/bundle/markdown-preview.vim/resources'
endif

function! MarkdownPath()
python << EOF
import vim, os, sys
sourced_file = vim.eval('s:SourcedFile')
while not os.path.exists(os.path.join(sourced_file, 'pythonx')):
    sourced_file = os.path.dirname(sourced_file)
module_path = os.path.join(sourced_file, 'pythonx')
sys.path.append(module_path)
EOF
endfunction

" Expand our path
let s:SourcedFile=expand("<sfile>")
call MarkdownPath()


function! MarkdownPreviewInit()
python << EOF
import markdown_init
markdown_init.init()
EOF
endfunction

if empty(glob('~/.vim/MarkDownCSS/default.css'))
    call MarkdownPreviewInit()
endif

function! MarkdownPreview(args1)
python << EOF
import markdown_preview
markdown_preview.markdownPreview()
EOF
endfunction

function! ClearAll()
python << EOF
import os, commands
currentpath = commands.getstatusoutput("pwd")[1]
os.remove(os.path.join(currentpath, 'tmp.html'))
EOF
endfunction

function! Preview(args1)
call MarkdownPreview(a:args1)
!read ENTER
call ClearAll()
endfunction

command! -nargs=1 MarkdownPreview :call Preview(<f-args>)

map <leader>m :MarkdownPreview GitHub<CR>
