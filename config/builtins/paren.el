;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

;; http://0xcc.net/unimag/10/

(use-package paren
  :config
  (show-paren-mode 1)

  ;; 小括弧 () の色を定義
  (defvar paren-face 'paren-face)
  (make-face 'paren-face)
  (set-face-foreground 'paren-face "#88aaff")

  ;; 中括弧 {} の色を定義
  (defvar brace-face 'brace-face)
  (make-face 'brace-face)
  (set-face-foreground 'brace-face "#ffaa88")

  ;; 大括弧 [] の色を定義
  (defvar bracket-face 'bracket-face)
  (make-face 'bracket-face)
  (set-face-foreground 'bracket-face "#aaaa00")

  ;; lisp-mode の色設定に追加
  (setq lisp-font-lock-keywords-2
        (append '(("(\\|)" . paren-face))
                lisp-font-lock-keywords-2))

  ;; scheme-mode の色設定に追加
  (add-hook 'scheme-mode-hook
            '(lambda ()
               (setq scheme-font-lock-keywords-2
                     (append '(("(\\|)" . paren-face))
                             scheme-font-lock-keywords-2))))

  ;; c-mode の色設定に追加
  (eval-after-load "cc-mode"
    '(setq c-font-lock-keywords-3
           (append '(("(\\|)" . paren-face))
                   '(("{\\|}" . brace-face))
                   '(("\\[\\|\\]" . bracket-face))
                   c-font-lock-keywords-3))))
