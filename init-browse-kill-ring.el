;-*- emacs-lisp -*-
; $Id$
(eval-safe
 (progn
   (require 'browse-kill-ring)
   (define-key ctl-x-map "\C-y" 'browse-kill-ring)
   (setq
    ;; kill-ring の表示形式
    ; browse-kill-ring-display-style 'one-line
    browse-kill-ring-display-style 'separated

    ;; browse-kill-ring 終了時にバッファを kill する
    browse-kill-ring-quit-action 'kill-and-delete-window

    ;; 必要に応じて browse-kill-ring のウィンドウの大きさを変更する
    browse-kill-ring-resize-window t

    ;; kill-ring の内容を表示する際の区切りを指定する
    browse-kill-ring-separator "-------"

    ;; 現在選択中の kill-ring のハイライトする
    browse-kill-ring-highlight-current-entry t

    ;; 区切り文字のフェイスを指定する
    browse-kill-ring-separator-face 'region

    ;; 一覧で表示する文字数を指定する． nil ならすべて表示される．
    browse-kill-ring-maximum-display-length 100)
