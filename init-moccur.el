;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: t -*-
;;; $Id$

;; based upon
;;  http://www.bookshelf.jp/cgi-bin/goto.cgi?file=meadow&node=exampleelisp+color-moccur

(setq moccur-split-word t
      moccur-use-migemo nil
      color-moccur-default-ime-status nil)

(mapc
 '(lambda (func)
    (autoload-if-found func "color-moccur" nil t))
 (list 'moccur-grep
       'moccur-grep-find
       'isearch-moccur
       'isearch-moccur-all
       'occur-by-moccur
       'moccur
       'dmoccur
       'dired-do-moccur
       'Buffer-menu-moccur
       'moccur-narrow-down
       'grep-buffers
       'search-buffers))

(eval-after-load "color-moccur"
  '(require 'moccur-edit))

(eval-after-load "ibuffer"
  '(require 'color-moccur))
(setq *moccur-buffer-name-exclusion-list*
      '(".+TAGS.+" "*Completions*" "*Messages*"
	"newsrc.eld"
	" *migemo*" ".bbdb"))

(add-hook 'dired-mode-hook
	  '(lambda ()
	     (local-set-key "O" 'dired-do-moccur)))

(define-key Buffer-menu-mode-map "O" 'Buffer-menu-moccur)
;;(global-set-key "\M-f" 'grep-buffers)
(global-set-key "\M-o" 'occur-by-moccur)
(global-set-key "\C-c\C-x\C-o" 'moccur)
;;(global-set-key "\C-c\C-o" 'search-buffers)
