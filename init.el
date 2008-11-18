;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

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
(setq base-directory "~/.emacs.d"
      preferences-directory "~/.emacs.d"
      libraries-directory (expand-file-name "library" base-directory)

      custom-file
      (expand-file-name "customize.el" base-directory))

(defun merge-path-list (init lis)
  (fold-right (lambda (x y)
          (let ((expanded-name (expand-file-name x)))
            (if (file-accessible-directory-p x)
                (append (list expanded-name)
                        (delete x (delete expanded-name y)))
              y)))
        init lis))

(setq load-path
      (merge-path-list
       load-path
       (list base-directory
             preferences-directory
             libraries-directory
             "/usr/local/share/emacs/site-lisp/")))

(setq exec-path
      (merge-path-list
       exec-path
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
             "c:/program files/mozilla firefox")))

(setq Info-additional-directory-list
      (merge-path-list
       nil
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

;; load essential libraries.
(load-directory-files libraries-directory "^.+el$")

;; load preferences.
(load-directory-files preferences-directory "^init-.+el$")
