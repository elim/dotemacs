;; -*- emacs-lisp -*-
;; $Id$

(setq dired-bind-jump nil)
(add-hook 'dired-load-hook
	  (lambda ()
	    (load "dired-x")))

 	
;; wdired を使えば， dired バッファを編集して，その変更を適用することができます．
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)

;; スペースでマークする (FD like)
(define-key dired-mode-map " " 'dired-toggle-mark)
(defun dired-toggle-mark (arg)
  "Toggle the current (or next ARG) files."
  ;; S.Namba Sat Aug 10 12:20:36 1996
  (interactive "P")
  (let ((dired-marker-char
         (if (save-excursion (beginning-of-line)
                             (looking-at " "))
             dired-marker-char ?\040)))
    (dired-mark arg)
    (dired-previous-line 1)))

;;; dired を使って、一気にファイルの coding system (漢字) を変換する
;; dired で m でマークを付け，T とします．これで，マークを付けたファイルの
;; 文字コードを変換できます．
(require 'dired-aux)
(add-hook 'dired-mode-hook
          (lambda ()
            (define-key (current-local-map) "T"
              'dired-do-convert-coding-system)))

(defvar dired-default-file-coding-system nil
  "*Default coding system for converting file (s).")

(defvar dired-file-coding-system 'no-conversion)

(defun dired-convert-coding-system ()
  (let ((file (dired-get-filename))
        (coding-system-for-write dired-file-coding-system)
        failure)
    (condition-case err
        (with-temp-buffer
          (insert-file file)
          (write-region (point-min) (point-max) file))
      (error (setq failure err)))
    (if (not failure)
        nil
      (dired-log "convert coding system error for %s:\n%s\n" file failure)
      (dired-make-relative file))))

(defun dired-do-convert-coding-system (coding-system &optional arg)
  "Convert file (s) in specified coding system."
  (interactive
   (list (let ((default (or dired-default-file-coding-system
                            buffer-file-coding-system)))
           (read-coding-system
            (format "Coding system for converting file (s) (default, %s): "
                    default)
            default))
         current-prefix-arg))
  (check-coding-system coding-system)
  (setq dired-file-coding-system coding-system)
  (dired-map-over-marks-check
   (function dired-convert-coding-system) arg 'convert-coding-system t))

(setq dired-guess-shell-alist-user
      '(("\\.tar\\.gz\\'"  "tar ztvf")
	("\\.taz\\'" "tar ztvf")
	("\\.tar\\.bz2\\'" "tar Itvf")
	("\\.zip\\'" "unzip -l")
	("\\.\\(g\\|\\) z\\'" "zcat")
	("\\.mp3\\'" "mpg321")
	("\\.ogg\\'" "ogg123")
	("\\.\\(avi\\|mpg\\|asf\\|wmv\\)\\'" "xine")
	("\\.\\(jpg\\|JPG\\|gif\\|GIF\\)\\'"
	 (if (eq system-type 'windows-nt)
	     "fiber" "display"))
	("\\.ps\\'"
	 (if (eq system-type 'windows-nt)
	     "fiber" "ggv"))))
