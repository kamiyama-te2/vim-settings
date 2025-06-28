" ============================================================================
" 基本設定
" ============================================================================
set shortmess+=I " 起動時のメッセージを抑制
set belloff=all  " 全てのベルを無効化

" OSのクリップボードを使用する
set clipboard+=unnamed
set clipboard=unnamed

" エンコード設定
if has('unix')
    set fileformat=unix
    set fileformats=unix,dos,mac
    set fileencoding=utf-8
    set fileencodings=utf-8,iso-2022-jp,cp932,euc-jp
    set termencoding=
elseif has('win32')
    set fileformat=dos
    set fileformats=dos,unix,mac
    set fileencoding=utf-8
    set fileencodings=iso-2022-jp,utf-8,euc-jp,cp932
    set termencoding=
endif

" ファイル設定
set nobackup " バックアップファイルを作成しない
set noswapfile " スワップファイルを作成しない
set viminfo="" " Vim情報ファイルを使用しない
set noundofile " undoファイルを使用しない
set hlsearch    " 検索結果をハイライト表示
set incsearch   " インクリメンタルサーチを有効にする
set ignorecase  " 検索時に大文字小文字を区別しない
set smartcase   " 検索時に大文字が含まれる場合は大文字小文字を区別する
set linebreak   " 行の折り返しを単語単位で行う
set showbreak=↪\    " 折り返し行の先頭に表示する文字

" 表示設定
set backspace=indent,eol,start " バックスペースを効かせる
set expandtab " タブをスペースに変換
set tabstop=4 " タブの幅を4スペースに設定
set shiftwidth=4 " インデントの幅を4スペースに設定
set softtabstop=4 " ソフトタブの幅を4スペースに設定
set autoindent " 自動インデントを有効にする
set smartindent " 改行時に入力された行の末尾に合わせて次の行のインデントを調整
set list " スペースやタブを可視化
set listchars=tab:▸\ ,trail:·,extends:❯,precedes:❮,nbsp:×
set number " 行番号を表示
set textwidth=0 " 自動折り返しを無効にする
set cursorline " カーソル行を強調表示
set laststatus=2 " 常にステータスラインを表示
set cmdheight=2 " コマンドラインの高さを2行に設定
set showmatch " 対応する括弧を強調表示
set wildmenu wildmode=list:longest,full " コマンドラインモードでTABキーによるファイル名補完を有効にする

" ============================================================================
" キーマッピング
" ============================================================================
" ノーマルモードの設定
" 削除でレジスタに格納しない（ビジュアルモードでの選択後は格納する）
nnoremap x "_x
" ノーマルモード中でもエンターキーで改行挿入でインサートモードに戻る
noremap <CR> i<CR>
" j, kによる移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk
" Ctrl + hjklでウィンドウ移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Shift + 矢印でウィンドウサイズ変更
nnoremap <S-Left> <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up> <C-w>-<CR>
nnoremap <S-Down> <C-w>+<CR>

" {}で空行を検索（デフォルトだとタブが空行として認識されないため）
nnoremap { ?^\s*$<CR>
nnoremap } /^\s*$<CR>

" insertモードの設定
inoremap <C-s> <Esc>:w<CR> " Ctrl + sで保存
inoremap <C-q> <Esc>:q<CR> " Ctrl + qで終了

" leaderをスペースに設定
let mapleader = "\<Space>"
" leaderキーのタイムアウト
set timeoutlen=400

" Escapeキー（挿入モードから抜ける）
inoremap <Leader>j <Esc>       " 半角スペース + j
" ファイル保存
nnoremap <Leader>w :w<CR>      " 半角スペース + w
" ファイル終了
nnoremap <Leader>q :q<CR>      " 半角スペース + q
" 全選択（ノーマルモード）
noremap <Leader>a myggVG$      " 半角スペース + a
" 全選択（挿入モードから）
inoremap <Leader>a <Esc>myggVG$   " 半角スペース + a
" .vimrcを開く
nnoremap <silent> <Leader>vr :new ~/.vimrc<CR>    " 半角スペース + vr
" .vimrcの読み込み
nnoremap <silent> <Leader>r :source ~/.vimrc<CR>  " 半角スペース + r
" ウィンドウ移動（スペース2回）
noremap <Leader><Leader> <C-w>w    " 半角スペース + 半角スペース

" ファイルリネーム（関数名を修正）
map <leader>n :call RenameCurrentFile()<cr>       " 半角スペース + n
map 　ｎ :call RenameCurrentFile()<cr>            " 全角スペース + 全角n
" リネーム関数定義
function! RenameCurrentFile()
  let old = expand('%')
  let new = input('新規ファイル名: ', old , 'file')
  if new != '' && new != old
    exec ':saveas ' . new
    exec ':silent !rm ' . old
    redraw!
  endif
endfunction

" Tabでインデントを増やす
inoremap <Tab> <C-t>
nnoremap <Tab> >>
vnoremap <Tab> >gv

" Shift+Tabでインデントを減らす
inoremap <S-Tab> <C-d>
nnoremap <S-Tab> <<
vnoremap <S-Tab> <gv

" ============================================================================
" 日本語入力の設定
" ============================================================================

" 日本語入力がオンのままでも使えるコマンド(Enterキーは必要)
nnoremap あ a
nnoremap い i
nnoremap う u
nnoremap お o
nnoremap っd dd
nnoremap っy yy
inoremap 　ｊ <Esc>            " 全角スペース + 全角j
nnoremap 　ｗ :w<CR>           " 全角スペース + 全角w
noremap 　　 <C-w>w                " 全角スペース + 全角スペース
nnoremap <silent> 　ｒ :source ~/.vimrc<CR>       " 全角スペース + 全角r
nnoremap <silent> 　ｖｒ :new ~/.vimrc<CR>        " 全角スペース + 全角vr
inoremap 　ａ <Esc>myggVG$        " 全角スペース + 全角a
noremap 　ａ myggVG$           " 全角スペース + 全角a
nnoremap 　ｑ :q<CR>           " 全角スペース + 全角q

" ESCキーでWSLIMEをオフにする
function! WSLIMEOff()
    " 非同期で実行
    if has('job')
        call job_start(['powershell.exe', '-NoProfile', '-Command',
            \ 'Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait(''{ESC}'')'])
    else
        " 同期実行（フォールバック）
        silent! call system('powershell.exe -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait(''{ESC}'')" 2>/dev/null')
    endif
endfunction

augroup WSLIMEControl
    autocmd!
    autocmd InsertLeave * call WSLIMEOff()
augroup END

inoremap <silent> <ESC> <ESC>:call WSLIMEOff()<CR>

" スペース + f(F,t,T) で digraph を入力で、日本語の検索ができるようにする
noremap <space>f f<C-k>
noremap <space>F F<C-k>
noremap <space>t t<C-k>
noremap <space>T T<C-k>

" ============================================================================
" 基本五十音（ひらがな）
" ============================================================================
" あ行
digraph aa 12354  " あ
digraph ii 12356  " い
digraph uu 12358  " う
digraph ee 12360  " え
digraph oo 12362  " ぉ

" か行
digraph ka 12363  " か
digraph ki 12365  " き
digraph ku 12367  " く
digraph ke 12369  " け
digraph ko 12371  " こ

" が行
digraph ga 12364  " が
digraph gi 12366  " ぎ
digraph gu 12368  " ぐ
digraph ge 12370  " げ
digraph go 12372  " ご

" さ行
digraph sa 12373  " さ
digraph si 12375  " し
digraph su 12377  " す
digraph se 12379  " せ
digraph so 12381  " そ

" ざ行
digraph za 12374  " ざ
digraph zi 12376  " じ
digraph zu 12378  " ず
digraph ze 12380  " ぜ
digraph zo 12382  " ぞ

" た行
digraph ta 12383  " た
digraph ti 12385  " ち
digraph tu 12388  " つ
digraph te 12390  " て
digraph to 12392  " と

" だ行
digraph da 12384  " だ
digraph di 12386  " ぢ
digraph du 12389  " づ
digraph de 12391  " で
digraph do 12393  " ど

" な行
digraph na 12394  " な
digraph ni 12395  " に
digraph nu 12396  " ぬ
digraph ne 12397  " ね
digraph no 12398  " の

" は行
digraph ha 12399  " は
digraph hi 12402  " ひ
digraph hu 12405  " ふ
digraph he 12408  " へ
digraph ho 12411  " ほ

" ば行
digraph ba 12400  " ば
digraph bi 12403  " び
digraph bu 12406  " ぶ
digraph be 12409  " べ
digraph bo 12412  " ぼ

" ぱ行
digraph pa 12401  " ぱ
digraph pi 12404  " ぴ
digraph pu 12407  " ぷ
digraph pe 12410  " ぺ
digraph po 12413  " ぽ

" ま行
digraph ma 12414  " ま
digraph mi 12415  " み
digraph mu 12416  " む
digraph me 12417  " め
digraph mo 12418  " も

" や行
digraph ya 12420  " や
digraph yu 12422  " ゆ
digraph yo 12424  " よ

" ら行
digraph ra 12425  " ら
digraph ri 12426  " り
digraph ru 12427  " る
digraph re 12428  " れ
digraph ro 12429  " ろ

" わ行
digraph wa 12431  " わ
digraph wo 12434  " を
digraph nn 12435  " ん

" ============================================================================
" 基本五十音（カタカナ）
" ============================================================================
" ア行
digraph AA 12450  " ア
digraph II 12452  " イ
digraph UU 12454  " ウ
digraph EE 12456  " エ
digraph OO 12458  " オ

" カ行
digraph KA 12459  " カ
digraph KI 12461  " キ
digraph KU 12463  " ク
digraph KE 12465  " ケ
digraph KO 12467  " コ

" ガ行
digraph GA 12460  " ガ
digraph GI 12462  " ギ
digraph GU 12464  " グ
digraph GE 12466  " ゲ
digraph GO 12468  " ゴ

" サ行
digraph SA 12469  " サ
digraph SI 12471  " シ
digraph SU 12473  " ス
digraph SE 12475  " セ
digraph SO 12477  " ソ

" ザ行
digraph ZA 12470  " ザ
digraph ZI 12472  " ジ
digraph ZU 12474  " ズ
digraph ZE 12476  " ゼ
digraph ZO 12478  " ゾ

" タ行
digraph TA 12479  " タ
digraph TI 12481  " チ
digraph TU 12484  " ツ
digraph TE 12486  " テ
digraph TO 12488  " ト

" ダ行
digraph DA 12480  " ダ
digraph DI 12482  " ヂ
digraph DU 12485  " ヅ
digraph DE 12487  " デ
digraph DO 12489  " ド

" ナ行
digraph NA 12490  " ナ
digraph NI 12491  " ニ
digraph NU 12492  " ヌ
digraph NE 12493  " ネ
digraph NO 12494  " ノ

" ハ行
digraph HA 12495  " ハ
digraph HI 12498  " ヒ
digraph HU 12501  " フ
digraph HE 12504  " ヘ
digraph HO 12507  " ホ

" バ行
digraph BA 12496  " バ
digraph BI 12499  " ビ
digraph BU 12502  " ブ
digraph BE 12505  " ベ
digraph BO 12508  " ボ

" パ行
digraph PA 12497  " パ
digraph PI 12500  " ピ
digraph PU 12503  " プ
digraph PE 12506  " ペ
digraph PO 12509  " ポ

" マ行
digraph MA 12510  " マ
digraph MI 12511  " ミ
digraph MU 12512  " ム
digraph ME 12513  " メ
digraph MO 12514  " モ

" ヤ行
digraph YA 12516  " ヤ
digraph YU 12518  " ユ
digraph YO 12520  " ヨ

" ラ行
digraph RA 12521  " ラ
digraph RI 12522  " リ
digraph RU 12523  " ル
digraph RE 12524  " レ
digraph RO 12525  " ロ

" ワ行
digraph WA 12527  " ワ
digraph WO 12530  " ヲ
digraph NN 12531  " ン

" ============================================================================
" 句読点・記号
" ============================================================================
digraph ,, 12289  " 、(読点)
digraph .. 12290  " 。(句点)
digraph -- 12540  " ー (長音記号)
digraph ~~ 12316  " 〜 (波ダッシュ)
digraph ** 12539  " ・ (中点)
digraph !! 65281  " ！ (全角感嘆符)
digraph ?? 65311  " ？ (全角疑問符)
digraph :: 65306  " ： (全角コロン)
digraph ;; 65307  " ； (全角セミコロン)

" ============================================================================
" 括弧類
" ============================================================================
digraph (( 65288  " （ (全角左括弧)
digraph )) 65289  " ） (全角右括弧)
digraph [[ 12300  " 「 (かぎ括弧開)
digraph ]] 12301  " 」 (かぎ括弧閉)
digraph {{ 12302  " 『 (二重かぎ括弧開)
digraph }} 12303  " 』 (二重かぎ括弧閉)
digraph <( 12304  " 【 (隅付き括弧開)
digraph )> 12305  " 】 (隅付き括弧閉)

" ============================================================================
" 数字（全角）
" ============================================================================
digraph 00 65296  " ０
digraph 11 65297  " １
digraph 22 65298  " ２
digraph 33 65299  " ３
digraph 44 65300  " ４
digraph 55 65301  " ５
digraph 66 65302  " ６
digraph 77 65303  " ７
digraph 88 65304  " ８
digraph 99 65305  " ９

" ============================================================================
" カラースキーム
" ============================================================================

" True Color対応
if has('termguicolors')
  set termguicolors
endif
set t_Co=256

" エンコーディング
set encoding=utf-8
set fileencoding=utf-8

set background=dark

" 背景を透過に
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight LineNr ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE

" ============================================================================
" 行番号 - モダンなグレー系
" ============================================================================
highlight LineNr ctermfg=240 guifg=#585858
highlight CursorLineNr ctermfg=172 guifg=#d78700 cterm=bold gui=bold
highlight RelativeLineNr ctermfg=242 guifg=#6c6c6c

" ============================================================================
" カーソル行・列 - 目立ちすぎない強調
" ============================================================================
highlight CursorLine ctermbg=234 guibg=#1c1c1c cterm=NONE gui=NONE

" ============================================================================
" 構文ハイライト - モダンなカラーパレット
" ============================================================================
" コメント（灰色、イタリック）
highlight Comment ctermfg=245 guifg=#8a8a8a cterm=italic gui=italic

" 文字列（温かみのある緑）
highlight String ctermfg=114 guifg=#87d787

" 数値（オレンジ）
highlight Number ctermfg=209 guifg=#ff875f

" キーワード（紫）
highlight Keyword ctermfg=141 guifg=#af87ff cterm=bold gui=bold

" 関数名（青）
highlight Function ctermfg=117 guifg=#87d7ff cterm=bold gui=bold

" 変数・識別子（シアン）
highlight Identifier ctermfg=80 guifg=#5fd7d7

" 型名（黄緑）
highlight Type ctermfg=148 guifg=#afd700 cterm=bold gui=bold

" 定数（オレンジ）
highlight Constant ctermfg=208 guifg=#ff8700

" 演算子（白）
highlight Operator ctermfg=15 guifg=#ffffff

" 括弧（灰色）
highlight Delimiter ctermfg=248 guifg=#a8a8a8

" ============================================================================
" 検索・選択
" ============================================================================
highlight Search ctermbg=58 ctermfg=15 guibg=#5f5f00 guifg=#ffffff cterm=bold gui=bold
highlight IncSearch ctermbg=196 ctermfg=15 guibg=#ff0000 guifg=#ffffff cterm=bold gui=bold
highlight Visual ctermbg=240 guibg=#585858

" ============================================================================
" ステータスライン
" ============================================================================
highlight StatusLine ctermbg=236 ctermfg=15 guibg=#303030 guifg=#ffffff cterm=bold gui=bold
highlight StatusLineNC ctermbg=234 ctermfg=244 guibg=#1c1c1c guifg=#808080

set statusline=%F                                                 " [ステータスバー]ファイル名表示
set statusline+=%m                                                " [ステータスバー]変更のチェック表示
set statusline+=%r                                                " [ステータスバー]読み込み専用かどうか表示
set statusline+=%h                                                " [ステータスバー]ヘルプページなら[HELP]と表示
set statusline+=%w\                                               " [ステータスバー]プレビューウインドウなら[Prevew]と表示
set statusline+=%=                                                " [ステータスバー]ここからツールバー右側
set statusline+=[FORMAT=%{&ff}]\                                  " [ステータスバー]ファイルフォーマット表示
set statusline+=[%{has('multi_byte')&&\&fileencoding!=''?&fileencoding:&encoding}] " [ステータスバー]文字コードの表示
set statusline+=[%l行,%v桁]                                       " [ステータスバー]列位置、行位置の表示
set statusline+=[%p%%]                                            " [ステータスバー]現在行が全体行の何%目か表示
set statusline+=[WC=%{exists('*WordCount')?WordCount():[]}]       " [ステータスバー]現在のファイルの文字数をカウント

" 挿入モード時、ステータスラインの色を変更
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=blue ctermbg=yellow cterm=none'

if has('syntax')
    augroup InsertHook
        autocmd!
        autocmd InsertEnter * call s:StatusLine('Enter')
        autocmd InsertLeave * call s:StatusLine('Leave')
    augroup END
endif

let s:slhlcmd = ''

function! s:StatusLine(mode)
    if a:mode == 'Enter'
        set cursorline
        silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
        silent exec g:hi_insert
    else
        set nocursorline
        highlight clear StatusLine
        silent exec s:slhlcmd
    endif
endfunction

function! s:GetHighlight(hi)
    redir => hl
    exec 'highlight ' . a:hi
    redir END
    let hl = substitute(hl, '[\r\n]', '', 'g')
    let hl = substitute(hl, 'xxx', '', '')
    return hl
endfunction

" 自動文字数カウント
augroup WordCount
    autocmd!
    autocmd BufWinEnter,InsertLeave,CursorHold * call WordCount('char')
augroup END
let s:WordCountStr = ''
let s:WordCountDict = {'word': 2, 'char': 3, 'byte': 4}
function! WordCount(...)
    if a:0 == 0
        return s:WordCountStr
    endif
    let cidx = 3
    silent! let cidx = s:WordCountDict[a:1]
    let s:WordCountStr = ''
    let s:saved_status = v:statusmsg
    exec "silent normal! g\<c-g>"
    if v:statusmsg !~ '^--'
        let str = ''
        silent! let str = split(v:statusmsg, ';')[cidx]
        let cur = str2nr(matchstr(str, '\d\+'))
        let end = str2nr(matchstr(str, '\d\+\s*$'))
        if a:1 == 'char'
            " ここで(改行コード数*改行コードサイズ)を'g<C-g>'の文字数から引く
            let cr = &ff == 'dos' ? 2 : 1
            let cur -= cr * (line('.') - 1)
            let end -= cr * line('$')
        endif
        let s:WordCountStr = printf('%d/%d', cur, end)
    endif
    let v:statusmsg = s:saved_status
    return s:WordCountStr
endfunction

" ============================================================================
" 補完メニュー
" ============================================================================
highlight Pmenu ctermbg=236 ctermfg=251 guibg=#303030 guifg=#c6c6c6
highlight PmenuSel ctermbg=24 ctermfg=15 guibg=#005f87 guifg=#ffffff cterm=bold gui=bold
highlight PmenuSbar ctermbg=240 guibg=#585858
highlight PmenuThumb ctermbg=15 guibg=#ffffff

" ============================================================================
" 特殊文字・記号
" ============================================================================
" 括弧マッチング
highlight MatchParen ctermbg=24 ctermfg=15 guibg=#005f87 guifg=#ffffff cterm=bold gui=bold

" ウィンドウ分割線
highlight VertSplit ctermbg=NONE ctermfg=236 guibg=NONE guifg=#303030

" 折りたたみ
highlight Folded ctermbg=235 ctermfg=180 guibg=#262626 guifg=#d7af87 cterm=italic gui=italic
highlight FoldColumn ctermbg=NONE ctermfg=180 guibg=NONE guifg=#d7af87

" タブライン
highlight TabLine ctermbg=235 ctermfg=249 guibg=#262626 guifg=#b2b2b2
highlight TabLineFill ctermbg=235 guibg=#262626
highlight TabLineSel ctermbg=24 ctermfg=15 guibg=#005f87 guifg=#ffffff cterm=bold gui=bold

" ============================================================================
" エラー・警告
" ============================================================================
highlight Error ctermbg=88 ctermfg=15 guibg=#870000 guifg=#ffffff cterm=bold gui=bold
highlight ErrorMsg ctermbg=88 ctermfg=15 guibg=#870000 guifg=#ffffff cterm=bold gui=bold
highlight WarningMsg ctermfg=208 guifg=#ff8700 cterm=bold gui=bold
highlight Todo ctermbg=100 ctermfg=0 guibg=#878700 guifg=#000000 cterm=bold gui=bold

" ============================================================================
" 特殊文字の表示設定
" ============================================================================
" 不可視文字をモダンに
highlight SpecialKey ctermfg=240 guifg=#585858
highlight NonText ctermfg=240 guifg=#585858

" ============================================================================
" オプション設定
" ============================================================================
" 補完オプション
set completeopt=menu,menuone,noselect

let &t_SI = "\e[6 q"    " 挿入モード: 縦線
let &t_EI = "\e[2 q"    " ノーマルモード: ブロック
let &t_SR = "\e[4 q"    " 置換モード: アンダーライン

" ディレクトリ表示（netrw）
highlight Directory ctermfg=117 guifg=#87d7ff cterm=bold gui=bold

" リンク
highlight Underlined ctermfg=117 guifg=#87d7ff cterm=underline gui=underline

" 差分表示
highlight DiffAdd ctermbg=22 ctermfg=15 guibg=#005f00 guifg=#ffffff
highlight DiffChange ctermbg=58 ctermfg=15 guibg=#5f5f00 guifg=#ffffff
highlight DiffDelete ctermbg=88 ctermfg=15 guibg=#870000 guifg=#ffffff
highlight DiffText ctermbg=94 ctermfg=0 guibg=#875f00 guifg=#000000 cterm=bold gui=bold


" ============================================================================
" マッピング
" ============================================================================
" 検索ハイライトをクリア
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>

" ============================================================================
" ファイルタイプ別の追加設定
" ============================================================================
augroup FileTypeColors
  autocmd!
  " HTML/XML タグ
  autocmd FileType html,xml highlight htmlTag ctermfg=117 guifg=#87d7ff
  autocmd FileType html,xml highlight htmlEndTag ctermfg=117 guifg=#87d7ff

  " CSS プロパティ
  autocmd FileType css highlight cssProp ctermfg=114 guifg=#87d787
  autocmd FileType css highlight cssAttr ctermfg=208 guifg=#ff8700

  " JavaScript
  autocmd FileType javascript highlight javaScriptFunction ctermfg=141 guifg=#af87ff
  autocmd FileType javascript highlight javaScriptBraces ctermfg=15 guifg=#ffffff
augroup END
