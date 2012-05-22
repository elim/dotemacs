;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (require 'php-mode nil t)
  (add-hook 'php-mode-hook #'php-mode-hook)

  (setq auto-mode-alist
        (append
         '(("/\\(PEAR\\|pear\\)/" . php-mode)
           ("\.php$" . php-mode))
         auto-mode-alist))

  (defun php-mode-hook ()
    ;; c-mode のスタイル (コメントアウトした場合 "gnu")
    ;; (c-set-style "bsd")
    (c-set-style "stroustrup")

    ;; 連続する空白の一括削除 (必要なければコメントアウトする)
    (c-toggle-hungry-state t)

    ;; コメント行のインデント (必要なければコメントアウトする)
    (setq c-comment-only-line-offset 0)

    ;; コメントのスタイル (必要なければコメントアウトする)
    (setq comment-start "// "
          comment-end   ""
          comment-start-skip "// *")

    ;; 勝手に改行モード (必要なければコメントアウトする)
    (c-toggle-auto-hungry-state nil)

    (setq c-hanging-braces-alist
          '(
            (class-open nil)
            (class-close nil)
            (defun-open before after)
            (defun-close nil)
            (inline-open nil)
            (inline-close nil)
            (brace-list-open nil)
            (brace-list-close nil)
            (block-open nil)
            (block-close nil)
            (substatement-open before after)
            (statement-case-open before after)
            (extern-lang-open nil)
            (extern-lang-close nil)
            php-mode-force-pear t
            tab-width 4
            c-basic-offset 4
            c-hanging-comment-ender-p nil
            indent-tabs-mode nil))))
