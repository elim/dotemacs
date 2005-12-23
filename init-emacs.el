;-*- emacs-lisp -*-
; $Id$
(setq custom-file
      (expand-file-name "~/lib/site-lisp/customize.el"))

;; 必ず最初に読み込む
(load "eval-safe.el")

;; 無いと困る
(load "autoload-if-found.el")
(load "auto-save-buffers.el")

(load "completions-highlight.el")
(load "make-file-executable.el")

(load "init-emacs-cvs.el")

(load "init-auto-save-buffers.el")
(load "init-browse-url.el")
(load "init-browse-kill-ring.el")
(load "init-color.el")
(load "init-css-mode.el")
(load "init-develock.el")
(load "init-dired-mode.el")
(load "init-ddskk.el")
(load "init-elscreen.el")
(load "init-fonts.el")
(load "init-howm.el")
(load "init-html-helper-mode.el")
(load "init-iswitchb.el")
(load "init-japanese.el")
(load "init-liece.el")
(load "init-lookup.el")
(load "init-navi2ch.el")
(load "init-misc.el")
(load "init-mpg123.el")
(load "init-mwheel.el")
(load "init-outline-mode.el")
(load "init-pukiwiki-mode.el")
(load "init-riece.el")
(load "init-ruby.el")
(load "init-shimbun.el")
(load "init-tdiary-mode.el")
(load "init-tiarra-conf.el")
(load "init-tramp.el")
(load "init-w3m.el")
(load "init-wget.el")
(load "init-wl.el")

(eval-safe (howm-menu))
