;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

;; http://coderepos.org/share/wiki/SimpleHatenaMode
(when (require 'simple-hatena-mode nil t)
  (require 'calendar)
  (setq simple-hatena-root "~/.howm/hatena"
        simple-hatena-default-id "elim"
        simple-hatena-default-group "elim"
        simple-hatena-use-timestamp-permalink-flag nil
        simple-hatena-time-offset 6
        simple-hatena-option-debug-flag nil)

  (global-set-key [(control meta g)] 'simple-hatena-group)

  (defun simple-hatena-timestamp (&optional format)
    (and (boundp 'simple-hatena-local-current-buffer-year)
         (boundp 'simple-hatena-local-current-buffer-month)
         (boundp 'simple-hatena-local-current-buffer-day)
         (let*
             ((format (or format "<!-- %04d-%02d-%02d (%s) -->"))
              (year (string-to-number simple-hatena-local-current-buffer-year))
              (month (string-to-number simple-hatena-local-current-buffer-month))
              (day (string-to-number simple-hatena-local-current-buffer-day))
              (day-of-week (calendar-day-name (list month day year) 'abbrev)))

           (format format year month day day-of-week))))

  (defvar simple-hatena-delimiter "**-")
  (defun simple-hatena-delimiter (&optional delimiter)
    (setq simple-hatena-delimiter (or delimiter simple-hatena-delimiter)))

  (defadvice simple-hatena-internal-safe-find-file (after
                                                    insert-fixed-expression
                                                    activate)
    (goto-char (point-max))
    (insert
     (if (file-exists-p (buffer-file-name))
         (if (eq (current-column) 0) "" "\n")
       (format "\n%s\n\n" (simple-hatena-timestamp)))
     "\n" simple-hatena-delimiter "\n\n"))
     
  (defadvice simple-hatena-internal-safe-find-file (around
                                                    force-r/w-utf8 (filename)
                                                    activate)
    (let*
        ((coding-system 'utf-8-unix)
         (coding-system-for-read coding-system)
         (coding-system-for-write coding-system)
         (coding-system-require-warning t))
      ad-do-it))


  (defadvice html-helper-update-timestamp (around
                                           temporary-disable-html-helper-timestamp
                                           activate)
    (unless (equal major-mode 'simple-hatena-mode)
      ad-do-it))

  (let
      ((helper (or (require 'simple-hatenahelper-mode nil t)
                   (require 'hatenahelper-mode nil t))))

    (when helper
      (add-hook 'simple-hatena-mode-hook
                `(lambda ()
                   (,helper 1)))))

  (define-key simple-hatena-mode-map "\C-\M-b" 'simple-hatena-go-back)
  (define-key simple-hatena-mode-map "\C-\M-f" 'simple-hatena-go-forward))
