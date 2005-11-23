;-*- emacs-lisp -*-
; $Id$


;; Xでのカラー表示
(require 'font-lock)
(if (not (featurep 'xemacs))
    (global-font-lock-mode t))

;; Mac 関係
;; http://pc7.2ch.net/test/read.cgi/mac/1084714251/175
;; > CarbonEmacsに限って言えば、mac-pass-control-to-system を nil に
;; > すれば AquaSKK の Ascii モードでも問題なく使えると思うよ。
(setq mac-pass-control-to-system nil)

;; goto-line
(global-set-key "\C-cg" 'goto-line)

;; Deleteキーでカーソル位置の文字が消えるようにする
(global-set-key [delete] 'delete-char)

;; C-h キーでカーソルの左の文字が消えるようにする。
;; (global-set-key "\C-h" 'backward-delete-char)

;; C-h を C-? (Backspace) にする. 
(keyboard-translate ?\C-h ?\C-?)
;; (global-set-key "\C-h" nil)

;;補完時に大文字と小文字を区別させない
(setq completion-ignore-case t)

;; ヘルプ等の window を可変にする
(temp-buffer-resize-mode 1)

;; visible-bell
(setq visible-bell t)

;; 行番号を表示する
(line-number-mode t)

;; 桁番号を表示する
(column-number-mode t)

;; メニューを消す
(menu-bar-mode -1)

;; ツールバーを消す
(tool-bar-mode -1)

;;スクロールバーを右に
(set-scroll-bar-mode 'right)

;; スクロールバーを消す
(scroll-bar-mode -1)

;; window system では行間を空ける
(setq-default line-spacing 2)

;; バッファの最後で newline で新規行を追加するのを禁止する
(setq next-line-add-newlines nil)

;; フレームタイトルを 「バッファ名 (フルパスのファイル名)」とする。
(setq frame-title-format
      `(" %b " (buffer-file-name "( %f )")))


;; サーバモードで動かす
(eval-safe (server-mode t))

;; 同一ファイル名のバッファ名を分かりやすく
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")
(setq uniquify-min-dir-content 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; grep-edit
;;
(require 'grep-edit)

;;kill-ring に同じ内容の文字列を複数入れない
(defadvice kill-new (before ys:no-kill-new-duplicates activate)
  (setq kill-ring (delete (ad-get-arg 0) kill-ring)))

(setq x-select-enable-clipboard t)