;;; init-ddskk.el --- A setting of the ddskk.
;;; Commentary:
;;; Code:

(global-set-key "\C-x\C-j" 'skk-mode)
(global-set-key "\C-xt" nil)
(global-set-key "\C-xj" nil)
;; (global-set-key "\C-xj" 'skk-auto-fill-mode)
;; (global-set-key "\C-xt" 'skk-tutorial)


;; @@ 基本の設定
(setq skk-jisyo-code 'utf-8
      skk-count-private-jisyo-candidates-exactly t
      skk-share-private-jisyo t)

;; SKK を Emacs の input method として使用する
(setq default-input-method "japanese-skk")

;; SKK を起動していなくても、いつでも skk-isearch を使う
;; (add-hook 'isearch-mode-hook 'skk-isearch-mode-setup)
;; (add-hook 'isearch-mode-end-hook 'skk-isearch-mode-cleanup)
;; migemo を使うから skk-isearch にはおとなしくしていて欲しい
(setq skk-isearch-start-mode 'latin)

;; @@ 応用的な設定

;; ~/.skk* なファイルがたくさんあるので整理したい
(let ((ddskk-preference-directory
       (expand-file-name "config/packages/ddskk" user-emacs-directory)))
  (setq skk-init-file
        (expand-file-name "init.el" ddskk-preference-directory)
        skk-emacs-id-file
        (expand-file-name "emacs-id" ddskk-preference-directory)
        skk-record-file
        (expand-file-name "record" ddskk-preference-directory)))

;; YaTeX のときだけ句読点を変更したい
(add-hook 'yatex-mode-hook
          #'(lambda ()
              (require 'skk)
              (setq skk-kutouten-type 'en)))

;; 辞書を 10 分毎に自動保存
(defvar skk-auto-save-jisyo-interval 600)
(defun skk-auto-save-jisyo ()
  (skk-save-jisyo))

;; (cancel-function-timers 'skk-auto-save-jisyo)
(run-with-idle-timer skk-auto-save-jisyo-interval
                     t
                     'skk-auto-save-jisyo)

(provide 'init-ddskk)
;;; init-ddskk.el ends here
