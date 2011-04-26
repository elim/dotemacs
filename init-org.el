;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

;; http://orgmode.org/worg/org-tutorials/orgtutorial_dto.Php
(when (require 'org-install  nil t)
  (setq org-log-done t
        org-special-ctrl-a/e t
        org-return-follows-link t
        org-tab-follows-link t
        org-agenda-files (list
                          "~/Dropbox/org/diary.org"
                          "~/Dropbox/org/dreams.org"
                          "~/Dropbox/org/kai.org"
                          "~/Dropbox/org/memo.org"
                          "~/Dropbox/org/tasks.org"))


  (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

  (global-set-key  [(control c)(l)] 'org-store-link)
  (global-set-key  [(control c)(a)] 'org-agenda)
  (global-set-key  [(control c)(b)] 'org-iswitchb)

  (eval-after-load "org"
    '(progn
       (define-key org-mode-map [(meta control f)] 'org-metaright)
       (define-key org-mode-map [(meta control b)] 'org-metaleft)
       (define-key org-mode-map [(control c)(d)] 'org-insert-timestamp-for-log)))

  (defun org-insert-timestamp-for-log ()
    (interactive)
    (org-insert-heading)
    (insert (format-time-string "%H:%M:%S"))))