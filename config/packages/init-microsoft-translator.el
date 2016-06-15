;;; init-microsoft-translator.el --- A setting of the microsoft-translator.
;;; Commentary:
;;; Code:

(autoload 'microsoft-translator-translate "microsoft-translator" "" t)
(autoload 'microsoft-translator-auto-translate "microsoft-translator" "" t)

(with-eval-after-load-feature 'microsoft-translator
  (defun microsoft-translator--get-string (arg)
    (or (cond ((stringp arg) arg)
              ((= arg 4)                ;C-u
               (thing-at-point 'paragraph))
              ((= arg 16)               ;C-u C-u
               (thing-at-point 'word))
              ((= arg 64)               ;C-u C-u C-u
               (read-string "Microsoft Translate: "))
              ((use-region-p)           ;リージョン指定
               (buffer-substring (region-beginning) (region-end)))
              (t                        ;デフォルト
               (thing-at-point 'sentence)))
        ""))

  (defun my-microsoft-translator-auto-translate (arg)
    "Read a string in the minibuffer with from-to is auto."
    (interactive "p")
    (let* ((translate-text (microsoft-translator--get-string arg)))
      (microsoft-translator--process
       translate-text
       (if (string-match "\\cj" translate-text) "Japanese" "English")
       (if (string-match "\\cj" translate-text) "English" "Japanese"))))
  (advice-add 'microsoft-translator-auto-translate
              :override #'my-microsoft-translator-auto-translate)

  (defun my-microsoft-translator--translating (translate-text from to)
    (with-current-buffer (get-buffer microsoft-translator-buffer-name)
      (help-mode)))
  (advice-add 'microsoft-translator--translating
              :after #'my-microsoft-translator--translating)

  (push '("*Microsoft Translator*" :height 0.5 :stick t) popwin:special-display-config))

(global-set-key (kbd "C-M-m") 'microsoft-translator-auto-translate)

(provide 'init-microsoft-translator)
;;; init-microsoft-translator.el ends here
