;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(defun boolize (elem) (not (not elem)))

(setq darwin-p  (boolize (string-match "darwin" (version)))
      carbon-p  (eq window-system 'mac)
      linux-p   (boolize (string-match "linux" (version)))
      colinux-p (and linux-p
                     (boolize
                      (with-temp-buffer
                        (insert-file-contents "/proc/modules")
                        (goto-char (point-min))
                        (re-search-forward "^cofuse\.+" nil t))))
      cygwin-p  (boolize (string-match "cygwin" (version)))
      meadow-p  (featurep 'meadow)
      windows-p (or cygwin-p meadow-p))

;; provisional measures for cygwin $PWD environment variable and Meadow.
(when (and meadow-p (not (file-directory-p default-directory)))
  (setq default-directory (getenv "HOME")))

;; path and filenames.
(setq base-directory "~/.emacs.d"
      preferences-directory "~/.emacs.d"
      libraries-directory (expand-file-name "library" base-directory)

      custom-file
      (expand-file-name "customize.el" base-directory))

(defun merge-path-without-duplicate (&rest path)
  (let (lst)
    (mapc '(lambda (seq)
             (setq lst (append lst seq)))
          (mapcar '(lambda (p)
                     (cond
                      ((listp p) p)
                      ((stringp p) (list p))
                      (t nil)))
                  path))
    (mapc '(lambda (seq)
             (setq lst
                   (cond
                    ((file-accessible-directory-p seq)
                     (cons seq (remove seq lst)))
                    (t
                     (remove seq lst)))))
          (reverse (remove nil lst)))
    lst))

(setq load-path
      (merge-path-without-duplicate
       load-path
       (list base-directory
             preferences-directory
             libraries-directory
             "/usr/local/share/emacs/site-lisp/")))

(setq exec-path
      (merge-path-without-duplicate
       exec-path
       (list "~/bin"
             "/bin/"
             "/sbin/"
             "/usr/bin/"
             "/usr/sbin/"
             "/usr/local/bin"
             "/usr/local/sbin"
             "/opt/local/bin"
             "/opt/local/sbin"
             "/sw/bin"
             "/sw/sbin/"
             "/Developer/Tools"
             "c:/cygwin/usr/bin"
             "c:/cygwin/usr/sbin"
             "c:/cygwin/usr/local/bin"
             "c:/cygwin/usr/local/sbin"
             "/usr/games"
             "/usr/X11R6/bin"
             "c:/program files/mozilla firefox")))

(setq Info-additional-directory-list
      (merge-path-without-duplicate
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

    (mapc #'(lambda (file)
              (when (load file nil t)
                (message "`%s' loaded." file))) files)))


;; load essential libraries.
(load-directory-files libraries-directory "^.+el$")

;; load preferences.
(load-directory-files preferences-directory "^init-.+el$")
