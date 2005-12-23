;; -*- emacs-lisp -*-
;; $Id$

(when (locate-library "browse-kill-ring")
  (require 'browse-kill-ring)
  (define-key ctl-x-map "\C-y" 'browse-kill-ring)
  ;; browse-kill-ring-display-style 'one-line
  (setq browse-kill-ring-display-style 'separated)
  ;; browse-kill-ring 終了時にバッファを kill する
  (setq browse-kill-ring-quit-action 'kill-and-delete-window)
  ;; 必要に応じて browse-kill-ring のウィンドウの大きさを変更する
  (setq browse-kill-ring-resize-window t)
  ;; kill-ring の内容を表示する際の区切りを指定する
  (setq browse-kill-ring-separator "-------")
  ;; 現在選択中の kill-ring のハイライトする
  (setq browse-kill-ring-highlight-current-entry t)
  ;; 区切り文字のフェイスを指定する
  (setq browse-kill-ring-separator-face 'region)
  ;; 一覧で表示する文字数を指定する． nil ならすべて表示される．
  (setq browse-kill-ring-maximum-display-length 100))