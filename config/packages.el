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


;;; ddskk
;;
(el-get 'sync '(ddskk))

(setq skk-indicator-use-cursor-color nil)
(global-set-key "\C-x\C-j" 'skk-mode)
(global-set-key "\C-xj" nil)
(global-set-key "\C-xt" nil)
;; (global-set-key "\C-xj" 'skk-auto-fill-mode)
;; (global-set-key "\C-xt" 'skk-tutorial)

(mapc #'(lambda (lib)
          (apply #'autoload lib))
      (list
       '(skk "skk" nil t)
       '(skk-mode "skk" nil t)
       '(skk-auto-fill-mode "skk" nil t)
       '(skk-check-jisyo "skk-tools" nil t)
       '(skk-merge "skk-tools" nil t)
       '(skk-diff "skk-tools" nil t)
       '(skk-isearch-mode-setup "skk-isearch" nil t)
       '(skk-isearch-mode-cleanup "skk-isearch" nil t)))

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
(setq ddskk-preference-directory
      (expand-file-name "config/packages/ddskk" user-emacs-directory))
(setq skk-init-file
      (expand-file-name "init.el" ddskk-preference-directory)
      skk-custom-file
      (expand-file-name "custom.el" ddskk-preference-directory)
      skk-emacs-id-file
      (expand-file-name "emacs-id" ddskk-preference-directory)
      skk-record-file
      (expand-file-name "record" ddskk-preference-directory))


;; super-smart-find のための設定 (意味あるかな？)
(setq super-smart-find-self-insert-command-list
      '(canna-self-insert-command
        egg-self-insert-command
        self-insert-command
        tcode-self-insert-command-maybe
        skk-insert))

;; YaTeX のときだけ句読点を変更したい
(add-hook 'yatex-mode-hook
          #'(lambda ()
              (require 'skk)
              (setq skk-kutouten-type 'en)))

;; 辞書を 10 分毎に自動保存
(defvar skk-auto-save-jisyo-interval 600)
(defun skk-auto-save-jisyo ()
  (skk-save-jisyo))
(run-with-idle-timer skk-auto-save-jisyo-interval
                     t
                     'skk-auto-save-jisyo)
;;(cancel-function-timers 'skk-auto-save-jisyo)


;;; cmigemo
;;
(el-get 'sync '(cmigemo))


;;; git-modes
;;
(el-get 'sync '(git-modes))


;;; Egg is an Emacs interface to git.
;;

(el-get 'sync '(egg))
(add-to-list 'process-coding-system-alist '("git" utf-8 . utf-8))
(global-set-key (kbd "C-x v s") 'egg-status)
(setq egg-cmd-select-special-buffer t
      egg-buffer-hide-section-type-on-start nil
      egg-buffer-hide-sub-blocks-on-start nil
      egg-confirm-staging nil
      egg-enable-tooltip t
      egg-quit-window-actions
      '((egg-status-buffer-mode kill restore-windows)
        (egg-log-buffer-mode kill restore-windows)
        (egg-commit-buffer-mode kill restore-windows)
        (egg-diff-buffer-mode kill restore-windows)
        (egg-file-log-buffer-mode kill restore-windows)))


;;; auto-save-buffers-enhanced
;;
(el-get 'sync '(auto-save-buffers-enhanced))
(setq auto-save-default nil
      auto-save-buffers-enhanced-include-regexps '(".+")
      auto-save-buffers-enhanced-exclude-regexps '("^not-save-file" "\\.ignore$")
      auto-save-buffers-enhanced-save-scratch-buffer-to-file-p t
      auto-save-buffers-enhanced-cooperate-elscreen-p t
      auto-save-buffers-enhanced-quiet-save-p t)
(define-key global-map "\C-xas" 'auto-save-buffers-enhanced-toggle-activity)
(auto-save-buffers-enhanced t)


;;; elscreen
;;
(setq elscreen-tab-display-control nil
      elscreen-tab-display-kill-screen nil
      elscreen-display-tab t)

(el-get 'sync '(knu-elscreen))
(elscreen-set-prefix-key [(control z)])
(set-face-attribute 'elscreen-tab-background-face nil
                    :foreground "#112"
                    :background "#ccc"
                    :underline nil
                    :height 1.2
                    :box nil)

(set-face-attribute 'elscreen-tab-control-face nil
                    :foreground "#ccc"
                    :background "#112"
                    :underline nil
                    :height 1.2
                    :box nil)

(set-face-attribute 'elscreen-tab-current-screen-face nil
                    :foreground "#ccc"
                    :background "#336"
                    :underline nil
                    :height 1.2
                    :box nil)

(set-face-attribute 'elscreen-tab-other-screen-face nil
                    :foreground "#ccc"
                    :background "#112"
                    :underline nil
                    :height 1.2
                    :box nil)
(elscreen-start)


;;; powerline
;;
(el-get 'sync '(powerline))
(setq powerline-arrow-shape 'helf)

;; color
(setq powerline-color1 "#223"
      powerline-color2 "#334")

(set-face-attribute 'mode-line nil
                    :foreground "#ccc"
                    :background "#113"
                    :height 170
                    :box nil)

(set-face-attribute 'mode-line-inactive nil
                    :foreground "#ccc"
                    :background "#112"
                    :box nil)

(defpowerline mule-info (caddr mode-line-mule-info))
(defpowerline remote    (propertize "%1@" 'help-eco "remote"))
(defpowerline modified-ro "%*%&")
(defpowerline position  "%p (%l,%c)")
(defpowerline global    "%M")

(setq-default mode-line-format
              (list  '(:eval (concat (powerline-make-text      "-"      nil )))
                     '(:eval (concat (powerline-mule-info      'center  nil )))
                     '(:eval (concat (powerline-make-text      ":"      nil )))
                     '(:eval (concat (powerline-modified-ro    'center  nil )))
                     '(:eval (concat (powerline-remote         'center  nil )))
                     '(:eval (concat (powerline-buffer-id      'left    nil )))
                     '(:eval (concat (powerline-narrow         'left    nil  powerline-color1  )))
                     '(:eval (concat (powerline-major-mode     'left         powerline-color1 )))
                     '(:eval (concat (powerline-narrow         'left         powerline-color1  powerline-color2  )))
                     '(:eval (concat (powerline-minor-modes    'left                           powerline-color2  )))
                     ;; Justify right by filling with spaces to right fringe - 16
                     ;; (16 should be computed rahter than hardcoded)
                     ;; '(:eval (propertize " " 'display '((space :align-to (- right-fringe 30)) powerline-color2)))
                     '(:eval (concat (powerline-make-text       "                 "                            powerline-color2  )))
                     '(:eval (concat (powerline-position       'right       powerline-color1  powerline-color2  )))
                     '(:eval (concat (powerline-global         'right  nil  powerline-color1 )))
                     ))


;;; Emacs-Helm
;;
(defalias 'edmacro-subseq 'cl-subseq)

(el-get 'sync '(helm))
(require 'helm-config nil t)
(require 'helm-elisp nil t)
(mapc '(lambda (key)
         (define-key global-map key 'helm-mini))
      (list
       [(control ?:)]
       [(control \;)]
       [(control x)(control :)]
       [(control x)(control \;)]))
(define-key ctl-x-map (kbd "C-y") 'helm-show-kill-ring)
(define-key ctl-x-map (kbd "b") 'helm-buffers-list)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-z h") 'helm-elscreen)
(helm-mode 1)
(setq helm-idle-delay             0.3
      helm-input-idle-delay       0.3
      helm-candidate-number-limit 200
      helm-buffer-max-length 40
      helm-ff-auto-update-initial-value nil)
(define-key helm-c-read-file-map (kbd "C-h") 'delete-backward-char)
(define-key helm-c-read-file-map (kbd "TAB") 'helm-execute-persistent-action)

(setq helm-mini-default-sources
      '(helm-source-buffers-list
        helm-source-recentf
        helm-source-buffer-not-found))

(el-get 'sync '(helm-descbinds))
(require 'helm-descbinds)

(el-get 'sync '(helm-project))
(require 'helm-project)
(global-set-key (kbd "M-t") 'helm-project)


;;; popwin
;;
(el-get 'sync '(popwin))
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer
      anything-samewindow nil)
(push '("\*anything.+" :height 20 :regexp t) popwin:special-display-config)


;;; markdown-mode
;;
(el-get 'sync '(markdown-mode))

(defun markdown-mode-hook-func ()
  "markdown-mode-hook"
  (setq markdown-indent-on-enter nil)
  (define-key markdown-mode-map (kbd "C-c f")   'markdown-indent-region)
  (define-key markdown-mode-map (kbd "C-c b")   'markdown-exdent-region)
  (define-key markdown-mode-map (kbd "C-i")     'markdown-demote)
  (define-key markdown-mode-map (kbd "<tab>")   'markdown-demote)
  (define-key markdown-mode-map (kbd "S-C-i")   'markdown-promote)
  (define-key markdown-mode-map (kbd "<S-tab>") 'markdown-promote)
  (define-key markdown-mode-map (kbd "<C-tab>") 'markdown-promote)
  (define-key markdown-mode-map (kbd "C-c 1")   'markdown-insert-header-setext-1)
  (define-key markdown-mode-map (kbd "C-c 2")   'markdown-insert-header-setext-2)
  (define-key markdown-mode-map (kbd "C-c 3")   'markdown-insert-header-atx-3)
  (define-key markdown-mode-map (kbd "C-c 4")   'markdown-insert-header-atx-4)
  (define-key markdown-mode-map (kbd "M-RET")   'markdown-insert-list-item))

(add-hook 'markdown-mode-hook '(lambda() (markdown-mode-hook-func)))
(add-to-list 'auto-mode-alist '("\.md$" . gfm-mode))


;;; less-css-mode
;;
(el-get 'sync '(less-css-mode))
(setq css-indent-offset 2)


;;; helm-css-scss
;;
(el-get 'sync '(helm-css-scss))


;;; egret-mode
;;
;; (el-get 'sync '(egret-mode))
;; (define-key global-map (kbd "C-c e c") #'egret-el-create-input-buffer)


;;; open-junk-file
;;
(el-get 'sync '(open-junk-file))
(setq open-junk-file-find-file-function #'find-file)
(define-key global-map (kbd "C-x C-z") 'open-junk-file)


;;; Mew
;;
;; Note: Use the source, Luke. (Instead of el-get's recipe).
;; (el-get 'sync '(mew))

;; Optional setup (Read Mail menu):
(setq read-mail-command 'mew
      mew-debug t
      mew-rc-file (expand-file-name "config/packages/mew.el" user-emacs-directory))

;; Optional setup (e.g. C-xm for sending a message):
(autoload 'mew-user-agent-compose "mew" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'mew-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'mew-user-agent
      'mew-user-agent-compose
      'mew-draft-send-message
      'mew-draft-kill
      'mew-send-hook))


;;; twittering-mode
;;
(el-get 'sync '(twittering-mode))
(setq twittering-use-master-password t
      twittering-icon-mode t
      twittering-jojo-mode t
      twittering-status-format "%FILL{%i%s %t%R}")


;;; php-mode
;; 2012-08-01
(el-get 'sync '(php-mode))
(setq auto-mode-alist
      (append
       '(("/\\(PEAR\\|pear\\)/" . php-mode)
         ("\.php$" . php-mode))
       auto-mode-alist))

(defun php-mode-hook-func ()
  (c-set-style "gnu")
  (flymake-mode 1)

  (define-key php-mode-map (kbd "C-c C-[") 'beginning-of-defun)
  (define-key php-mode-map (kbd "C-c C-]") 'end-of-defun)
  (setq tab-width 2
        indent-tabs-mode nil
        show-trailing-whitespace t
        require-final-newline t
        c-basic-offset 2
        ;; コメントのスタイル (必要なければコメントアウトする)
        comment-start "// "
        comment-end   ""
        comment-start-skip "// *")

  (hs-minor-mode 1)
  (c-set-offset 'arglist-intro '+)
  (c-set-offset 'arglist-close 0)
  (c-set-offset 'statement-cont 'c-lineup-math)
  (set (make-local-variable 'dabbrev-abbrev-skip-leading-regexp) "$"))

(add-hook 'php-mode-hook 'php-mode-hook-func)
(add-to-list 'auto-mode-alist '("\\.ctp\\'" . php-mode))

;; C-c C-f でカーソル下の関数のマニュアルを検索
(setq php-search-url "http://jp.php.net/ja/")

;; C-RET でマニュアルページにジャンプ
(setq php-manual-url "http://jp.php.net/manual/ja/")

;; 前/次の関数にジャンプ。キーバインドはお好みで。


;;; web-mode
;;
(el-get 'sync '(web-mode))
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


(setq web-mode-hook nil)
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
              (hs-minor-mode 1)
              (set (make-local-variable 'dabbrev-abbrev-skip-leading-regexp) "$")))


;;; auto-jump-mode
;; 2012-06-23
;; based upon http://d.hatena.ne.jp/rkworks/20120520/1337528737
;; (el-get 'sync '(ace-jump-mode))
;; (when (require 'ace-jump-mode nil t)
;;   (defun add-keys-to-ace-jump-mode (prefix c &optional mode)
;;     (define-key global-map
;;       (read-kbd-macro (concat prefix (string c)))
;;       `(lambda ()
;;          (interactive)
;;          (funcall (if (eq ',mode 'word)
;;                       #'ace-jump-word-mode
;;                     #'ace-jump-char-mode) ,c))))

;;   (loop for c from ?0 to ?9 do (add-keys-to-ace-jump-mode "H-" c))
;;   (loop for c from ?a to ?z do (add-keys-to-ace-jump-mode "H-" c))
;;   (loop for c from ?0 to ?9 do (add-keys-to-ace-jump-mode "H-M-" c 'word))
;;   (loop for c from ?a to ?z do (add-keys-to-ace-jump-mode "H-M-" c 'word))

;;   (setq ns-command-modifier (quote meta)
;;         ns-right-command-modifier (quote hyper)
;;         ns-alternate-modifier (quote super)
;;         ns-right-alternate-modifier (quote alt)))

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


;;; Auto Complete
;; 自動補完
(el-get 'sync '(auto-complete))
(require 'auto-complete)
(global-auto-complete-mode t)
(add-hook 'auto-complete-mode-hook
          (lambda ()
            (define-key ac-completing-map (kbd "C-n") 'ac-next)
            (define-key ac-completing-map (kbd "C-p") 'ac-previous)))


;;; ruby-mode
;; Emacsにバンドルされているruby-modeは古いのでRubyのリポジ
;; トリに入っているものを使う。
;; 2012-03-15
(el-get 'sync '(ruby-mode-trunk))
(el-get 'sync '(ruby-end))
(unless (boundp 'last-command-char)
  (defvaralias 'last-command-char 'last-command-event))

(add-hook 'ruby-mode-hook
          #'(lambda ()
              (set (make-local-variable 'show-trailing-whitespace) t)
              (set (make-local-variable 'dabbrev-abbrev-skip-leading-regexp) ":")))

(setq ruby-indent-level 2
      ruby-indent-tabs-mode nil
      ruby-deep-indent-paren-style nil)

(eval-after-load "develock"
  '(plist-put develock-max-column-plist 'ruby-mode 100))

(mapc #'(lambda (arg)
          (cons arg auto-mode-alist))
      (list '("\\.rb$" . ruby-mode)
            '("Rakefile" . ruby-mode)))

(define-key ruby-mode-map "\C-m" 'reindent-then-newline-and-indent)


;;; rspec-mode
;;
(el-get 'sync '(rspec-mode))
;; http://d.hatena.ne.jp/uk-ar/20110424/1303604763
(setq shell-file-name "/bin/sh")

;;; Rinari Is Not A Rails IDE
;;
(el-get 'sync '(rinari))
(el-get 'sync '(rhtml-mode))
(when (require 'rhtml-mode nil t)
  (set-face-foreground 'erb-face "#aaffff")
  (set-face-background 'erb-face "#090909")
  (set-face-background 'erb-out-delim-face "#090909"))


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


;;; puppet-mode
;;
(el-get 'sync '(puppet-mode))


;;; yaml-mode
;;
(el-get 'sync '(yaml-mode))


;;; js2-mode
;; JavaScript編集用のモード
;; 2012-04-05
(el-get 'sync '(js2-mode))
(setq auto-mode-alist (append '(("\.js$" . js2-mode)) auto-mode-alist))

(add-hook 'js2-mode-hook
          #'(lambda ()
              (setq indent-tabs-mode nil
                    show-trailing-whitespace t
                    flymake-check-was-interrupted t
                    show-trailing-whitespace t
                    js2-basic-offset 2
                    js2-include-browser-externs t
                    js2-include-node-externs t
                    js2-global-externs
                    '("define" "describe" "xdescribe" "expect" "it" "xit"
                      "require" "$" "_" "Backbone" "JSON" "setTimeout" "jasmine"
                      "beforeEach" "afterEach" "spyOn"))
              (hs-minor-mode 1)))

(when (executable-find "jsl")
  (require 'flymake)
  (defun flymake-jsl-init ()
    (list "jsl" (list "-process" (flymake-init-create-temp-buffer-copy
                                  'flymake-create-temp-inplace))))

  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.js\\'" flymake-jsl-init))

  (add-to-list 'flymake-err-line-patterns
               '("^\\(.+\\)(\\([0-9]+\\)): \\(.*warning\\|SyntaxError\\): \\(.*\\)" 1 2 nil 4))

  (add-hook 'js2-mode-hook
            #'(lambda ()
                (flymake-mode 1))))


;;; tiarra-conf-mode
;;
(el-get 'sync '(tiarra-conf-mode))


;;; ag
;;
;; http://kotatu.org/blog/2013/12/18/emacs-ag-wgrep-for-code-grep-search/
;;
;; ag
;; ag(The Silver Searcher)コマンドを以下からインストール:
;;     http://github.com/ggreer/the_silver_searcher#installation
;; ag.elとwgrep-ag.elをlist-packageでMelpaなどからインストールしておく
(el-get 'sync '(ag))
(require 'ag)
(custom-set-variables
 '(ag-highlight-search t)  ; 検索結果の中の検索語をハイライトする
 '(ag-reuse-window 'nil)   ; 現在のウィンドウを検索結果表示に使う
 '(ag-reuse-buffers 'nil)) ; 現在のバッファを検索結果表示に使う

(el-get 'sync '(wgrep))
(require 'wgrep-ag)
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
        (mapcar (lambda (x) (and (funcall condp x) x)) lst)))
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


;;; coffe-mode
;; CoffeeScript編集用のモード
;; 2012-04-04
(el-get 'sync '(coffee-mode))
(defun coffee-custom ()
  "coffee-mode-hook"
  (setq tab-width 2
        coffee-tab-width 2
        show-trailing-whitespace t))

(add-hook 'coffee-mode-hook
  '(lambda() (coffee-custom)))


;;; 追加の設定
;; 個別の設定があったら読み込む
;; 2012-03-15
(load "packages/local" t)
