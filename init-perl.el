;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

;; http://d.hatena.ne.jp/antipop/20080701/1214838633

;; set-perl5lib
;; 開いたスクリプトのパスに応じて、@INCにlibを追加してくれる
;; 以下からダウンロードする必要あり
;; http://svn.coderepos.org/share/lang/elisp/set-perl5lib/set-perl5lib.el
(require 'set-perl5lib nil t)

(when (require 'flymake nil t)
  ;; Perl用設定
  ;; http://unknownplace.org/memo/2007/12/21#e001
  (defvar flymake-perl-err-line-patterns
    '(("\\(.*\\) at \\([^ \n]+\\) line \\([0-9]+\\)[,.\n]" 2 3 nil 1)))

  (defconst flymake-allowed-perl-file-name-masks
    '(("\\.pl$" flymake-perl-init)
      ("\\.pm$" flymake-perl-init)
      ("\\.t$" flymake-perl-init)))

  (defun flymake-perl-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "perl" (list "-wc" local-file))))

  (defun flymake-perl-load ()
    (interactive)
    (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
      (setq flymake-check-was-interrupted t))
    (ad-activate 'flymake-post-syntax-check)
    (setq flymake-allowed-file-name-masks (append flymake-allowed-file-name-masks flymake-allowed-perl-file-name-masks))
    (setq flymake-err-line-patterns flymake-perl-err-line-patterns)
    (set-perl5lib)
    (flymake-mode t))

  (add-hook 'cperl-mode-hook 'flymake-perl-load))