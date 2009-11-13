;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (autoload-if-found 'html-helper-mode "html-helper-mode" "Yay HTML" t)
  (setq html-helper-new-buffer-template nil
        html-helper-do-write-file-hooks t
        html-helper-build-new-buffer nil
        html-helper-basic-offset 1
        html-helper-item-continue-indent 2
        html-helper-address-string user-mail-address
        html-helper-verbose nil
  auto-mode-alist
   (cons '("\\.html$" . html-helper-mode) auto-mode-alist)))
