;-*- emacs-lisp -*-
; $Id$

(setq howm-menu-lang 'ja)
(global-set-key "\C-c,," 'howm-menu)
(mapc
 (lambda (f)
   (autoload f
     "howm-mode" "Hitori Otegaru Wiki Modoki" t))
 '(howm-menu howm-list-all howm-list-recent
	     howm-list-grep howm-create
	     howm-keyword-to-kill-ring))

;; 「最近のメモ」一覧時にタイトル表示
(setq howm-list-recent-title t)

(setq howm-view-use-grep nil)
(cond
 ((locate-library "grep" nil exec-path)
    (setq howm-view-use-grep t))
 ((locate-library "grep.exe" nil exec-path)
  (setq howm-view-use-grep t)))


;; 全メモ一覧時にタイトル表示
(setq howm-list-all-title t)

;; 日付の新しい順
(setq howm-list-normalizer 'howm-view-sort-by-reverse-date)

;; 日記を書く
(defun my-howm-diary-edit ()
  "説明文"
  (interactive)
  (let ((my-diary-file
	(expand-file-name
	 (concat howm-directory
		 (format-time-string "/%Y/%m/%Y-%m-%d.howm" (current-time))))))
  (if (file-exists-p my-diary-file)
      (find-file my-diary-file)
    (progn
      (find-file my-diary-file)
      (insert "= diary\n")))
  (howm-mode)))


;; いちいち消すのも面倒なので
;; 内容が 0 ならファイルごと削除する
(if (not (memq 'delete-file-if-no-contents after-save-hook))
    (setq after-save-hook
	  (cons 'delete-file-if-no-contents after-save-hook)))
(defun delete-file-if-no-contents ()
  (when (and
	 (buffer-file-name (current-buffer))
	 (string-match "\\.howm" (buffer-file-name (current-buffer)))
	 (= (point-min) (point-max)))
    (delete-file
     (buffer-file-name (current-buffer)))))

;; http://howm.sourceforge.jp/cgi-bin/hiki/hiki.cgi?SaveAndKillBuffer
;; C-cC-c で保存してバッファをキルする
(defun my-save-and-kill-buffer ()
  (interactive)
  (when (and
	 (buffer-file-name)
	 (string-match "\\.howm"
		       (buffer-file-name)))
    (save-buffer)
    (kill-buffer nil)))

(eval-after-load "howm-mode"
  '(progn
     (define-key howm-mode-map
       "\C-c\C-c" 'my-save-and-kill-buffer)
     (define-key howm-mode-map
       ;; howm-insert-date を上書き.
       ;; howm-insert-dtime を使って下さい. 
       "\C-c,d" 'my-howm-diary-edit)))

;; default-buffer-file-coding-system が utf-8 じゃない環境でも utf-8 を強制
(add-hook 'howm-view-open-hook
	  (lambda ()
	    (setq buffer-file-coding-system 'utf-8-unix)))

(add-hook 'howm-create-file-hook
	  (lambda ()
	    (setq buffer-file-coding-system 'utf-8-unix)))

(if (and
     (string-match "fascinating.local$" system-name)
     (featurep 'meadow))
    (setq howm-directory "h:/howm/"))

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
	 (insert day)))))