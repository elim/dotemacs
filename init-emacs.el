;-*- emacs-lisp -*-
; $Id$
(setq custom-file
      (expand-file-name "~/lib/site-lisp/customize.el"))

;; 必ず最初に読み込む
(load "eval-safe.el")

;; 無いと困る
(eval-safe (load "autoload-if-found.el"))
(eval-safe (load "auto-save-buffers.el"))

(eval-safe (load "completions-highlight.el"))
(eval-safe (load "make-file-executable.el"))

(eval-safe (load "init-emacs-cvs.el"))

(eval-safe (load "init-auto-save-buffers.el"))
(eval-safe (load "init-browse-url.el"))
(eval-safe (load "init-browse-kill-ring.el"))
(eval-safe (load "init-color.el"))
(eval-safe (load "init-css-mode.el"))
(eval-safe (load "init-ddskk.el"))
(eval-safe (load "init-develock.el"))
(eval-safe (load "init-dired-mode.el"))
(eval-safe (load "init-elscreen.el"))
(eval-safe (load "init-fonts.el"))
(eval-safe (load "init-howm.el"))
(eval-safe (load "init-html-helper-mode.el"))
(eval-safe (load "init-iswitchb.el"))
(eval-safe (load "init-japanese.el"))
(eval-safe (load "init-liece.el"))
(eval-safe (load "init-lookup.el"))
(eval-safe (load "init-navi2ch.el"))
(eval-safe (load "init-misc.el"))
(eval-safe (load "init-mpg123.el"))
(eval-safe (load "init-mwheel.el"))
(eval-safe (load "init-outline-mode.el"))
(eval-safe (load "init-pukiwiki-mode.el"))
(eval-safe (load "init-riece.el"))
(eval-safe (load "init-ruby.el"))
(eval-safe (load "init-shimbun.el"))
(eval-safe (load "init-tdiary-mode.el"))
(eval-safe (load "init-tiarra-conf.el"))
(eval-safe (load "init-tramp.el"))
(eval-safe (load "init-w3m.el"))
(eval-safe (load "init-wget.el"))
(eval-safe (load "init-wl.el"))