;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode t -*-
;;; $Id$

;; based upon
;; http://d.hatena.ne.jp/antipop/20080321/1206090430
;; kentaro++

(and (require 'yasnippet nil t)
     (setq yas/root-directory
	   (expand-file-name "~/src/elisps/yasnippet/snippets/")
	   yas/use-menu nil
	   yas/trigger-key (kbd "SPC")
	   yas/next-field-key (kbd "TAB")
	   yas/buffer-local-condition
	   '(or (not (or (string= "font-lock-comment-face"
				  (get-char-property (point) 'face))
			 (string= "font-lock-string-face"
				  (get-char-property (point) 'face))))
		'(require-snippet-condition . force-in-comment)))

     (and (require 'dropdown-list nil t)
	  (setq yas/text-popup-function
		#'yas/dropdown-list-popup-for-template))

     (defvar snippet-directories nil)

     (mapc '(lambda (path)
	      (and
	       (file-accessible-directory-p path)
	       (add-to-list 'snippet-directories
			    (expand-file-name path))))
	   (list "~/src/elisps/yasnippet-snippets/common"  ; CodeRepos
		 "~/src/elisps/yasnippet-snippets/elim"    ; CodeRepos
		 "~/.emacs.d/snippets"))                   ; Private

     ;; yasnippet公式提供のものと、自分用カスタマイズスニペットをロード同名
     ;; のスニペットが複数ある場合、あとから読みこんだ自分用のものが優先され
     ;; る。また、スニペットを変更、追加した場合、このコマンドを実行すること
     ;; で、変更・追加が反映される。

     (defun yas/load-all-directories ()
       (interactive)
       (yas/reload-all)
       (mapc 'yas/load-directory-1 my-snippet-directories))

     ;;; [2008-03-17]
     ;;; yasnippet展開中はflymakeを無効にする

     (defvar flymake-is-active-flag nil)

     (defadvice yas/expand-snippet
       (before inhibit-flymake-syntax-checking-while-expanding-snippet activate)
       (setq flymake-is-active-flag
	     (or flymake-is-active-flag
		 (assoc-default 'flymake-mode (buffer-local-variables))))
       (when flymake-is-active-flag
	 (flymake-mode-off)))

     (add-hook 'yas/after-exit-snippet-hook
	       '(lambda ()
		  (when flymake-is-active-flag
		    (flymake-mode-on)
		    (setq flymake-is-active-flag nil))))

     ;; yasnippet初期化
     (yas/initialize)
     (yas/load-all-directories))