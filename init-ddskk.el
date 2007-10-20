;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (require 'skk-setup nil t)
  (setq skk-indicator-use-cursor-color nil)
  (global-set-key "\C-x\C-j" 'skk-mode)
  ;; (global-set-key "\C-xj" 'skk-auto-fill-mode)
  (global-set-key "\C-xj" nil)
  ;; (global-set-key "\C-xt" 'skk-tutorial)
  (global-set-key "\C-xt" nil)

  (autoload-if-found 'skk "skk" nil t)
  (autoload-if-found 'skk-mode "skk" nil t)
  (autoload-if-found 'skk-auto-fill-mode "skk" nil t)
  (autoload-if-found 'skk-check-jisyo "skk-tools" nil t)
  (autoload-if-found 'skk-merge "skk-tools" nil t)
  (autoload-if-found 'skk-diff "skk-tools" nil t)
  (autoload-if-found 'skk-isearch-mode-setup "skk-isearch" nil t)
  (autoload-if-found 'skk-isearch-mode-cleanup "skk-isearch" nil t)

  ;; @@ 基本の設定

  (setq skk-count-private-jisyo-candidates-exactly t)
  (setq skk-share-private-jisyo t)

  (when (>= 19 emacs-major-version)
    (require 'skk-setup nil t))

  ;; SKK を Emacs の input method として使用する
  (setq default-input-method "japanese-skk")

  ;; SKK を起動していなくても、いつでも skk-isearch を使う
  (add-hook 'isearch-mode-hook 'skk-isearch-mode-setup)
  (add-hook 'isearch-mode-end-hook 'skk-isearch-mode-cleanup)
  ;; migemo を使うから skk-isearch にはおとなしくしていて欲しい
  ;; (setq skk-isearch-start-mode 'latin)

  ;; @@ 応用的な設定

  ;; ~/.skk* なファイルがたくさんあるので整理したい
  (setq ddskk-preference-directory
	(expand-file-name "ddskk" base-directory))
  (setq skk-init-file
	(expand-file-name "init.el" ddskk-preference-directory)
	skk-custom-file
	(expand-file-name "custom.el" ddskk-preference-directory)
	skk-emacs-id-file
	(expand-file-name "emacs-id" ddskk-preference-directory)
	skk-record-file
	(expand-file-name "record" ddskk-preference-directory))
  ;	skk-jisyo "~/.ddskk/jisyo"
  ;      skk-backup-jisyo "~/.ddskk/jisyo.bak")


  ;; super-smart-find のための設定 (意味あるかな？)
  (setq super-smart-find-self-insert-command-list
	'(canna-self-insert-command
	  egg-self-insert-command
	  self-insert-command
	  tcode-self-insert-command-maybe
	  skk-insert))

  ;; YaTeX のときだけ句読点を変更したい
  (add-hook 'yatex-mode-hook
	    (lambda ()
	      (require 'skk)
	      (setq skk-kutouten-type 'en)))

  ;; 辞書を 10 分毎に自動保存
  (defvar skk-auto-save-jisyo-interval 600)
  (defun skk-auto-save-jisyo ()
    (skk-save-jisyo)
    (skk-bayesian-save-history)
    (skk-bayesian-corpus-save))
  (run-with-idle-timer skk-auto-save-jisyo-interval
		       t
		       'skk-auto-save-jisyo))
 ;;(cancel-function-timers 'skk-auto-save-jisyo)
