;;; init.el --- A setting of my own Emacs.
;;; Commentary:
;;; Code:

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

;;; el-get
;;
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(let (el-get-master-branch)
  (unless (require 'el-get nil t)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
      (goto-char (point-max))
      (eval-print-last-sexp))))

(setq el-get-user-package-directory
      (locate-user-emacs-file "config/packages"))

;; Preferred libraries
(el-get-bundle tarao/with-eval-after-load-feature-el)
(el-get-bundle use-package :depends (delight))

(load "environment")
(load "builtins")
(load "packages")
(load "theme")
(load "local" t)

;;; init.el ends here
