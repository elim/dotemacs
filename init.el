;;; init.el --- A setting of my own Emacs.
;;; Commentary:
;;; Code:

(setq load-prefer-newer t)

(setq user-full-name "Takeru Naito"
      user-mail-address "takeru.naito@gmail.com")

(defun sort-lines-nocase ()
  (interactive)
  (let ((sort-fold-case t))
    (call-interactively 'sort-lines)))

(setq custom-file (expand-file-name "customize.el" user-emacs-directory))
(load custom-file)

;; path and filenames.
(dolist (dir (list
              (expand-file-name "config" user-emacs-directory)
              "/usr/local/share/emacs/site-lisp/"))
  (when (and (file-exists-p dir) (not (member dir load-path)))
    (setq load-path (append (list dir) load-path))))

;;; el-get
;;
;; Use the HEAD instead of the elpa version because this Emacs
;; configuratfion depends many recipes of HEAD on currently.
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(let (el-get-master-branch)
  (unless (require 'el-get nil t)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
      (goto-char (point-max))
      (eval-print-last-sexp))))

;;; leaf.el
;;
(prog1 "prepare leaf"
  (prog1 "package"
    (custom-set-variables
     '(package-archives '(("melpa" . "https://melpa.org/packages/")
                          ("gnu"   . "https://elpa.gnu.org/packages/"))))
    (package-initialize))

  (prog1 "leaf"
    (unless (package-installed-p 'leaf)
      (unless (assoc 'leaf package-archive-contents)
        (package-refresh-contents))
      (condition-case err
          (package-install 'leaf)
        (error
         (package-refresh-contents)       ; renew local melpa cache if fail
         (package-install 'leaf))))

    (leaf leaf-keywords
      :ensure t
      :config (leaf-keywords-init)))

  (prog1 "optional packages for leaf-keywords"
    ;; optional packages if you want to use :hydra, :el-get,,,
    (leaf hydra :ensure t)
    (leaf delight :ensure t)
    (leaf diminish :ensure t))

  (prog1 "el-get settings"
    (leaf el-get
      :custom
      ((el-get-git-shallow-clone  . t)
       (el-get-user-package-directory . (locate-user-emacs-file "config/packages"))))))

(leaf *interfaces
  :config
  (leaf buffer-move
    :ensure t
    :bind (("M-g h" . buf-move-left)
           ("M-g j" . buf-move-down)
           ("M-g k" . buf-move-up)
           ("M-g l" . buf-move-right)))
  (leaf company
    :ensure t
    :bind (("C-M-i" . company-complete)
           (:company-active-map
            ("C-n" . company-select-next)
            ("C-p" . company-select-previous)
            ("C-s" . company-filter-candidates)
            ("C-i" . company-complete-selection)))
    :custom-face ((company-preview-common           . '((nil (:foreground "lightgrey" :underline t))))
                  (company-scrollbar-bg             . '((nil (:background "gray40"))))
                  (company-scrollbar-fg             . '((nil (:background "orange"))))
                  (company-tooltip                  . '((nil (:foreground "black" :background "lightgrey"))))
                  (company-tooltip-common           . '((nil (:foreground "black" :background "lightgrey"))))
                  (company-tooltip-common-selection . '((nil (:foreground "white" :background "steelblue"))))
                  (company-tooltip-selection        . '((nil (:foreground "black" :background "steelblue")))))
    :delight t
    :hook (after-init-hook . global-company-mode))
  (leaf company-quickhelp
    :ensure t
    :config (company-quickhelp-mode +1))
  (leaf elscreen
    :ensure t
    :require t
    :config
    (elscreen-set-prefix-key [(control z)])
    (elscreen-start)
    :custom ((elscreen-tab-display-control . nil)
             (elscreen-tab-display-kill-screen . nil)
             (elscreen-display-tab . t))
    :custom-face ((elscreen-tab-background-face     . '((nil (:foreground "#112" :background "#ccc" :underline nil :box nil))))
                  (elscreen-tab-control-face        . '((nil (:foreground "#ccc" :background "#112" :underline nil :box nil))))
                  (elscreen-tab-current-screen-face . '((nil (:foreground "#ccc" :background "#336" :underline nil :box nil))))
                  (elscreen-tab-other-screen-face   . '((nil (:foreground "#ccc" :background "#112" :underline nil :box nil)))))))

(leaf *minor-modes
  :config
  (leaf anzu
    :ensure t
    :bind (([remap query-replace]        . anzu-query-replace)
           ([remap query-replace-regexp] . anzu-query-replace-regexp))
    :custom ((anzu-use-migemo . t)
             (anzu-mode-lighter . "")
             (anzu-deactivate-region . t)
             (anzu-search-threshold . 1000))
    :config (global-anzu-mode +1))
  (leaf atomic-chrome
    :ensure t
    :custom ((atomic-chrome-default-major-mode . 'markdown-mode)
             (atomic-chrome-url-major-mode-alist
              . '(("github\\.com" . gfm-mode)
                  ("esa\\.io"     . gfm-mode)
                  ("redmine"      . textile-mode))))
    :config
    (atomic-chrome-start-server))
  (leaf google-translate
    :ensure t
    :bind (("C-c t" . google-translate-enja-or-jaen))
    :custom (google-translate-backend-method . 'curl)
    :config
    ;; http://emacs.rubikitch.com/google-translate/
    (defvar google-translate-english-chars "[:ascii:]"
      "If the target string consists of that pattern, it is assumed to be English.")
    (defun google-translate-enja-or-jaen (&optional string)
      "Translates the region, sentence or STRING by Google(with automatic language detection)."
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
         string))))
  (leaf *helm
    :config
    (leaf helm :ensure t
      :require helm-config helm-files
      :bind (("M-x"     . helm-M-x)
             ("C-:"     . helm-mini)
             ("C-;"     . helm-mini)
             ("C-x :"   . helm-mini)
             ("C-x ;"   . helm-mini)
             ("C-x C-:" . helm-mini)
             ("C-x C-;" . helm-mini)
             ("C-x C-y" . helm-show-kill-ring)
             ("C-x C-f" . helm-find-files)
             (:helm-map
              ("C-h" . delete-backward-char)
              ("TAB" . helm-execute-persistent-action)))
      :config (helm-mode 1)
      :custom ((helm-input-idle-delay . 0.3)
               (helm-candidate-number-limit . 200)
               (helm-buffer-max-length . 40)
               (helm-ff-auto-update-initial-value . nil)
               (helm-mini-default-sources
                . '(helm-source-buffers-list
                    helm-source-recentf
                    helm-source-buffer-not-found)))
      :delight helm-mode)
    (leaf helm-ag :ensure t
      :bind ("C-x g" . helm-projectile-ag)
      :custom ((helm-ag-base-command . "ag --nocolor --nogroup --ignore-case")
               (helm-ag-command-option . "--all-text")
               (helm-ag-insert-at-point 'symbol)))
    (leaf helm-css-scss :ensure t)
    (leaf helm-descbinds :ensure t)
    (leaf helm-elscreen :ensure t
      :after helm elscreen
      :bind ("C-z h" . helm-elscreen))
    (leaf helm-git-grep :ensure t)
    (leaf helm-projectile :ensure t
      :after projectile
      :bind ("M-t" . helm-projectile)
      :config (helm-projectile-on)))
  (leaf hideshow
    :bind ((:hs-minor-mode-map
            ("C-c C-M-c" . hs-toggle-hiding)
            ("C-c h"     . hs-toggle-hiding)
            ("C-c l"     . hs-hide-level))))
  (leaf persistent-scratch
    :ensure t
    :init
    (defvar elim:persistent-scratch-save-file
      ((lambda ()
         (expand-file-name
          (format ".persistent-scratch.%s" (system-name)) "~/Dropbox/var/")))
      "Specify the location of the scratch to the file.
Environment-dependent value is generated as initial values.")
    :custom (persistent-scratch-save-file . elim:persistent-scratch-save-file)
    :config (persistent-scratch-setup-default))
  (leaf projectile
    :ensure t
    :config (projectile-mode +1)
    :custom (projectile-enable-caching . t)
    :diminish projectile-mode)
  (leaf real-auto-save
    :ensure t
    :preface
    ;; http://emacs.rubikitch.com/real-auto-save-buffers-enhanced-bug/
    (defun elim:real-auto-save-start-timer--idle-timer ()
      "Start real-auto-save-timer."
      (set-variable 'real-auto-save-timer
                    (run-with-idle-timer real-auto-save-interval
                                         real-auto-save-interval 'real-auto-save-buffers)))
    :advice (:override real-auto-save-start-timer elim:real-auto-save-start-timer--idle-timer)
    :custom ((real-auto-save-interval . 0.5))
    :hook (find-file-hook . real-auto-save-mode))
  (leaf skk
    :ensure ddskk
    :require t
    :bind (("C-x C-j" . skk-mode)
           ("C-x t" . nil)
           ("C-x j" . nil))
    :custom ((default-input-method . "japanese-skk")
             (skk-jisyo-code . 'utf-8)
             (skk-count-private-jisyo-candidates-exactly . t)
             (skk-share-private-jisyo . t)
             (skk-server-host . "localhost")
             (skk-server-portnum . 1178)
             (skk-japanese-message-and-error . t)
             (skk-kutouten-type . 'jp)
             (skk-show-annotation . t)
             (skk-henkan-strict-okuri-precedence . t)
             (skk-check-okurigana-on-touroku . 'auto)
             (skk-isearch-start-mode . 'latin)
             (skk-search-sagyo-henkaku . t))
    :config
    (condition-case nil
        (skk-server-version)
      (error
       (let
           ((dic-file "/usr/share/skk/SKK-JISYO.L"))
         (and (file-exists-p dic-file)
              (set-variable 'skk-jisyo-code nil)
              (set-variable 'skk-large-jisyo dic-file)))))
    (let
        ((skk-auto-save-jisyo-interval 6))
      (run-with-idle-timer skk-auto-save-jisyo-interval t
                           #'skk-save-jisyo))
    (skk-mode -1))
  (leaf undo-tree
    :ensure t
    :custom (undo-tree-enable-undo-in-region . nil)
    :config (global-undo-tree-mode t)))

(leaf *major-modes
  :config
  (leaf elisp-mode
    :hook (emacs-lisp-mode-hook . elim:emacs-lisp-mode-hook-func)
    :config
    (defun elim:emacs-lisp-mode-hook-func ()
      (set-variable 'indent-tabs-mode nil)
      (hs-minor-mode +1)
      (hs-hide-level 3)))
  (leaf magit
    :ensure t
    :bind ("C-x v s" . magit-status)
    :hook (git-commit-setup-hook . elim:git-commit-setup-hook-func)
    :init (add-to-list 'process-coding-system-alist '("git" utf-8 . utf-8))
    :config
    (defun elim:git-commit-setup-hook-func ()
      (flyspell-mode +1)
      (set (make-local-variable
            'elim:auto-delete-trailing-whitespace-enable-p) nil))
    :delight auto-revert-mode)
  (leaf vue-mode
    :ensure t)
  (leaf web-mode
    :ensure t
    :mode ("\\.ctp\\'" "\\.p?html?\\'" "\\.html.erb\\'")
    :custom ((web-mode-block-padding . 2)
             (web-mode-comment-style . 2)
             (web-mode-enable-engine-detection . t)
             (web-mode-indent-style . 2)
             (web-mode-script-padding . 2)
             (web-mode-style-padding . 2))))

;; Preferred libraries
(el-get-bundle tarao/with-eval-after-load-feature-el)
(el-get-bundle use-package)

(load "environment")
(load "builtins")
(load "packages")
(load "theme")
(load "local" t)

;;; init.el ends here
