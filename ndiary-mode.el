;; ndiary-mode.el --- mode for editing ndiary's diary file
;; ISHIKURA Hiroyuki <hiro@nekomimist.org>
;; ----------------------------------------------------------------------
;; History:
;; 2000/03/29 ver.0.1  initial Release
;; 2000/04/16 ver.0.2  generic.elを使わないように変更
;;                     .emacs内でfont-lock定義を変更・追加できるようにした
;; 2000/08/07 ver.0.21 ndiary-font-lock-keywordをちょいと見直し
;; 2000/09/10 ver.0.3  akihisa@alles.or.jp氏のコードを一部マージ. 
;;                     とはいえ私の趣味で大幅に書きなおしています (__)
;; 2000/09/14 ver.0.31 start-process前に同名のprocessをkillする事にした
;; 2000/09/25 ver.0.32 ndiary-previewのはずかしいバグを修正
;; 2000/12/06 ver.0.33 ndiary-uploadではcall-processで処理することにした
;;		       (ファイル転送をasyncでやるのはアレかな〜と…)
;; 2001/02/19 ver.0.4  customize対応(かなり「とりあえず」)
;; 2003/01/13 ver.0.41 face追加
;; 2003/01/30 ver.0.5  ndiary-editをndiary-edit-internalとndiary-editに分割
;;                     ndiary-editに引き数追加(引き数分だけ日付をずらす)
;;                     いくつかエラーメッセージを修正
;; 2003/01/31 ver.0.6  waka氏のコードを元に、yathmlからyahtml-insert-ampsを
;;                     ちょっと変更して取り込んだ
;; 2003/02/01 ver.0.61 ndiary-mode-versionを変え忘れてた :-)
;;                     ndiary-font-lock-keywordsのデフォルト値を修正
;;
;; TODO:
;; ・ドキュメントの充実
;; ・英語版(ぉ
;; ----------------------------------------------------------------------
;; USAGE:
;; 1.まずnDiaryを使えるようにきちんと環境を整備しましょう. 
;;   cmd.exeあるいはcommand.comからnDiaryを実行できるようにPATHなどを設定
;;   するのがベストでしょう. 
;;
;; 2.APEL(http://www.m17n.org/APEL/)をインストールしましょう. Meadowであ
;;   れば配布パッケージに含まれている可能性が高いですが、まぁ最新版にする
;;   のも悪くないでしょう. 
;;
;; 3.あなたがもしMeadow1.14以前を使っているのであれば、Meadowがrubyスクリ
;;   プトを直接start-processやcall-processできるようにするために、.emacsに
;;   以下の次の5行を書き足しましょう. (mw32script.elを書きかえるのも可)
;;       (require 'mw32script)
;;       (setq mw32script-argument-editing-alist
;;             (append '(("/ruby$" . "ruby.exe"))
;;                     mw32script-argument-editing-alist))
;;   Meadow1.15以降(Meadow2系含む)なら以下の一行を.emacsに足せばよいです. 
;;       (mw32script-init)
;;   ndiary-diary-commandにRubyスクリプトそのものでない物(rbexe等を使っ
;;   て生成した実行ファイルとか)を指定するのであれば、もちろんこの記述は
;;   必要ありません. 
;;
;; 4.あなたの環境に合うように.emacsの中で各種の設定を行いましょう. 
;;   Ver.0.4ではcustomizeに対応したので、customizeを使うほうが幸せかも. 
;;   ちなみにVer.0.3時点では、私は次のような設定を入れて使っていました. 
;;       (require 'ndiary-mode)
;;       (setq ndiary-log-directory "~/diary/log")
;;       (setq ndiary-latest-filename "~/public_html/d/index.html")
;;       (setq ndiary-upload-command "sitecopy")
;;       (setq ndiary-upload-command-option "-u rim")
;;
;; 5.これでEmacs(or Meadow)を立ちあげなおせば基本的には準備完了です. 
;;   M-x ndiary-edit で日記編集モードに入りますし、
;;   このモードでM-x ndiary-compile (C-cC-c) すればhtmlが生成されますし、
;;   このモードでM-x ndiary-upload (C-cC-u) すればuploadもできます. 
;;   (ああ、もちろんuploadするツールの設定は自分でやってくださいね. )
;; ----------------------------------------------------------------------
;; $Id: ndiary-mode.el,v 1.12 2003/01/31 16:33:05 neko Exp $

;; ndiary-mode requires APEL.
(require 'path-util)
(require 'alist)

;; 定数
(defconst ndiary-mode-version "0.61" "ndiary-modeのバージョンを示します.")

;; face定義
(defface ndiary-topic-head-face 
  '((((class color) (background light)) (:foreground "ForestGreen"))
    (((class color) (background dark)) (:foreground "PaleGreen"))
    (t (:bold t :underline t)))
  "トピックの冒頭記号のface."
  :group 'ndiary-mode)
(defvar ndiary-topic-head-face 'ndiary-topic-head-face)
(defface ndiary-topic-body-face
  '((((class color) (background light)) (:foreground "Blue"))
    (((class color) (background dark)) (:foreground "LightSkyBlue"))
    (t (:inverse-video t :bold t)))
  "トピックの本体のface."
  :group 'ndiary-mode)
(defvar ndiary-topic-body-face 'ndiary-topic-body-face)
(defface ndiary-item-head-face
  '((((class color) (background light)) (:foreground "Red" :bold t))
    (((class color) (background dark)) (:foreground "Pink" :bold t))
    (t (:inverse-video t :bold t)))
  "列挙の行頭のface."
  :group 'ndiary-mode)
(defvar ndiary-item-head-face 'ndiary-item-head-face)
(defface ndiary-item-body-face
  '((((class color) (background light)) (:foreground "Blue"))
    (((class color) (background dark)) (:foreground "LightSkyBlue"))
    (t (:inverse-video t :bold t)))
  "列挙の行頭以外のface."
  :group 'ndiary-mode)
(defvar ndiary-item-body-face 'ndiary-item-body-face)
(defface ndiary-code-face
  '((((class color) (background light)) (:foreground "Red" :bold t))
    (((class color) (background dark)) (:foreground "Pink" :bold t))
    (t (:inverse-video t :bold t)))
  "Code:とQuote:のface."
  :group 'ndiary-mode)
(defvar ndiary-code-face 'ndiary-code-face)
(defface ndiary-commant-face
  '((((class color) (background light)) (:foreground "Firebrick"))
    (((class color) (background dark)) (:foreground "OrangeRed"))
    (t (:bold t :italic t)))
  "コメントのface."
  :group 'ndiary-mode)
(defvar ndiary-comment-face 'ndiary-comment-face)
(defface ndiary-tag-face
  '((((class color) (background light)) (:foreground "Purple"))
    (((class color) (background dark)) (:foreground "Cyan"))
    (t (:bold t)))
  "HTMLのタグ(らしきもの)のface."
  :group 'ndiary-mode)
(defvar ndiary-tag-face 'ndiary-tag-face)
(defface ndiary-emphasis-face
  '((((class color) (background light)) (:foreground "Blue" :bold t))
    (((class color) (background dark)) (:foreground "Yellow" :bold t))
    (t (:bold t)))
  "強調系のface."
  :group 'ndiary-mode)
(defvar ndiary-emphasis-face 'ndiary-emphasis-face)

;; 変数
(defgroup ndiary-mode nil "Top of ndiary-mode customization group."
  :group 'hypermedia)
(defcustom ndiary-log-directory "~/diary/log"
  "日記の置いてあるディレクトリ."
  :type 'directory
  :group 'ndiary-mode)
(defcustom ndiary-latest-filename "~/public_html/d/index.html"
  "「最近の日記のダイジェスト」のファイル名."
  :type 'file
  :group 'ndiary-mode)
(defcustom ndiary-split-month t
  "月毎にdiaryファイルを作成するディレクトリを分けるか否か."
  :type 'boolean
  :group 'ndiary-mode)
(defcustom ndiary-yesterday-time 2
  "この時間(hour)を超えるまでは前日としてdiaryファイルを作成/取りあつかう."
  :type 'number
  :group 'ndiary-mode)
(defcustom ndiary-diary-file-coding-system 'sjis-unix
  "ndiary-modeで新規作成するdiaryファイルのcoding-system."
  :type 'sexp
  :group 'ndiary-mode)
(defcustom ndiary-mode-abbrev-table nil
  "ndiary-modeで使われるabbrev table."
  :type 'boolean
  :group 'ndiary-mode)
(defcustom ndiary-diary-command "diary"
  "日記生成用のコマンド. Emacsが実行可能なファイルである必要がある."
  :type 'filename
  :group 'ndiary-mode)
(defcustom ndiary-diary-command-option ""
  "日記生成用のコマンドのオプション."
  :type 'string
  :group 'ndiary-mode)
(defcustom ndiary-upload-command nil
  "日記アップロード用のコマンド. Emacsが実行可能ファイルである必要がある."
  :type 'filename
  :group 'ndiary-mode)
(defcustom ndiary-upload-command-option ""
  "日記アップロード用のコマンドのオプション."
  :type 'string
  :group 'ndiary-mode)
(defcustom ndiary-font-lock-keywords
  '(("\\(^■\\|^○\\|^◎\\|^□\\|^◇\\|^◆\
\\|^△\\|^▲\\|^▽\\|^▼\\|^☆\\|^★\\)\\(.*\\)"
     (1 ndiary-topic-head-face)
     (2 ndiary-topic-body-face))
    ("^\\(・\\)\\(.*\\)$"
     (1 ndiary-item-head-face)
     (2 ndiary-item-body-face))
    ("^\\(\\(Code:\\|Quote:\\)\\( -.*\\)?\\|^<<\\)$"
     (0 ndiary-code-face))
    ("\\((\\*[^)]*)\\|((-.*-))\\)"
     (0 ndiary-comment-face))
    ("<[^>]*>"
     (0 ndiary-tag-face)))
  "ndiary-mode用のfont-lock-keywords."
  :type 'sexp	; 手抜き…。
  :group 'ndiary-mode)
(defcustom ndiary-entity-reference-chars-alist
  '((?> . "gt") (?< . "lt") (?& . "amp") (?\" . "quot"))
  "ndiary-insert-amps用の変換テーブル"
  :type 'sexp
  :group 'ndiary-mode)
(defcustom ndiary-insert-amps-enable t
  "ndiary-insert-ampsを有効にするか否か"
  :type 'boolean
  :group 'ndiary-mode)
(defvar ndiary-file-name nil
  "現在編集中の.diaryファイルのフルパス名を格納する. ")
(defvar ndiary-buffer nil
  "現在編集中の.diaryファイルのバッファを格納する. ")

;; hooks
(defcustom ndiary-mode-load-hook nil nil
  :type 'hook
  :group 'ndiary-mode)
(defcustom ndiary-edit-hook nil	nil
  :type 'hook
  :group 'ndiary-mode)
(defcustom ndiary-pre-compile-hook nil
  "日記ファイルを作成する前に実行されるhook.
text-adjustの用なテキスト整形用Lispパッケージを使うのに使う."
  :type 'hook
  :group 'ndiary-mode)
(defcustom ndiary-aft-compile-hook nil
  "日記ファイルを作成した後に実行されるhook."
  :type 'hook
  :group 'ndiary-mode)
(defcustom ndiary-pre-upload-hook nil nil
  :type 'hook
  :group 'ndiary-mode)
(defcustom ndiary-aft-upload-hook nil nil
  :type 'hook
  :group 'ndiary-mode)
(defcustom ndiary-preview-hook nil nil
  :type 'hook
  :group 'ndiary-mode)

(defun ndiary-mode ()
  "nDiaryで使用する.diaryファイルを編集するためのMajor mode.
private-abbrev-tableと、以下のキーバインドを提供します:

\\[ndiary-compile]\t日記を生成するコマンドを呼び出す.
\\[ndiary-encode-region]\tregion内の\"<, >, &\"を、それぞれ\"&lt; &gt; &amp;\"にエンコードする.
\\[ndiary-upload]\t日記をアップロードするコマンドを呼び出す.
\\[ndiary-preview]\tbrowse-urlを使って日記をpreviewする."
  (interactive)
  (kill-all-local-variables)
  (setq mode-name "nDiary")
  (setq major-mode 'ndiary-mode)
  (make-local-variable 'font-lock-keywords-only)
  (setq font-lock-keywords-only t)
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '(ndiary-font-lock-keywords))
  (setq buffer-file-coding-system ndiary-diary-file-coding-system)
  (setq local-abbrev-table ndiary-mode-abbrev-table)
  (abbrev-mode t)
  (local-set-key "\C-c\C-c" 'ndiary-compile)
  (local-set-key "\C-ce" 'ndiary-encode-region)
  (local-set-key "\C-cu" 'ndiary-upload)
  (local-set-key "\C-cp" 'ndiary-preview)
  (local-set-key "&" 'ndiary-insert-amps)
  (run-hooks 'ndiary-mode-hook))

(defun ndiary-encode-region ()		; < > &
  "リージョン内の\"<, >, &\"を、\
それぞれ\"&lt; &gt; &amp;\"にエンコードします."
  (interactive)
  (let (end-point (head-pointp (< (point) (mark))))
    (or head-pointp (exchange-point-and-mark))
    (save-excursion
      (while (re-search-forward "[<>&]" (mark) t)
	(let (tl)
	  (setq tl (buffer-substring (match-beginning 0) (match-end 0)))
	  (cond ((string= tl "<") (replace-match "&lt;"))
		((string= tl ">") (replace-match "&gt;"))
		((string= tl "&") (replace-match "&amp;"))))))))

(defun ndiary-edit-internal (time)
  "timeで示される日付の日記ファイルを編集する."
  (let (dir)
    ;; ndiary-log-directoryがアクセス不能ならおしまい
    (if (not (file-accessible-directory-p ndiary-log-directory))
	(error "ndiary-log-directoryの設定が正しくないと思われます."))

    ;; 日記のファイル名を決定する
    (cond
     ((eq ndiary-split-month t)
      (setq dir (expand-file-name
		 (format-time-string "%Y/%m" time) ndiary-log-directory))
      (if (not (file-accessible-directory-p dir))
	  (make-directory dir t)))
     (t
      (setq dir ndiary-log-directory)))

    ;; バッファを作る
    (setq ndiary-file-name (expand-file-name 
			    (format-time-string "%Y%m%d.diary" time) dir))
    (setq ndiary-buffer (find-file ndiary-file-name)))
  (run-hooks 'ndiary-edit-hook))

(defun ndiary-edit (arg)
  "日記ファイルを編集する."
  (interactive "P")
  (let ((now (current-time)) (days 0) dateh datel daysec daysh daysl dir)
    ;; "今日"の日付の計算
    ;; ・hourがndiary-yesterday-time以前であれば1日前にずらす
    ;; ・引数あり呼出ならpromptを出し、入力された数値だけ「今」からずらす
    (if arg
	(setq days (floor (string-to-number
			   (read-from-minibuffer "offset: ")))))
    (setq daysec (* -1.0 days 60 60 24))
    (setq daysh (floor (/ daysec 65536.0)))
    (setq daysl (round (- daysec (* daysh 65536.0))))
    (setq dateh (- (nth 0 now) daysh))
    (setq datel (- (nth 1 now) (* ndiary-yesterday-time 3600) daysl))
    (if (< datel 0)
	(progn
	  (setq datel (+ datel 65536))
	  (setq dateh (1- dateh))))
    (if (< dateh 0)
	(setq dateh 0))
    (setq now (list dateh datel))
    (ndiary-edit-internal now)))

(defun ndiary-compile (arg)
  "日記生成コマンドを発行してhtmlファイルを生成する. 
C-u ndiary-compile とすると diary に与えるオプションを指定できる."
  (interactive "P")
  (let ((com ndiary-diary-command)
	(opt ndiary-diary-command-option))
    (run-hooks 'ndiary-pre-compile-hook)
    (ndiary-save-buffers)    ;; 実行前にndiary関連バッファを全てセーブする。
    (if (not (exec-installed-p ndiary-diary-command))
	(error "ndiary-diary-commandが正しく設定されていないようです."))
    (if arg
	(setq com (read-from-minibuffer "diary command: " com)
	      opt (read-from-minibuffer "diary command option: " opt)))
    (save-excursion
      (set-buffer (get-buffer-create "*ndiary-compile*"))
      (if (get-process "ndiary-compile")
	  (progn
	    (delete-process "ndiary-compile")))
      (erase-buffer)
      (apply (function start-process)
	     "ndiary-compile" "*ndiary-compile*" com (split-string opt))
      (display-buffer "*ndiary-compile*"))
    (run-hooks 'ndiary-aft-compile-hook)))

(defun ndiary-upload (arg)
  "upload用コマンド(sitecopy等)を発行して日記をuploadする."
  (interactive "P")
  (let ((com ndiary-upload-command)
	(opt ndiary-upload-command-option))
    (run-hooks 'ndiary-pre-upload-hook)
    (if (not (exec-installed-p com))
	(error "ndiary-upload-commandが正しく設定されていないようです."))
    (if arg
	(setq com (read-from-minibuffer "upload command: " com)
	      opt (read-from-minibuffer "upload command option: " opt)))
    (save-excursion
      (set-buffer (get-buffer-create "*ndiary-upload*"))
      (erase-buffer)
      (display-buffer "*ndiary-upload*"))
      (apply (function call-process)
	     com nil "*ndiary-upload*" t (split-string opt))
    (run-hooks 'ndiary-aft-upload-hook)))

(defun ndiary-preview (arg)
  "latest diary fileをpreviewする."
  (interactive "P")
  (let ((filename ndiary-latest-filename))
    (run-hooks 'ndiary-preview-hook)
    (if arg
	(setq filename (read-from-minibuffer "preview file: "
					     ndiary-latest-filename)))
    (setq filename (expand-file-name filename))
    (if (file-readable-p filename)
	(browse-url-of-file filename)
      (error "指定されたファイルは存在しないようです."))))

(defun ndiary-save-buffers ()
  "Save buffers whose major-mode is equal to current major-mode."
  (basic-save-buffer)
  (let ((cmm 'ndiary-mode))
    (save-excursion
      (mapcar '(lambda (buf)
		 (set-buffer buf)
		 (if (and (buffer-file-name buf)
			  (eq major-mode cmm)
			  (buffer-modified-p buf)
			  (y-or-n-p (format "Save %s" (buffer-name buf))))
		     (save-buffer buf)))
	      (buffer-list)))))

(defun ndiary-insert-amps-internal (args)
  (interactive "P")
  (let* ((mess "") c
	 (list ndiary-entity-reference-chars-alist) (l list))
    (while l
      (setq mess (format "%s %c" mess (car (car l)) (cdr (car l)))
			l (cdr l)))
    (message "Char-entity reference:  %s  SPC=& RET=&; Other=&#..;" mess)
    (setq c (read-char))
    (cond
     ((equal c (car-safe (assoc c list)))
      (insert (format "&%s;" (cdr (assoc c list)))))
     ((or (equal c ?\n) (equal c ?\r))
      (insert "&;")
      (forward-char -1))
     ((equal c ? )
      (insert ?&))
     (t (insert (format "&#%d;" c))))))

(defun ndiary-insert-amps (args)
  (interactive "P")
  "Insert char-entity references via ampersand"
  (if ndiary-insert-amps-enable
      (ndiary-insert-amps-internal args)
    (self-insert-command (prefix-numeric-value args))))

(defun ndiary-toggle-insert-amps ()
  "&入力でndiary-insert-ampsを呼ぶか否かを切りかえる."
  (interactive)
  (setq ndiary-insert-amps-enable (not ndiary-insert-amps-enable)))

(setq auto-mode-alist
      (modify-alist '(("\\.diary\\'" . ndiary-mode))
		    auto-mode-alist))
(run-hooks 'ndiary-mode-load-hook)

(provide 'ndiary-mode)
