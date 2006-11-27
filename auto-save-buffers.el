;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$
;; http://namazu.org/%7Esatoru/unimag/12/
;;
;; このコードは山岡克美氏が書いてくださった (ELF:01128)
;;
;; (require 'auto-save-buffers)
;; (run-with-idle-timer 0.5 t 'auto-save-buffers) ; アイドル0.5秒で保存

;; auto-save-buffers で対象とするファイルの正規表現
(defvar auto-save-buffers-regexp ""
  "*Regexp that matches `buffer-file-name' to be auto-saved.")

(defun auto-save-buffers ()
  "Save buffers if `buffer-file-name' matches `auto-save-buffers-regexp'."
  (let ((buffers (buffer-list))
	buffer)
    (save-excursion
      (while buffers
	(set-buffer (car buffers))
	(if (and buffer-file-name
		 (buffer-modified-p)
		 (not buffer-read-only)
		 (string-match auto-save-buffers-regexp buffer-file-name)
		 (file-writable-p buffer-file-name))
	    (save-buffer))
	(setq buffers (cdr buffers))))))

(provide 'auto-save-buffers)
