;;; dired.el --- Settings of the dired and supplements.
;;; Commentary:
;;; Code:

(use-package dired
  :bind (:map dired-mode-map
              ("SPC" . elim:dired-toggle-mark)
              ("V"   . elim:dired-vc-status))

  :custom
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'always)

  :config
  ;; スペースでマークする (FD like)
  (defun elim:dired-toggle-mark (arg)
    "Toggle the current (or next ARG) files."
    ;; S.Namba Sat Aug 10 12:20:36 1996
    (interactive "P")
    (let ((dired-marker-char
           (if (save-excursion (beginning-of-line)
                               (looking-at " "))
               dired-marker-char ?\040)))
      (dired-mark arg)
      (dired-next-line 0)))

  (defun elim:dired-vc-status (&rest args)
    (interactive)
    (let ((path (find-path-in-parents (dired-current-directory)
                                      '(".svn" ".git"))))
      (cond ((null path)
             (message "not version controlled."))
            ((string-match-p "\\.svn$" path)
             (svn-status (file-name-directory path)))
            ((string-match-p "\\.git$" path)
             (egg-status (file-name-directory path)))))))

(use-package dired-x
  :bind (("C-x C-j" . skk-mode))
  :custom
  (dired-bind-jump nil)
  (dired-guess-shell-alist-user
   '(("\\.tar\\.gz\\'"  "tar tzvf")
     ("\\.taz\\'" "tar ztvf")
     ("\\.tar\\.bz2\\'" "tar tjvf")
     ("\\.zip\\'" "unzip -l")
     ("\\.\\(g\\|\\) z\\'" "zcat"))))

(use-package wdired
  :bind (:map dired-mode-map
              ("r" . wdired-change-to-wdired-mode)))

(use-package dired-aux
  :bind (:map dired-mode-map
              ("T" . dired-do-convert-coding-system))
  :init
  (defvar dired-default-file-coding-system nil
    "*Default coding system for converting file (s).")

  (defvar dired-file-coding-system 'no-conversion)

  ;; dired を使って、一気にファイルの coding system (漢字) を変換する
  ;; dired で m でマークを付け，T とします．これで，マークを付けたファイルの
  ;; 文字コードを変換できます．
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
        (dired-make-relative file)))))

;;; dired.el ends here
