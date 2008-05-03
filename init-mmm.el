;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$;

(when (require 'mmm-mode nil t)
  (setq mmm-global-mode 'maybe
	mmm-submode-decoration-level 2)

  ;(invert-face 'mmm-default-submode-face)

  ;(set-face-bold-p 'mmm-default-submode-face t)
  ;(set-face-background 'mmm-default-submode-face "White")

  (mapc
    '(lambda (arg)
       (set-face-background arg nil))
    '(mmm-default-submode-face
      mmm-cleanup-submode-face
      mmm-code-submode-face
      mmm-comment-submode-face
      mmm-declaration-submode-face
      mmm-init-submode-face
      mmm-output-submode-face
      mmm-special-submode-face))

  ;; eRuby
  (mmm-add-mode-ext-class nil "\\.erb?\\'" 'html-erb)
  (mmm-add-mode-ext-class nil "\\.rhtml" 'html-erb)
  (mmm-add-classes
   '((html-erb
      :submode ruby-mode
      :match-face (("<%#" . mmm-comment-submode-face)
		   ("<%=" . mmm-output-submode-face)
		   ("<%" . mmm-code-submode-face))
      :front "<%[#=]?"
      :back "%>")))
  (add-to-list 'auto-mode-alist '("\\.erb?\\'" . html-mode))
  (add-to-list 'auto-mode-alist '("\\.rhtml" . html-mode)))
