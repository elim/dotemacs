;;; init.el --- A setting of my own Emacs.
;;; Commentary:
;;; Code:

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(setq load-prefer-newer t)

(setq user-full-name "Takeru Naito"
      user-mail-address "takeru.naito@gmail.com")

;; Common Lisp extensions for Emacs(use it anyway).
(require 'cl)

(defun flatten (lis)
  "Removes nestings from a list."
  (cond ((atom lis) lis)
        ((listp (car lis))
         (append (flatten (car lis)) (flatten (cdr lis))))
        (t (append (list (car lis)) (flatten (cdr lis))))))

(defun fold-right (proc init lis)
  (if lis
      (funcall proc (car lis) (fold-right proc init (cdr lis))) init))

(defun fold-left (proc init lis)
  (if lis (fold-left proc (funcall proc init (car lis)) (cdr lis)) init))

(defalias 'fold 'fold-left)

(defun sort-lines-nocase ()
  (interactive)
  (let ((sort-fold-case t))
    (call-interactively 'sort-lines)))

;; system-type predicates
(setq darwin-p  (eq system-type 'darwin)
      ns-p      (featurep 'ns)
      linux-p   (eq system-type 'gnu/linux)
      cygwin-p  (eq system-type 'cygwin)
      nt-p      (eq system-type 'windows-nt)
      meadow-p  (featurep 'meadow)
      windows-p (or cygwin-p nt-p meadow-p))

;; provisional measures for cygwin $PWD environment variable on Meadow.
(when (and meadow-p (not (file-directory-p default-directory)))
  (setq default-directory (getenv "HOME")))

(setq custom-file (expand-file-name "customize.el" user-emacs-directory))
(load custom-file)

;; path and filenames.
(dolist (dir (list
              (expand-file-name "config" user-emacs-directory)
              "/usr/local/share/emacs/site-lisp/"))
  (when (and (file-exists-p dir) (not (member dir load-path)))
    (setq load-path (append (list dir) load-path))))

(dolist (dir (list
              "/sbin"
              "/usr/sbin"
              "/bin"
              "/usr/bin"
              "/usr/local/bin"
              (expand-file-name "~/bin")
              (expand-file-name "~/.rbenv/shims")))

  (when (and (file-exists-p dir) (not (member dir exec-path)))
    (setenv "PATH" (concat dir ":" (getenv "PATH")))
    (setq exec-path (append (list dir) exec-path))))

(when nt-p
  (setq explicit-shell-file-name
        (expand-file-name "cmdproxy" (getenv "EMACSPATH"))
        shell-file-name explicit-shell-file-name
        shell-command-switch "-c"
        ;; drive letter completion on shell-mode.
        shell-file-name-chars "~/A-Za-z0-9_^$!#%&{}@`'.,:()-"))

;; load essential libraries.

(load "environment")
(load "theme")
(load "builtins")
(load "packages")
(load "local" t)

(provide 'init)
;;; init.el ends here
