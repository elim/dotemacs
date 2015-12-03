;;; packages.el --- A setting of the packages.
;;; Commentary:
;;; Code:

;;; el-get
;;
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(let (el-get-master-branch)
  (unless (require 'el-get nil t)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
      (goto-char (point-max))
      (eval-print-last-sexp))))

(setq el-get-user-package-directory (locate-user-emacs-file "config/packages"))

(el-get-bundle tarao/with-eval-after-load-feature-el)

;;; ag
;;
;; http://kotatu.org/blog/2013/12/18/emacs-ag-wgrep-for-code-grep-search/
;;
;; ag
;; ag(The Silver Searcher)コマンドを以下からインストール:
;;     http://github.com/ggreer/the_silver_searcher#installation
;; ag.elとwgrep-ag.elをlist-packageでMelpaなどからインストールしておく
(el-get-bundle ag
  :features ag
  :depends (dash s wgrep)

  (custom-set-variables
   '(ag-highlight-search t)  ; 検索結果の中の検索語をハイライトする
   '(ag-reuse-window 'nil)   ; 現在のウィンドウを検索結果表示に使う
   '(ag-reuse-buffers 'nil)) ; 現在のバッファを検索結果表示に使う

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
                       (car (my/get-buffer-window-list-regexp "^\\*ag "))))))

;;; Auto Complete
;; 自動補完
(el-get-bundle auto-complete
  :features auto-complete
  (global-auto-complete-mode t)
  (add-hook 'auto-complete-mode-hook
            #'(lambda ()
              (define-key ac-completing-map (kbd "C-n") 'ac-next)
              (define-key ac-completing-map (kbd "C-p") 'ac-previous))))

;;; auto-save-buffers-enhanced
;;
(el-get-bundle elim/auto-save-buffers-enhanced
  :features auto-save-buffers-enhanced
  (setq auto-save-default nil
        auto-save-buffers-enhanced-include-regexps '(".+")
        auto-save-buffers-enhanced-exclude-regexps '("^not-save-file" "\\.ignore$")
        auto-save-buffers-enhanced-save-scratch-buffer-to-file-p t
        auto-save-buffers-enhanced-cooperate-elscreen-p t
        auto-save-buffers-enhanced-quiet-save-p t)
  (define-key global-map "\C-xas" 'auto-save-buffers-enhanced-toggle-activity)
  (auto-save-buffers-enhanced t))

;;; clipboard-to-kill-ring
;; original: http://hitode909.hatenablog.com/entry/20110924/1316853933
;; modified: https://gist.github.com/elim/666807b53f2b2cf503c1
(el-get-bundle gist:666807b53f2b2cf503c1:clipboard-to-kill-ring
  :depends (deferred)
  :features (clipboard-to-kill-ring)
  (clipboard-to-kill-ring t))

;;; ddskk
;;
(el-get-bundle ddskk
  (with-eval-after-load-feature 'skk
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
                         'skk-auto-save-jisyo)))

;;; editorconfig
;;
(when (executable-find "editorconfig")
  (el-get-bundle editorconfig))

;;; elscreen
;;
(el-get-bundle knu/elscreen
  :description "Screen Manager for Emacsen"
  :features elscreen
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

  :prepare (setq elscreen-tab-display-control nil
                 elscreen-tab-display-kill-screen nil
                 elscreen-display-tab t)
  (elscreen-start))

;;; Flycheck
;;
(el-get-bundle flycheck
  (add-hook 'after-init-hook #'global-flycheck-mode))

;;; ginger-api
;;
(el-get-bundle gist:5457732:ginger-api
  :depends (json popwin request)
  (global-set-key (kbd "C-c g") 'ginger-region))

;;; ginger-rephrase-api
;;
(el-get-bundle gist:7349439:ginger-rephrase-api
  :depends (popwin request)
  (global-set-key (kbd "C-c r") 'ginger-rephrase))

;;; git-modes
;;
(el-get-bundle git-modes)

;;; go-mode
;;
(el-get-bundle go-mode
  (add-hook 'go-mode-hook
            #'(lambda ()
                (setq tab-width 4))))

;;; google-translate
;;
(el-get-bundle elim/google-translate
  :branch "redo"
  :depends popwin
  (autoload 'google-translate-translate "google-translate" nil t)

  (defvar google-translate-english-chars "[:ascii:]"
    "これらの文字が含まれているときは英語とみなす")

  (defun google-translate-enja-or-jaen (&optional string)
    "regionか、現在のセンテンスを言語自動判別でGoogle翻訳する。"
    (interactive)
    (setq string
          (cond ((stringp string) string)
                (current-prefix-arg
                 (read-string "Google Translate: "))
                ((use-region-p)
                 (buffer-substring (region-beginning) (region-end)))
                (t
                 (save-excursion
                   (let (s)
                     (forward-char 1)
                     (backward-sentence)
                     (setq s (point))
                     (forward-sentence)
                     (buffer-substring s (point)))))))
    (let* ((asciip (string-match
                    (format "\\`[%s]+\\'" google-translate-english-chars)
                    string)))
      (run-at-time 0.1 nil 'deactivate-mark)
      (google-translate-translate
       (if asciip "en" "ja")
       (if asciip "ja" "en")
       string)))

  (global-set-key (kbd "C-c t") 'google-translate-enja-or-jaen))

;;; Helm
;;
(el-get-bundle helm)
(el-get-bundle helm-css-scss)

(el-get-bundle helm-descbinds
    :features helm-descbinds)

(el-get-bundle projectile
    :features helm-projectile
    (helm-projectile-on)
    (global-set-key (kbd "M-t") 'helm-projectile))

;;; js2-mode
;; JavaScript編集用のモード
;; 2012-04-05
(el-get-bundle js2-mode
  (setq auto-mode-alist (append '(("\.js$" . js2-mode)) auto-mode-alist))

  (with-eval-after-load-feature 'js2-mode
    (add-hook 'js2-mode-hook
              #'(lambda ()
                  (setq indent-tabs-mode nil
                        show-trailing-whitespace t
                        js2-basic-offset 2
                        js2-include-browser-externs t
                        js2-include-node-externs t
                        js2-global-externs
                        '("define" "describe" "xdescribe" "expect" "it" "xit"
                          "require" "$" "_" "angular" "Backbone" "JSON" "setTimeout" "jasmine"
                          "beforeEach" "afterEach" "spyOn"))
                  (hs-minor-mode 1)))))

;;; less-css-mode
;;
(el-get-bundle less-css-mode
  (setq css-indent-offset 2))

;;; magit
;;
(el-get-bundle magit
  (global-set-key (kbd "C-x v s") 'magit-status)
  (add-to-list 'process-coding-system-alist '("git" utf-8 . utf-8)))

;;; markdown-mode
;;
(el-get-bundle markdown-mode
  (add-to-list 'auto-mode-alist '("\.md$" . gfm-mode))

  (with-eval-after-load-feature 'markdown-mode
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
    (define-key markdown-mode-map (kbd "M-RET")   'markdown-insert-list-item)))

;;; Mew
;;
(el-get-bundle mew
  ;; Optional setup (Read Mail menu):

  (with-eval-after-load-feature 'mew
    (setq read-mail-command 'mew
          mew-debug t
          mew-rc-file (expand-file-name "config/packages/mew.el" user-emacs-directory)))

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
        'mew-send-hook)))

;;; migemo
;;
(el-get-bundle migemo)

;;; open-junk-file
;;
(el-get-bundle open-junk-file
  (setq open-junk-file-format "~/.junk/%Y/%m/%d-%H%M%S."
        open-junk-file-find-file-function #'find-file)
  (define-key global-map (kbd "C-x C-z") 'open-junk-file))

;;; php-mode
;;
(el-get-bundle php-mode

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
      (c-set-offset 'statement-cont 'c-lineup-math)

      (with-eval-after-load-feature 'dabbrev
        (set (make-local-variable dabbrev-abbrev-skip-leading-regexp) "$")))

    (add-hook 'php-mode-hook 'php-mode-hook-func)
    (add-to-list 'auto-mode-alist '("\\.ctp\\'" . php-mode))

    ;; C-c C-f でカーソル下の関数のマニュアルを検索
    (setq php-search-url "http://jp.php.net/ja/")

    ;; C-RET でマニュアルページにジャンプ
    (setq php-manual-url "http://jp.php.net/manual/ja/")))

;;; popwin
;;
(el-get-bundle popwin)
(el-get-bundle powerline)
(el-get-bundle puppet-mode)

;;; rspec-mode
;;
(el-get-bundle rspec-mode
  ;; http://d.hatena.ne.jp/uk-ar/20110424/1303604763
  (setq shell-file-name "/bin/sh"))

;;; ruby-mode
;;
(el-get-bundle ruby-mode
  (el-get-bundle ruby-end)

  (unless (boundp 'last-command-char)
    (defvaralias 'last-command-char 'last-command-event))

  (with-eval-after-load-feature 'dabbrev
    (add-hook 'ruby-mode-hook
              #'(lambda ()
                  (set (make-local-variable 'show-trailing-whitespace) t)
                  (set (make-local-variable 'dabbrev-abbrev-skip-leading-regexp) ":"))))

  (setq ruby-indent-level 2
        ruby-indent-tabs-mode nil
        ruby-deep-indent-paren-style nil)

  (mapc #'(lambda (arg)
            (cons arg auto-mode-alist))
        (list '("\\.rb$" . ruby-mode)
              '("Rakefile" . ruby-mode)))

  (define-key ruby-mode-map "\C-m" 'reindent-then-newline-and-indent)

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
        (when (> offset 0) (forward-char offset))))))

;;; tiarra-conf-mode
;;
(el-get-bundle svn:tiarra-conf-mode
  :description "Emacs mode for editing Tiarra configuration."
  :url "http://svn.coderepos.org/share/lang/perl/tiarra/trunk"
  :prepare (autoload 'tiarra-conf-mode "tiarra-conf"
             "Major mode for editing Tiarra configuration file." t))

;;; twittering-mode
;;
(el-get-bundle twittering-mode
  (setq twittering-use-master-password t
        twittering-icon-mode t
        twittering-jojo-mode t
        twittering-status-format "%FILL{%i%s %t%R}"))

;;; visual-regexp
;;
(el-get-bundle visual-regexp
  (global-set-key (kbd "M-%")   'vr/query-replace)
  (global-set-key (kbd "C-M-%") 'vr/replace))

;;; web-mode
;;
(el-get-bundle web-mode
  (with-eval-after-load-feature 'web-mode
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
                  (hs-minor-mode 1)
                  (with-eval-after-load-feature 'dabbrev
                    (set (make-local-variable 'dabbrev-abbrev-skip-leading-regexp) "$"))))))

;;; wgrep
;;
(el-get-bundle wgrep
  :features (wgrep wgrep-ag))


;;; yaml-mode
;;
(el-get-bundle yaml-mode)

;;; packages.el ends here
