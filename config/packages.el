;;; el-get
;; 複数のソースからパッケージをインストールできるパッケージ管理システム
;; 2012-03-15
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(let (el-get-master-branch)
  (unless (require 'el-get nil t)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
      (end-of-buffer)
      (eval-print-last-sexp))))

;; レシピ置き場
(add-to-list 'el-get-recipe-path
             (concat (file-name-directory load-file-name) "/el-get/recipes"))
;; 追加のレシピ置き場
(add-to-list 'el-get-recipe-path
             "~/.emacs.d/config/el-get/local-recipes")


;;; lispxmp
;; 式の評価結果を注釈するための設定
(el-get 'sync '(lispxmp))
(when (require 'lispxmp nil t)
  (define-key emacs-lisp-mode-map (kbd "C-c C-d") 'lispxmp))


;;; auto-save-buffers-enhanced
;;
(el-get 'sync '(auto-save-buffers-enhanced))
(setq auto-save-default nil
      auto-save-buffers-enhanced-include-regexps '(".+")
      auto-save-buffers-enhanced-exclude-regexps '("^not-save-file" "\\.ignore$")
      auto-save-buffers-enhanced-save-scratch-buffer-to-file-p t
      auto-save-buffers-enhanced-cooperate-elscreen-p t
      auto-save-buffers-enhanced-quiet-save-p t)
(global-set-key "\C-xas" 'auto-save-buffers-enhanced-toggle-activity)
(auto-save-buffers-enhanced t)

;;; elscreen
;;
(el-get 'sync '(knu-elscreen))
(elscreen-set-prefix-key [(control l)])
(setq elscreen-display-tab t)
;; (unless (boundp 'last-command-char)
;;   (defvaralias 'last-command-char 'last-command-event))


;;; Anything
;; iswitchbの代わり
(let ((original-browse-url-browser-function browse-url-browser-function))
  (el-get 'sync '(anything))
  (require 'anything-config nil t)
  (require 'anything-startup nil t)
  (when (require 'anything-complete nil t)
    (anything-lisp-complete-symbol-set-timer 150))
  (anything-set-anything-command-map-prefix-key
   'anything-command-map-prefix-key "C-c C-<SPC>")
  (mapc '(lambda (key)
           (define-key global-map key 'anything))
        (list
         [(control ?:)]
         [(control \;)]
         [(control x)(control :)]
         [(control x)(control \;)]))
  (define-key global-map (kbd "C-x C-f") 'anything-find-file)
  (define-key global-map (kbd "C-x b") 'anything-for-files)
  (define-key global-map (kbd "C-x g") 'anything-imenu) ; experimental
  (define-key global-map (kbd "M-x") 'anything-M-x)
  (define-key anything-map (kbd "C-z") nil)
  (define-key anything-map (kbd "C-l") 'anything-execute-persistent-action)
  (define-key anything-map (kbd "C-o") nil)
  (define-key anything-map (kbd "C-M-n") 'anything-next-source)
  (define-key anything-map (kbd "C-M-p") 'anything-previous-source)
  (define-key ctl-x-map (kbd "C-y") 'anything-show-kill-ring)
  (setq browse-url-browser-function original-browse-url-browser-function
        anything-enable-shortcuts 'alphabet
        anything-sources
        (list anything-c-source-buffers+
              anything-c-source-files-in-current-dir
              anything-c-source-file-name-history
              anything-c-source-locate
              anything-c-source-emacs-commands)))


;;; popwin
;;
(el-get 'sync '(popwin))
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer
      anything-samewindow nil)
(push '("*anything*" :height 20) popwin:special-display-config)
(push '("*anything M-x*" :height 20) popwin:special-display-config)
(push '("*anything for files*" :height 20) popwin:special-display-config)
(push '("*anything find-file*" :height 20) popwin:special-display-config)
(push '(dired-mode :position top) popwin:special-display-config)


;;; markdown-mode
;;
(el-get 'sync '(markdown-mode))


;;; less-css-mode
;;
(el-get 'sync '(less-css-mode))


;;; egret-mode
;;
(el-get 'sync '(egret-mode))
(global-set-key (kbd "C-c e c") #'egret-el-create-input-buffer)


;;; open-junk-file
;;
(el-get 'sync '(open-junk-file))
(setq open-junk-file-find-file-function #'find-file)
(define-key global-map (kbd "C-x C-z") 'open-junk-file)


;;; php-mode
;; 2012-08-01
(el-get 'sync '(php-mode))
(when (require 'php-mode nil t)
  (add-hook 'php-mode-hook #'php-mode-hook)

  (setq auto-mode-alist
        (append
         '(("/\\(PEAR\\|pear\\)/" . php-mode)
           ("\.php$" . php-mode))
         auto-mode-alist))

  (defun php-mode-hook-func ()
    (c-set-style "gnu")
    ;; 連続する空白の一括削除 (必要なければコメントアウトする)
    (c-toggle-hungry-state t)
    (setq tab-width 8
          indent-tabs-mode nil
          show-trailing-whitespace t
          c-basic-offset 2
          ;; コメントのスタイル (必要なければコメントアウトする)
          comment-start "// "
          comment-end   ""
          comment-start-skip "// *")

    (c-set-offset 'arglist-intro '+)
    (c-set-offset 'arglist-close 0)
    (c-set-offset 'statement-cont 'c-lineup-math)
    (flymake-mode 1))
  (add-hook 'php-mode-hook 'php-mode-hook-func)
  (add-to-list 'auto-mode-alist '("\\.ctp\\'" . php-mode))

  ;; C-c C-f でカーソル下の関数のマニュアルを検索
  (setq php-search-url "http://jp.php.net/ja/")

  ;; C-RET でマニュアルページにジャンプ
  (setq php-manual-url "http://jp.php.net/manual/ja/")

  ;; 前/次の関数にジャンプ。キーバインドはお好みで。
  (define-key php-mode-map (kbd "C-c C-[") 'beginning-of-defun)
  (define-key php-mode-map (kbd "C-c C-]") 'end-of-defun))



;;; auto-jump-mode
;; 2012-06-23
;; based upon http://d.hatena.ne.jp/rkworks/20120520/1337528737
(el-get 'sync '(ace-jump-mode))
(when (require 'ace-jump-mode nil t)
  (defun add-keys-to-ace-jump-mode (prefix c &optional mode)
    (define-key global-map
      (read-kbd-macro (concat prefix (string c)))
      `(lambda ()
         (interactive)
         (funcall (if (eq ',mode 'word)
                      #'ace-jump-word-mode
                    #'ace-jump-char-mode) ,c))))

  (loop for c from ?0 to ?9 do (add-keys-to-ace-jump-mode "H-" c))
  (loop for c from ?a to ?z do (add-keys-to-ace-jump-mode "H-" c))
  (loop for c from ?0 to ?9 do (add-keys-to-ace-jump-mode "H-M-" c 'word))
  (loop for c from ?a to ?z do (add-keys-to-ace-jump-mode "H-M-" c 'word))

  (setq ns-command-modifier (quote meta)
        ns-right-command-modifier (quote hyper)
        ns-alternate-modifier (quote super)
        ns-right-alternate-modifier (quote alt)))

;;; apache-mode
;; 2012-06-18
; (el-get 'sync '(apache-mode))


;;; grep-edit
;; *grep*で編集できるようにする
(el-get 'sync '(grep-edit))
(add-hook 'grep-setup-hook
          (lambda ()
            (define-key grep-mode-map
              (kbd "C-c C-c") 'grep-edit-finish-edit)))


;;; ポップアップ
;; 2012-03-16
(el-get 'sync '(popup))


;;; Auto Complete
;; 自動補完
(el-get 'sync '(auto-complete))
(add-hook 'auto-complete-mode-hook
          (lambda ()
            (define-key ac-completing-map (kbd "C-n") 'ac-next)
            (define-key ac-completing-map (kbd "C-p") 'ac-previous)))


;;; Migemo
;; ローマ字で日本語をインクリメンタルサーチする。
;; 2012-03-19
;; インストールされていたら有効にする。
(require 'migemo nil t)


;;; ruby-mode
;; Emacsにバンドルされているruby-modeは古いのでRubyのリポジ
;; トリに入っているものを使う。
;; 2012-03-15
(el-get 'sync '(ruby-mode-trunk))
(el-get 'sync '(ruby-end))

;; http://stackoverflow.com/questions/7961533/emacs-ruby-method-parameter-indentation
(defadvice ruby-indent-line (after unindent-closing-paren activate)
  (let ((column (current-column))
        indent offset)
    (save-excursion
      (back-to-indentation)
      (let ((state (syntax-ppss)))
        (setq offset (- column (current-column)))
        (when (and (eq (char-after) ?\))
                   (not (zerop (car state))))
          (goto-char (cadr state))
          (setq indent (current-indentation)))))
    (when indent
      (indent-line-to indent)
      (when (> offset 0) (forward-char offset)))))



;;; rabbit-mode
;; 2012-03-16
(el-get 'sync '(rabbit-mode))


;;; run-test
;; テスト実行
(el-get 'sync '(run-test))


;;; Magit
;; 2012-03-24
(load "config/packages/magit")


;;; rst-mode
;; reStructuredText編集用のモード
;; 2012-03-24
(el-get 'sync '(rst-mode))


;;; textile-mode
;; Textile編集用のモード
;; 2012-04-11
(el-get 'sync '(textile-mode))


;;; js2-mode
;; JavaScript編集用のモード
;; 2012-04-05
(el-get 'sync '(mooz-js2-mode))


;;; coffe-mode
;; CoffeeScript編集用のモード
;; 2012-04-04
(el-get 'sync '(coffee-mode))


;;; 追加の設定
;; 個別の設定があったら読み込む
;; 2012-03-15
(load "config/packages/local" t)
