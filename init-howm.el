;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: t -*-
;; $Id$

(when (locate-library "howm")
  (setq howm-menu-lang 'en
	howm-list-all-title t
	howm-list-recent-title t
	howm-list-normalizer #'howm-view-sort-by-reverse-date
	howm-todo-menu-types "[-+~!]"
	howm-directory (expand-file-name "~/.howm/")
	howm-view-use-grep (not (not (locate-executable "grep"))))

  (global-set-key [(control c)(,)(,)] 'howm-menu)
  (global-set-key [(control c)(,)(d)] 'howm-diary-write)

  (mapc
   (lambda (f)
     (autoload f
       "howm" "Hitori Otegaru Wiki Modoki" t))
   '(howm-menu howm-list-all howm-list-recent
	       howm-list-grep howm-create
	       howm-keyword-to-kill-ring))

  (when (functionp #'elscreen-display-version)
    (defadvice howm-menu (before forced-elscreen-zero activate)
      (if (memq 0 (elscreen-get-screen-list))
	  (elscreen-goto 0)
	(elscreen-create))))

  (defun howm-diary-write (&optional offset)
    "The diary is written by using howm.
Diary buffer after the numelic day is generated with C-u numelic M-x.
Offset is demanded when calling with C-u M-x."
    (interactive "P")

    (let*
	((offset (cond
		  ((null offset) 0)
		  ((equal offset '(4))
		   (let ((result))
		     (while (not (integerp result))
		       (setq result
			     (read-from-minibuffer
			      "Date offset is: " nil nil t nil "0")))
		     result))
		  (t offset)))
	 (today (decode-time))
	 (date (encode-time (nth 0 today)
			    (nth 1 today)
			    (nth 2 today)
			    (+ (nth 3 today) offset)
			    (nth 4 today)
			    (nth 5 today)))
	 (diary-directory
	  (expand-file-name (format-time-string "%Y/%m/" date)
			    howm-directory))

	 (diary-file
	  (expand-file-name (downcase
			     (format-time-string "%Y-%m-%d-%a.howm" date))
			    diary-directory)))

      (unless (file-directory-p diary-directory)
	(make-directory diary-directory 'parents))

      (if (functionp #'elscreen-find-file)
	  (elscreen-find-file diary-file)
	(find-file diary-file))

      (howm-mode t)

      (if (file-exists-p diary-file)
	  (goto-char (point-max))
	(insert "= diary\n"))

      (insert (if (eq (current-column) 0) "" "\n")
	      (make-string 2 ?-) " \n"
	      (if (= offset 0)
		  (format-time-string "%H:%M" date) "")
	      "\n")))

  (when (member '("utf-8-unix") coding-system-alist)
    (mapc #'(lambda (arg)
	      (add-hook arg
			'(lambda ()
			   (setq buffer-file-coding-system 'utf-8-unix))))
	  (list 'howm-view-open-hook 'howm-create-file-hook)))

  ;; M-x calendar 上で選んだ日付けを [yyyy-mm-dd] で出力
  (eval-after-load "calendar"
    '(progn
       (define-key calendar-mode-map
	 "\C-m" 'my-insert-day)
       (defun my-insert-day ()
	 (interactive)
	 (let ((day nil)
	       (calendar-date-display-form
		'("[" year "-" (format "%02d" (string-to-int month))
		  "-" (format "%02d" (string-to-int day)) "]")))
	   (setq day (calendar-date-string
		      (calendar-cursor-to-date t)))
	   (exit-calendar)
	   (insert day))))))