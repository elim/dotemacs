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
(defun noninteractive ())
(el-get 'sync '(ddskk))

(setq skk-indicator-use-cursor-color nil)
(global-set-key "\C-x\C-j" 'skk-mode)
(global-set-key "\C-xj" nil)
(global-set-key "\C-xt" nil)
;; (global-set-key "\C-xj" 'skk-auto-fill-mode)
;; (global-set-key "\C-xt" 'skk-tutorial)

(mapc '(lambda (lib)
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
(add-hook 'isearch-mode-hook 'skk-isearch-mode-setup)
(add-hook 'isearch-mode-end-hook 'skk-isearch-mode-cleanup)
;; migemo を使うから skk-isearch にはおとなしくしていて欲しい
;; (setq skk-isearch-start-mode 'latin)

;; @@ 応用的な設定

;; ~/.skk* なファイルがたくさんあるので整理したい
(setq ddskk-preference-directory
      (expand-file-name "ddskk" user-emacs-directory))
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
          (lambda ()
            (require 'skk)
            (setq skk-kutouten-type 'en)))

;; 辞書を 10 分毎に自動保存
(defvar skk-auto-save-jisyo-interval 600)
(defun skk-auto-save-jisyo ()
  (skk-save-jisyo)
  (skk-bayesian-save-history)
  (skk-bayesian-corpus-save))
(run-with-idle-timer skk-auto-save-jisyo-interval
                     t
                     'skk-auto-save-jisyo)
;;(cancel-function-timers 'skk-auto-save-jisyo)


;;; session
;;
; (el-get 'sync '(session))
(el-get 'sync '(emacs-goodies-el))
(when (require 'session nil t)
  (setq history-length t
        session-save-file-coding-system 'utf-8-unix
        session-initialize '(de-saveplace session keys menus places)
        session-globals-include '((kill-ring 1024)
                                  (session-file-alist 1024 t)
                                  (file-name-history 1024))
        session-globals-max-size 1024
        session-globals-max-string 1024
        session-save-file (expand-file-name
                           "session-save.el" user-emacs-directory))
  (add-hook 'after-init-hook 'session-initialize))


;;; New clmemo
;; http://at-aka.blogspot.jp/2012/09/clmemo-blgrep-github.html
;;

(el-get 'sync '(clmemo))
(define-key ctl-x-map "M" 'clmemo)
(setq clmemo-file-name "~/Dropbox/clmemo.txt"
      clmemo-time-string-with-weekday t
      clmemo-title-list '("diary" "monay" "idea" "computer"))


;;; blgrep (clgrep.el)
;;
(add-hook 'clmemo-mode-hook
   '(lambda ()
      (define-key clmemo-mode-map "\C-c\C-g" 'clgrep)
      (define-key clmemo-mode-map "\C-c," 'quasi-howm)))

(add-hook 'change-log-mode-hook
   '(lambda ()
      (define-key change-log-mode-map "\C-c\C-g" 'blg-changelog)
      (define-key change-log-mode-map "\C-c\C-i" 'blg-changelog-item-heading)
      (define-key change-log-mode-map "\C-c\C-d" 'blg-changelog-date)))

(add-hook 'outline-mode-hook
   '(lambda ()
      (define-key outline-mode-map "\C-c\C-g" 'blg-outline)
      (define-key outline-mode-map "\C-c1" 'blg-outline-line)))
(add-hook 'outline-minor-mode-hook
   '(lambda ()
      (define-key outline-minor-mode-map "\C-c\C-g" 'blg-outline)
      (define-key outline-minor-mode-map "\C-c1" 'blg-outline-line)))
(el-get 'sync '(blgrep))


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
(define-key global-map "\C-xas" 'auto-save-buffers-enhanced-toggle-activity)
(auto-save-buffers-enhanced t)


;;; elscreen
;;
(el-get 'sync '(knu-elscreen))
(elscreen-set-prefix-key [(control l)])
(set-face-attribute 'elscreen-tab-background-face nil
                    :foreground "#112"
                    :background "#ccc"
		    :underline nil
                    :box nil)

(set-face-attribute 'elscreen-tab-control-face nil
                    :foreground "#ccc"
                    :background "#112"
		    :underline nil
                    :box nil)

(set-face-attribute 'elscreen-tab-current-screen-face nil
                    :foreground "#ccc"
                    :background "#336"
		    :underline nil
                    :box nil)

(set-face-attribute 'elscreen-tab-other-screen-face nil
                    :foreground "#ccc"
                    :background "#112"
		    :underline nil
                    :box nil)
(setq elscreen-display-tab t)


;;; powerline
;;
(el-get 'sync '(powerline))

(setq powerline-arrow-shape 'curve)

;; color
(setq powerline-color1 "#223"
      powerline-color2 "#334")

(set-face-attribute 'mode-line nil
                    :foreground "#ccc"
                    :background "#113"
                    :box nil)

(set-face-attribute 'mode-line-inactive nil
                    :foreground "#ccc"
                    :background "#112"
                    :box nil)
                                        ;
(defpowerline mule-info (caddr mode-line-mule-info))
                                        ; とりあえず propertize だけ拾った
(defpowerline remote    (propertize "%1@" 'help-eco "remote"))
(defpowerline modified-ro "%*%&")
(defpowerline position  "%p (%l,%c)")
(defpowerline global    "%M")
                                        ;
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
(push '("\*anything.+" :height 20 :regexp t) popwin:special-display-config)


;;; direx
;;
(el-get 'sync '(direx))
(push '(direx:direx-mode :position left :width 25 :dedicated t)
      popwin:special-display-config)

;; (define-key global-map (kbd "C-x C-f") 'direx:jump-to-directory-other-window)
;; (define-key direx:direx-mode-map (kbd "C-x C-f") 'find-file)


;;; markdown-mode
;;
(el-get 'sync '(markdown-mode))


;;; less-css-mode
;;
(el-get 'sync '(less-css-mode))


;;; egret-mode
;;
(el-get 'sync '(egret-mode))
(define-key global-map (kbd "C-c e c") #'egret-el-create-input-buffer)


;;; open-junk-file
;;
(el-get 'sync '(open-junk-file))
(setq open-junk-file-find-file-function #'find-file)
(define-key global-map (kbd "C-x C-z") 'open-junk-file)


;;; Mew
;;
;; (el-get 'sync '(mew))

;; Optional setup (Read Mail menu):
;; (setq read-mail-command 'mew
;;       mew-debug t
;;       mew-rc-file (expand-file-name "~/.emacs.d/config/packages/mew.el"))

;; Optional setup (e.g. C-xm for sending a message):
;; (autoload 'mew-user-agent-compose "mew" nil t)
;; (if (boundp 'mail-user-agent)
;;     (setq mail-user-agent 'mew-user-agent))
;; (if (fboundp 'define-mail-user-agent)
;;     (define-mail-user-agent
;;       'mew-user-agent
;;       'mew-user-agent-compose
;;       'mew-draft-send-message
;;       'mew-draft-kill
;;       'mew-send-hook))


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
  (define-key php-mode-map (kbd "C-c C-[") 'beginning-of-defun)
  (define-key php-mode-map (kbd "C-c C-]") 'end-of-defun)
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


;;; puppet-mode
;;
(el-get 'sync '(puppet-mode))


;;; js2-mode
;; JavaScript編集用のモード
;; 2012-04-05
(el-get 'sync '(js2-mode))
(when (executable-find "jsl")
  (require 'flymake)
  (defun flymake-jsl-init ()
    (list "jsl" (list "-process" (flymake-init-create-temp-buffer-copy
                                  'flymake-create-temp-inplace))))

  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.js\\'" flymake-jsl-init))

  (add-to-list 'flymake-err-line-patterns
               '("^\\(.+\\)(\\([0-9]+\\)): \\(.*warning\\|SyntaxError\\): \\(.*\\)" 1 2 nil 4))

  (defun js2-mode-hook-func ()
    (setq flymake-check-was-interrupted t)
    (flymake-mode 1)
    (setq indent-tabs-mode nil))

  (add-hook 'js2-mode-hook 'js2-mode-hook-func))


;;; coffe-mode
;; CoffeeScript編集用のモード
;; 2012-04-04
(el-get 'sync '(coffee-mode))


;;; 追加の設定
;; 個別の設定があったら読み込む
;; 2012-03-15
(load "config/packages/local" t)
