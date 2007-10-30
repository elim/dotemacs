;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when
    (require 'simple-hatena-mode nil t)

  ;; location of hatena diary writer (default: hw.pl)
  (setq simple-hatena-bin "~/bin/hw.pl")

;; data sotre directory (default: ~/.hatena)
;; 最後のスラッシュを入れないようにしてください。 (FIXME)
;; (setq simple-hatena-root "~/.mydiary")

;; default hatena ID (default: nil)
;;(setq simple-hatena-default-id "antipop")

;; default hatena group name (default: nil)
;;(setq simple-hatena-default-group "subtech")

;; user agent (default: simple-hatena-mode/version)
;; (setq simple-hatena-option-useragent "Hatena::Diary::Writer")

;; insert time stamp in a permanent link (default: t)
;; (setq simple-hatena-use-timestamp-permalink-flag nil)

;; 日付を計算する際に用いるオフセット。たとえば以下のように6に設定する
;; と、午前6時まで前日の日付として扱われる(デフォルト値: nil)
(setq simple-hatena-time-offset 6)

;; debug mode (default: nil)
;;(setq simple-hatena-option-debug-flag t)

;; timeout seconds (default: 30)
;; (setq simple-hatena-option-timeout "60")

;; use cookie (default: t)
(setq simple-hatena-option-cookie-flag "nil")

;; はてダラを実行するプロセスのバッファ名(デフォルト値: *SimpleHatena*)
(setq simple-hatena-process-buffer-name "*OtherBufferName*")
