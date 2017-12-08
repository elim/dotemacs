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

(defun sort-lines-nocase ()
  (interactive)
  (let ((sort-fold-case t))
    (call-interactively 'sort-lines)))

(setq custom-file (expand-file-name "customize.el" user-emacs-directory))
(load custom-file)

;; path and filenames.
(dolist (dir (list
              (expand-file-name "config" user-emacs-directory)
              "/usr/local/share/emacs/site-lisp/"))
  (when (and (file-exists-p dir) (not (member dir load-path)))
    (setq load-path (append (list dir) load-path))))

;; load essential libraries.
(load "packages")
(load "environment")
(load "theme")
(load "builtins")
(load "local" t)

(provide 'init)
;;; init.el ends here
