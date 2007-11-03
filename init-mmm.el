;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$;

(when (locate-library "mmm-mode")
  (require 'mmm-mode)
  ;;(setq mmm-global-mode t)
  (setq mmm-global-mode 'maybe)

  ;; mmm-modeをカラフルに
  (setq mmm-submode-decoration-level 2)
  
  ;; mmm-modeの前景色と背景色を入れ換える。
  ;;(invert-face 'mmm-default-submode-face)

  ;; mmm-modeのフェイスを変更
  ;;(set-face-bold-p 'mmm-default-submode-face t)
  ;;(set-face-background 'mmm-default-submode-face "White")

  ;; 背景を無くする
  (progn
    (set-face-background 'mmm-default-submode-face nil)
    (set-face-background 'mmm-cleanup-submode-face nil)
    (set-face-background 'mmm-code-submode-face nil)
    (set-face-background 'mmm-comment-submode-face nil)
    (set-face-background 'mmm-declaration-submode-face nil)
    (set-face-background 'mmm-init-submode-face nil)
    (set-face-background 'mmm-output-submode-face nil)
    (set-face-background 'mmm-special-submode-face nil))
  
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
