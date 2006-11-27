;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (locate-library "howm")
  (autoload 'howm-menu "howm" "Hitori Otegaru Wiki Modoki" t)
  (global-set-key "\C-c,," 'howm-menu)
  (setq  howm-menu-lang 'ja)
  ;; 「最近のメモ」一覧時にタイトル表示
  (setq howm-list-recent-title t)
  ;; 全メモ一覧時にタイトル表示
  (setq howm-list-all-title t)
  ;; 日付の新しい順
  (setq howm-list-normalizer 'howm-view-sort-by-reverse-date)
  (setq howm-todo-menu-types "[-+~!]")

  (define-key howm-mode-map
    "\C-c;" 'howm-insert-dtime)

  (if (or (locate-library "grep" nil exec-path)
	  (locate-library "grep.exe" nil exec-path))
      (setq howm-view-use-grep t)
    (setq howm-view-use-grep nil))

  ;; howm-menu は 常に screen 0 で表示
  (when (functionp 'elscreen-jump-0)
    (eval-after-load "howm-menu"
      '(progn
	 (defun my-howm-menu ()
	   (interactive)
	   (unless (elscreen-jump-0)
	     (progn
	       (elscreen-create)
	       (elscreen-jump-0)))
	   (delete-other-windows)
	   (howm-menu))
	 (global-set-key "\C-c,," 'my-howm-menu))))
        
  ;; 日記を書く
  (defun my-howm-diary-edit (&optional my-diary-date-offset)
    "The diary is written by using howm.
Diary buffer after the numelic day is generated with C-u numelic M-x.
Offset is demanded when calling with C-u M-x."
    (interactive "P")
    (when (equal my-diary-date-offset '(4)) ;; C-u M-x で呼ばれたなら
      (while (not (number-or-marker-p       ;; 数値を要求する
		   (setq my-diary-date-offset
			 (read-from-minibuffer
			  "Date offset is: " nil nil t nil "0"))))))
    (let*
     ((my-diary-time
       (if (not (number-or-marker-p my-diary-date-offset))
	   (current-time)
	 (apply 'encode-time
		   (nconc
		    (list
		     (nth 0 (decode-time))
		     (nth 1 (decode-time))
		     (nth 2 (decode-time))
		     (+ (nth 3 (decode-time)) my-diary-date-offset))
		    (nthcdr 4 (decode-time))))))
	 (my-diary-directory
	  (concat howm-directory
		  (format-time-string "%Y/%m" my-diary-time)))
	 (my-diary-file
	  (concat my-diary-directory
		  (downcase
		   (format-time-string "/%Y-%m-%d-%a.howm" my-diary-time)))))

      (when (not (file-exists-p my-diary-directory))
	(make-directory my-diary-directory))

      (if (functionp 'elscreen-find-file)
	  (elscreen-find-file my-diary-file)
	(find-file my-diary-file))

      (when (not (file-exists-p my-diary-file))
	(insert "= diary\n"))
      (goto-char (point-max))
      (howm-mode t)))

  (eval-after-load "howm-mode"
    '(progn
       ;; howm-insert-date を上書き.
       ;; howm-insert-dtime を使って下さい.
       (define-key howm-mode-map
	 "\C-c,d" 'my-howm-diary-edit)
       (global-set-key
	"\C-c,d" 'my-howm-diary-edit)))

  ;; utf-8-unix を選択できるのなら強制する
  (let (result)
    (dolist (c coding-system-alist result)
      (setq result (or
		    (string-equal (car c) "utf-8-unix")
		    result)))
    (when result
      (add-hook 'howm-view-open-hook
		(lambda ()
		  (setq buffer-file-coding-system 'utf-8-unix)))
    
      (add-hook 'howm-create-file-hook
		(lambda ()
		  (setq buffer-file-coding-system 'utf-8-unix)))))
  
  ;; menu を 5 分毎に自動更新
  (defvar howm-auto-menu-refresh-interval (* 5 60))
  (defun  howm-auto-menu-refresh()
    (when (string-match "howm.*menu" (buffer-name))
      (howm-menu-refresh)))
  (run-with-idle-timer howm-auto-menu-refresh-interval
		       t
		       'howm-auto-menu-refresh)
  
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
