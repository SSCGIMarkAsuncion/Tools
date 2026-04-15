let mapleader=" "
noremap <A-a> <Esc>
inoremap <A-a> <Esc>
noremap <leader>p "+p
noremap <leader>P "+P
noremap <leader>y "+y
noremap <leader>Y "+Y
nnoremap <leader>ay :%y+
" vnoremap p "0p
" vnoremap P "0P
noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz
set nohlsearch
set scrolloff=10
set ignorecase
set smartcase
nnoremap Y y$
nnoremap <leader>ay :%y+<CR>

nnoremap K :vsc Edit.QuickInfo<CR>
nnoremap <leader>cr :vsc Refactor.Rename<CR>
nnoremap gcc :vsc Edit.ToggleLineComment<CR>
vnoremap gc :vsc Edit.ToggleLineComment<CR>
nnoremap gr :vsc Edit.FindAllReferences<CR>
nnoremap gd :vsc Edit.GoToImplementation<CR>
nnoremap gD :vsc Edit.GoToDefinition<CR>
nnoremap L :vsc Window.NextTab<CR>
nnoremap H :vsc Window.PreviousTab<CR>
nnoremap <leader>w :vsc Window.CloseDocumentWindow<CR>
nnoremap <leader>W :vsc Window.CloseAllDocuments<CR>
nnoremap <leader>ff :vsc Edit.GoToFile<CR>
nnoremap <leader>fs :vsc Edit.GoToMember<CR>
nnoremap <leader>fS :vsc Edit.GoToType<CR>
noremap <leader>fg :vsc Edit.Find<CR>
nnoremap <leader>/ :vsc Edit.FindInFiles<CR>
nnoremap ]e :vsc Edit.GoToNextIssueinFile<CR>
nnoremap [e :vsc Edit.GoToPreviousIssueinFile<CR>
nnoremap <leader>e :vsc View.SolutionExplorer<CR>
inoremap <C-n> <C-o>:vsc Edit.CompleteWord<CR>
nnoremap <leader>ca :vsc View.QuickActions<CR>
nnoremap ]e :vsc View.NextError<CR>
nnoremap [e :vsc View.PreviousError<CR>
nnoremap <leader>mt :vsc Edit.ToggleBookmark<CR>
nnoremap <leader>mN :vsc Edit.PreviousBookmark<CR>
nnoremap <leader>mn :vsc Edit.NextBookmark<CR>

" For Visual Studio 2026
cnoreabbrev vsp :vsc Windows.NewTabRight
cnoreabbrev vsplit :vsc Windows.NewTabRight
