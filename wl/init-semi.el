;; -*- emacs-lisp -*-
;; $Id$

;; HTML パートを表示するか
;; mime-setup がロードされる前に記述する必要があります。
(setq mime-setup-enable-inline-html nil)

;; 大きいメッセージを送信時に分割するか
(setq mime-edit-split-message nil)

;; 大きいメッセージとみなす行数の設定
;(setq mime-edit-message-default-max-lines 1000)