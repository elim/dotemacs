;-*- emacs-lisp -*-
; $Id$
(setq custom-file
      (expand-file-name "~/lib/site-lisp/customize.el"))

(load "init-emacs-cvs.el")

(load "init-japanese.el")


(load "auto-save-buffers.el")
(load "completions-highlight.el")
(load "make-file-executable.el")

(load "init-auto-save-buffers.el")
(load "init-browse-url.el")
(load "init-css-mode.el")
(load "init-ddskk.el")
(load "init-develock.el")
(load "init-dired-mode.el")
(load "init-howm.el")
(load "init-html-helper-mode.el")
(load "init-liece.el")
(load "init-lookup.el")
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

(if (featurep 'meadow)
    (load "init-meadow.el")
  nil)

(load "init-color.el")
;(load "fontset-init.el")
;(load "ndiary-mode-init.el")
