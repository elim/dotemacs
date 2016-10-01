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

(el-get-bundle ag)
(el-get-bundle anzu)
(el-get-bundle ddskk)
(el-get-bundle editorconfig)
(el-get-bundle elscreen)
(el-get-bundle company-mode)
(el-get-bundle company-quickhelp)
(el-get-bundle flycheck)
(el-get-bundle fujimisakari/microsoft-translator)
(el-get-bundle git-modes)
(el-get-bundle google-translate)
(el-get-bundle helm)
(el-get-bundle helm-css-scss)
(el-get-bundle helm-descbinds)
(el-get-bundle helm-git-grep)
(el-get-bundle helm-projectile)
(el-get-bundle js2-mode)
(el-get-bundle json-mode)
(el-get-bundle migemo)
(el-get-bundle php-mode)
(el-get-bundle popwin)
(el-get-bundle puppet-mode)
(el-get-bundle rainbow-mode)
(el-get-bundle rspec-mode)
(el-get-bundle ruby-end)
(el-get-bundle ruby-mode)
(el-get-bundle slim-mode)
(el-get-bundle twittering-mode)
(el-get-bundle web-mode)
(el-get-bundle wgrep)
(el-get-bundle yaml-mode)

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

;;; go-mode
;;
(el-get-bundle go-mode
  (add-hook 'go-mode-hook
            #'(lambda ()
                (setq tab-width 4))))

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

;;; open-junk-file
;;
(el-get-bundle open-junk-file
  (setq open-junk-file-format "~/.junk/%Y/%m/%d-%H%M%S."
        open-junk-file-find-file-function #'find-file)
  (define-key global-map (kbd "C-x C-z") 'open-junk-file))


(el-get-bundle hg:tiarra-conf-mode
  :description "Emacs mode for editing Tiarra configuration."
  :url "https://bitbucket.org/topia/tiarra"
  :prepare (autoload 'tiarra-conf-mode "tiarra-conf"
             "Major mode for editing Tiarra configuration file." t))

;;; packages.el ends here
