;;; init-web-mode.el --- A setting of the web-mode.
;;; Commentary:
;;; Code:

(setq auto-mode-alist
      (append
       '(("/\\(PEAR\\|pear\\)/" . php-mode)
         ("\.html?$" . web-mode)
         ("\.ctp$" . web-mode))
       auto-mode-alist)
      web-mode-block-padding 2
      web-mode-comment-style 2
      web-mode-indent-style 2
      web-mode-script-padding 2
      web-mode-style-padding 2)

(add-hook 'web-mode-hook
          #'(lambda ()
              (setq tab-width 2
                    indent-tabs-mode nil
                    show-trailing-whitespace t
                    require-final-newline t
                    c-basic-offset 2
                    ;; コメントのスタイル (必要なければコメントアウトする)
                    comment-start "// "
                    comment-end   ""
                    comment-start-skip "// *")
              (hs-minor-mode 1)))

(provide 'init-web-mode)
;;; init-web-mode.el ends here
