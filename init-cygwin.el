;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

;; for Meadow and Cygwin.

;; based upon
;;   meadow-users-jp:3050
;;   http://mechanics.civil.tohoku.ac.jp/soft/node45.html
;;   http://meadow.sourceforge.jp/cgi-bin/hiki.cgi?%B0%EC%C8%CC%C5%AA%A4%CA%BE%F0%CA%F3

(when windows-p
  (setq explicit-shell-file-name
        (fold-left (lambda (x y)
                     (or x (executable-find y)))
                   nil (list "zsh" "bash" "sh"))
        shell-file-name explicit-shell-file-name
        shell-command-switch "-c"
        ;; drive letter completion on shell-mode.
        shell-file-name-chars "~/A-Za-z0-9_^$!#%&{}@`'.,:()-")

  (add-hook 'shell-mode-hook
            '(lambda ()
               (set-buffer-process-coding-system
                'undecided-dos 'sjis-unix)))

  ;; http://ntemacsjp.sourceforge.jp/matsuan/IndexJp.html
  ;; handle cygwin mount

  (and (executable-find "mount.exe")
       (require 'cygwin-mount nil t)
       (cygwin-mount-activate))

  ;; follow windows short cut
  (and (setq w32-symlinks-handle-shortcuts t)
       (require 'w32-symlinks nil t)

       ;; http://www.bookshelf.jp/cgi-bin/goto.cgi?file=meadow&node=findfile%20symlink
       (defadvice minibuffer-complete
         (before expand-symlinks activate)
         (let ((file (expand-file-name
                      (buffer-substring-no-properties
                       (line-beginning-position)
                       (line-end-position)))))
           (when (string-match ".lnk$" file)
             (delete-region
              (line-beginning-position)
              (line-end-position))
             (if (file-directory-p
                  (w32-symlinks-parse-symlink file))
                 (insert
                  (concat
                   (w32-symlinks-parse-symlink file) "/"))
               (insert (w32-symlinks-parse-symlink file))))))))


(when meadow-p
  (and (mapcar #'executable-find
               (list "getclip" "putclip"))
       
       (defadvice kill-new (after normalized-clipboard activate)
         (start-process
          "normalization of the contents of the clipboard."
          "*Messages*" shell-file-name shell-command-switch
          "getclip | petclip"))))