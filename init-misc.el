;-*- emcs-lisp -*-

; Xでのカラー表示
(require 'font-lock)
(if (not (featurep 'xemacs))
    (global-font-lock-mode t)
)
;; goto-line
(global-set-key "\C-cg" 'goto-line)

;; Deleteキーでカーソル位置の文字が消えるようにする
(global-set-key [delete] 'delete-char)

;; C-h キーでカーソルの左の文字が消えるようにする。
(global-set-key "\C-h" 'backward-delete-char)

;;スクロールバーを右に。
(set-scroll-bar-mode 'right)

;; visible-bell
(setq visible-bell t)

;; 行番号を表示する
(line-number-mode t)

;; 桁番号を表示する
(column-number-mode t)

;; バッファの最後で newline で新規行を追加するのを禁止する
(setq next-line-add-newlines nil)

;; browse-url
(global-set-key [(hyper m)] 'browse-url-at-point)
(global-set-key "\C-xm" 'browse-url-at-point)

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; browse-kill-ring
;;
(define-key ctl-x-map "\C-y" 'browse-kill-ring)


(setq x-select-enable-clipboard t)