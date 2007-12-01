;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

;; based upon
;; http://coderepos.org/share/wiki/SimpleHatenaMode

(when
    (require 'simple-hatena-mode nil t)

  (when (require 'hatenahelper-mode nil t)
    (add-hook 'simple-hatena-mode-hook
	      '(lambda ()
		 (hatenahelper-mode 1)))))

  ;; location of hatena diary writer (default: hw.pl)
  ;; (setq simple-hatena-bin "hw.pl")

  ;; data sotre directory (default: ~/.hatena)
  ;; (setq simple-hatena-root "~/.hatena")

  ;; default hatena ID (default: nil)
  ;; (setq simple-hatena-default-id "antipop")

  ;; default hatena group name (default: nil)
  ;; (setq simple-hatena-default-group "subtech")

  ;; user agent (default: simple-hatena-mode/version)
  ;; (setq simple-hatena-option-useragent "Hatena::Diary::Writer")

  ;; insert time stamp in a permanent link (default: t)
  ;; (setq simple-hatena-use-timestamp-permalink-flag nil)

  ;; 日付を計算する際に用いるオフセット。たとえば以下のように6に設定する
  ;; と、午前6時まで前日の日付として扱われる(デフォルト値: nil)
  ;; (setq simple-hatena-time-offset 6)

  ;; debug mode (default: nil)
  ;; (setq simple-hatena-option-debug-flag t)

  ;; timeout seconds (default: 30)
  ;; (setq simple-hatena-option-timeout 60)

  ;; use cookie (default: t)
  ;; (setq simple-hatena-option-cookie-flag "nil")

  ;; process buffer name (default:: *SimpleHatena*)
  ;; (setq simple-hatena-process-buffer-name "*OtherBufferName*")