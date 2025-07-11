" ============================================================================
" 基本設定
" ============================================================================
set shortmess+=I " 起動時のメッセージを抑制

" OSのクリップボードを使用する
set clipboard+=unnamed
set clipboard=unnamed

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
set number " 行番号を表示
set textwidth=0 " 自動折り返しを無効にする
set cursorline " カーソル行を強調表示
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
" ウィンドウ移動（スペース2回）
noremap <Leader><Leader> <C-w>w    " 半角スペース + 半角スペース

" Tabでインデントを増やす
nnoremap <Tab> >>
vnoremap <Tab> >gv

" Shift+Tabでインデントを減らす
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
" マッピング
" ============================================================================
" 検索ハイライトをクリア
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
