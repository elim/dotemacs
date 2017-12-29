;;; init-ag.el --- A setting of the ag.
;;; Commentary:
;;; Code:

(defun elim:filter (condp lst)
  (delq nil
        (mapcar #'(lambda (x) (and (funcall condp x) x)) lst)))

(defun elim:get-buffer-window-list-regexp (regexp)
  "Return list of windows whose buffer name match REGEXP."
  (elim:filter #'(lambda (window)
                   (string-match regexp
                                 (buffer-name (window-buffer window))))
               (window-list)))

(use-package ag
  :bind (("C-x g" . elim:ag) ;; キーバインドを適当につけておくと便利。"\C-xg"とか
         :map ag-mode-map
         ;; agの検索結果バッファで"r"で編集モードに。
         ;; C-x C-sで保存して終了、C-x C-kで保存せずに終了
         ("r" . wgrep-change-to-wgrep-mode))
  :commands wgrep-ag-setup

  :hook (ag . wgrep-ag-setup)

  :init
  (add-to-list 'process-coding-system-alist '("ag" utf-8 . utf-8))
  (set-variable 'ag-highlight-search t) ; 検索結果の中の検索語をハイライトする
  (set-variable 'ag-reuse-buffers nil)  ; 現在のバッファを検索結果表示に使う
  (set-variable 'ag-reuse-window nil)   ; 現在のウィンドウを検索結果表示に使う

  (defun elim:ag ()
    "Open and select the ag result buffer."
    (interactive)
    (call-interactively 'ag)
    (select-window ; select ag buffer
     (car (elim:get-buffer-window-list-regexp "^\\*ag ")))))

(provide 'init-ag)
;;; init-ag.el ends here
