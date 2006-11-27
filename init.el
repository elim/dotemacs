;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

;; variables
(setq my-lisp-path (expand-file-name "~/.emacs.d/"))
(setq my-domestic-domain "fascinating.local$")

(setq load-path
      (append
       (list (expand-file-name my-lisp-path))
       (when (file-accessible-directory-p "/usr/local/share/emacs/site-lisp/")
	   (list (expand-file-name "/usr/local/share/emacs/site-lisp/")))
       load-path))

(setq exec-path
      (append
       (when (file-accessible-directory-p "/sw/bin")
	 (list (expand-file-name "/sw/bin")))
       (when (file-accessible-directory-p "/sw/sbin")
	 (list (expand-file-name "/sw/sbin")))
       exec-path))

(setq custom-file
      (expand-file-name (concat my-lisp-path "/customize.el")))

;; load libraries
(load "eval-safe.el")
(load "autoload-if-found.el")
(load "auto-save-buffers.el")
(load "completions-highlight.el")
(load "make-file-executable.el")

;; load initial settings
(load "init-auto-save-buffers.el")
(load "init-browse-url.el")
(load "init-browse-kill-ring.el")
(load "init-css-mode.el")
(load "init-ddskk.el")
(load "init-develock.el")
(load "init-dired-mode.el")
(load "init-elscreen.el")
(load "init-fonts.el")
(load "init-frame.el")
(load "init-howm.el")
(load "init-html-helper-mode.el")
(load "init-iswitchb.el")
(load "init-language.el")
(load "init-lookup.el")
(load "init-navi2ch.el")
(load "init-misc.el")
(load "init-mmm-mode.el")
(load "init-mpg123.el")
(load "init-mwheel.el")
(load "init-outline-mode.el")
(load "init-psvn.el")
(load "init-pukiwiki-mode.el")
(load "init-riece.el")
(load "init-ruby.el")
(load "init-session.el")
(load "init-server.el")
(load "init-shimbun.el")
(load "init-tdiary-mode.el")
(load "init-tiarra-conf.el")
(load "init-tramp.el")
(load "init-w3m.el")
(load "init-wget.el")
(load "init-wl.el")

(when (functionp 'howm-menu)
  (howm-menu))
