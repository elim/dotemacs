;;; init-ag.el --- A setting of the ag.
;;; Commentary:
;;; Code:

(require 'ag)

(add-to-list 'process-coding-system-alist '("ag" utf-8 . utf-8))

(setq ag-highlight-search t  ; 検索結果の中の検索語をハイライトする
      ag-reuse-window nil    ; 現在のウィンドウを検索結果表示に使う
      ag-reuse-buffers 'nil) ; 現在のバッファを検索結果表示に使う

(autoload 'wgrep-ag-setup "wgrep-ag")
(add-hook 'ag-mode-hook 'wgrep-ag-setup)

;; agの検索結果バッファで"r"で編集モードに。
;; C-x C-sで保存して終了、C-x C-kで保存せずに終了
(define-key ag-mode-map (kbd "r") 'wgrep-change-to-wgrep-mode)

;; キーバインドを適当につけておくと便利。"\C-xg"とか
(global-set-key [(super m)] 'ag)

;; ag開いたらagのバッファに移動するには以下をつかう
(defun my/filter (condp lst)
  (delq nil
        (mapcar #'(lambda (x) (and (funcall condp x) x)) lst)))

(defun my/get-buffer-window-list-regexp (regexp)
  "Return list of windows whose buffer name matches regexp."
  (my/filter #'(lambda (window)
                 (string-match regexp
                               (buffer-name (window-buffer window))))
             (window-list)))

(global-set-key [(super m)]
                #'(lambda ()
                    (interactive)
                    (call-interactively 'ag)
                    (select-window ; select ag buffer
                     (car (my/get-buffer-window-list-regexp "^\\*ag ")))))
(provide 'init-ag)
;;; init-ag.el ends here
