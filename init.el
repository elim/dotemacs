;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(setq user-full-name "Takeru Naito"
      user-mail-address "takeru.naito@gmail.com")
      

;; Common Lisp extensions for Emacs(use it anyway).
(require 'cl)

;; functions
(defun x->bool (elt) (not (not elt)))

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

;; system-type predicates
(setq darwin-p  (eq system-type 'darwin)
      ns-p      (featurep 'ns)
      carbon-p  (eq window-system 'mac)
      linux-p   (eq system-type 'gnu/linux)
      colinux-p (when linux-p
                  (let ((file "/proc/modules"))
                    (and
                     (file-readable-p file)
                     (x->bool
                      (with-temp-buffer
                        (insert-file-contents file)
                        (goto-char (point-min))
                        (re-search-forward "^cofuse\.+" nil t))))))
      cygwin-p  (eq system-type 'cygwin)
      nt-p      (eq system-type 'windows-nt)
      meadow-p  (featurep 'meadow)
      windows-p (or cygwin-p nt-p meadow-p))

;; provisional measures for cygwin $PWD environment variable on Meadow.
(when (and meadow-p (not (file-directory-p default-directory)))
  (setq default-directory (getenv "HOME")))

;; path and filenames.
(when (> 23 emacs-major-version)
(setq user-emacs-directory "~/.emacs.d"))
(setq preferences-directory user-emacs-directory
      libraries-directory (expand-file-name "library" user-emacs-directory)

      custom-file
      (expand-file-name "customize.el" user-emacs-directory))

(defmacro set-path (list-var list)
  (list 'mapc `(lambda (x)
                 (when (file-accessible-directory-p x)
                   (add-to-list ',list-var x)))
        list))

(set-path load-path
          (list user-emacs-directory
                preferences-directory
                libraries-directory
               "/usr/local/share/emacs/site-lisp/"))

(set-path exec-path
          (list "~/bin"
                "/bin/"
                "/opt/local/bin"
                "/opt/local/sbin"
                "/sw/bin"
                "/sw/sbin/"
                "/usr/local/bin"
                "/usr/local/sbin"
                "/sbin/"
                "/usr/bin/"
                "/usr/sbin/"
                "/Developer/Tools"
                "c:/cygwin/usr/bin"
                "c:/cygwin/usr/sbin"
                "c:/cygwin/usr/local/bin"
                "c:/cygwin/usr/local/sbin"
                "/usr/games"
                "/usr/X11R6/bin"
                "c:/program files/mozilla firefox"))

(eval-after-load "info"
  '(set-path Info-additional-directory-list
             (list "/Applications/Emacs.app/Contents/Resources/info/"
                   "/opt/local/share/info"
                   "/sw/info"
                   "/sw/share/info"
                   "c:/cygwin/usr/share/info"
                   "c:/cygwin/usr/local/share/info")))

(defun load-directory-files (dir &optional regex)
  (let*
      ((regex (or regex ".+"))
       (files (and
               (file-accessible-directory-p dir)
               (directory-files dir 'full regex))))

    (mapc (lambda (file)
            (when (load file nil t)
              (message "`%s' loaded." file))) files)))

;; load auto-install.el.
(setq auto-install-directory
      (concat user-emacs-directory "auto-install/"))
(add-to-list 'load-path auto-install-directory)

(unless (locate-library "auto-install")
  (let
      ((url "http://www.emacswiki.org/emacs/download/auto-install.el")
       (path (expand-file-name "auto-install.el" auto-install-directory)))
    (cond
     ((executable-find "curl")
      (call-process "curl" nil nil nil "-o" path url))
     ((executable-find "wget")
      (call-process "wget" nil nil nil url "-O" path))
     (t nil))))

(and (require 'auto-install nil t)
     (auto-install-update-emacswiki-package-name t)
     (auto-install-compatibility-setup))


;; load essential libraries.
(load-directory-files libraries-directory "^.+el$")

;; load preferences.
(load-directory-files preferences-directory "^init-.+el$")

;;; 追加の設定
;; 標準Elispの設定
(load "config/builtins")
;; 非標準Elispの設定
(load "config/packages")
;; 個別の設定があったら読み込む
;; 2012-02-15
(load "config/local" t)
