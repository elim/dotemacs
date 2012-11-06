;;; basics

;; keyboard setting
(keyboard-translate ?\C-h ?\C-?)
(define-key global-map [delete] #'delete-char)
(define-key global-map (kbd "C-m") 'newline-and-indent)

;; no more hard tab
(setq-default indent-tabs-mode nil)

;; startup screen
(setq inhibit-startup-screen t)

;; expansion GC threshold
(setq gc-cons-threshold (* 64 1024 1024))

;; frame title
(setq frame-title-format `(" %b " (buffer-file-name "( %f )")))

;; ignore case
(setq completion-ignore-case t
      read-buffer-completion-ignore-case t
      read-file-name-completion-ignore-case t)

;; display time
(setq display-time-24hr-format t)
(display-time)

;; kill ring
(setq kill-ring-max 300)

;; menu bar
(menu-bar-mode (if ns-p t -1))

;; tool bar
(when (boundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; scroll bar
(when (boundp 'scroll-bar-mode)
  (set-scroll-bar-mode 'right)
  (scroll-bar-mode -1))

;; line number
(line-number-mode t)

;; column number
(column-number-mode t)

;; other
(setq visible-bell t)
(setq line-move-visual nil)

(temp-buffer-resize-mode t)
(global-font-lock-mode t)


;;; transient-mark-mode
(transient-mark-mode t)


;;; find-function-setup-keys
;;
;; C-x F => Find Function
;; C-x V => Find Variable
;; C-x K => Find Function on Key
(find-function-setup-keys)

;; browse-url
(define-key global-map (kbd "C-x m") 'browse-url-at-point)

;; bs-show
(define-key global-map (kbd "C-x C-b") 'bs-show)

;; eldoc
(when (require 'eldoc nil t)
  (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
  (setq eldoc-idle-delay 0.2)
  (setq eldoc-minor-mode-string ""))


;;; executable-make-buffer-file-executable-if-script-p
;;
(defun elim:executable-make-buffer-file-executable-if-script-p ()
  (unless (string-match tramp-file-name-regexp (buffer-file-name))
    (executable-make-buffer-file-executable-if-script-p)))

(add-hook 'after-save-hook
          #'elim:executable-make-buffer-file-executable-if-script-p)


;;; uniquify
;; 同一ファイル名のバッファ名を分かりやすく
(when (require 'uniquify nil t)
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets
        uniquify-ignore-buffers-re "*[^*]+*"
        uniquify-min-dir-content 1))


;;; add occur to isearch
;; http://www.emacsblog.org/2007/02/27/quick-tip-add-occur-to-isearch/
(define-key isearch-mode-map (kbd "C-o")
  (lambda ()
    (interactive)
    (let ((case-fold-search isearch-case-fold-search))
      (occur (if isearch-regexp isearch-string
               (regexp-quote isearch-string))))))


;;; show-trailing-whitespace
;; 行末の空白をめだたせる
;; M-x delete-trailing-whitespace で削除出来る
(when (boundp 'show-trailing-whitespace)
  (setq-default show-trailing-whitespace nil))


;;; auto delete-trailing-whitespace before save
;;
(defvar elim:auto-delete-trailing-whitespace-enable-p t)
(defun elim:auto-delete-trailing-whitespace ()
  (and elim:auto-delete-trailing-whitespace-enable-p
       (delete-trailing-whitespace)))

(setq elim:auto-delete-trailing-whitespace-enable-p nil)
(add-hook 'before-save-hook
          #'elim:auto-delete-trailing-whitespace)


;;; no kill new duplicates
;; kill-ring に同じ内容の文字列を複数入れない
(defadvice kill-new (before elim:no-kill-new-duplicates activate)
  (setq kill-ring (delete (ad-get-arg 0) kill-ring)))


;;; バージョン管理システム
;; diredから適切なバージョン管理システムの*-statusを起動
(defun dired-vc-status (&rest args)
  (interactive)
  (let ((path (find-path-in-parents (dired-current-directory)
                                    '(".svn" ".git"))))
    (cond ((null path)
           (message "not version controlled."))
          ((string-match-p "\\.svn$" path)
           (svn-status (file-name-directory path)))
          ((string-match-p "\\.git$" path)
           (magit-status (file-name-directory path))))))
(define-key dired-mode-map "V" 'dired-vc-status)


;;; html-mode
;;
(add-hook 'html-mode-hook
	  (lambda ()
	    (set (make-local-variable 'sgml-basic-offset) 00)))



;;; スペルチェック
;;; 2011-03-09

;; M-TABのキーバインドを変更しない
;; 2011-03-27
(setq flyspell-use-meta-tab nil)
;; デフォルトで自動スペルチェック機能を有効にする
(setq-default flyspell-mode t)
;; スペルチェックには英語の辞書を使う
(setq ispell-dictionary "american")

;;; diff-mode
;;; 2012-04-02
(load "config/builtins/diff-mode")


;;; text-mode
;; 2012-03-18
(load "config/builtins/text-mode")


;;; cc-mode
;; 2012-03-18
(load "config/builtins/cc-mode")


;;; emacs-lisp-mode
;; 2012-03-18
(load "config/builtins/emacs-lisp-mode")


;;; 追加の設定
;; 個別の設定があったら読み込む
;; 2012-03-18
(load "config/builtins/local" t)
