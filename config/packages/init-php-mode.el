;;; init-php-mode.el --- A setting of the php-mode.
;;; Commentary:
;;; Code:

(with-eval-after-load-feature 'php-mode
  (setq auto-mode-alist
        (append
         '(("/\\(PEAR\\|pear\\)/" . php-mode)
           ("\.php$" . php-mode))
         auto-mode-alist))

  (defun php-mode-hook-func ()
    (c-set-style "gnu")

    (define-key php-mode-map (kbd "C-c C-[") 'beginning-of-defun)
    (define-key php-mode-map (kbd "C-c C-]") 'end-of-defun)
    (setq tab-width 2
          indent-tabs-mode nil
          show-trailing-whitespace t
          require-final-newline t
          php-mode-coding-style 'PSR-2
          c-basic-offset 2
          ;; コメントのスタイル (必要なければコメントアウトする)
          comment-start "// "
          comment-end   ""
          comment-start-skip "// *")

    (hs-minor-mode 1)
    (c-set-offset 'arglist-intro '+)
    (c-set-offset 'arglist-close 0)
    (c-set-offset 'statement-cont 'c-lineup-math))

  (add-hook 'php-mode-hook 'php-mode-hook-func)
  (add-to-list 'auto-mode-alist '("\\.ctp\\'" . php-mode))

  ;; C-c C-f でカーソル下の関数のマニュアルを検索
  (setq php-search-url "http://jp.php.net/ja/")

  ;; C-RET でマニュアルページにジャンプ
  (setq php-manual-url "http://jp.php.net/manual/ja/"))

;;; init-php-mode.el ends here
