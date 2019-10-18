;;; init.el --- A setting of my own Emacs. -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(set-variable 'debug-on-error t)
(set-variable 'init-file-debug t)
(set-variable 'load-prefer-newer t)

;;; leaf.el
;;
(prog1 "leaf"
  (prog1 "install leaf"
    (custom-set-variables
     '(package-archives '(("org"   . "https://orgmode.org/elpa/")
                          ("melpa" . "https://melpa.org/packages/")
                          ("gnu"   . "https://elpa.gnu.org/packages/"))))
    (package-initialize)
    (unless (package-installed-p 'leaf)
      (package-refresh-contents)
      (package-install 'leaf)))

  (leaf leaf-keywords
    :ensure t
    :config
    ;; optional packages if you want to use :hydra, :el-get,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t
      :custom ((el-get-git-shallow-clone . t)))

    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

(leaf *first-priority
  :doc
  Those are the minimal setting and/or another setting depend on that.
  Do not nest the other settings because of that prevent the confusion
  the evaluation order.
  :preface
  (defvar elim:user-variables-directory
    (expand-file-name (format "%s/%s/" "~/Dropbox/var/emacs" (system-name)))
    "Store variable files into this directory.")
  (make-directory elim:user-variables-directory t)
  :custom `((enable-recursive-minibuffers . t)
            (gc-cons-threshold . ,(* 128 1024 1024))
            (select-enable-clipboard . t)
            (user-mail-address . "takeru.naito@gmail.com")
            (user-full-name . "Takeru Naito"))
  :config
  (defalias 'yes-or-no-p 'y-or-n-p)

  (leaf smart-mode-line
    :ensure t
    :custom ((sml/no-confirm-load-theme . t)
             (sml/theme . 'dark))
    :config (sml/setup)))

(leaf *environments
  :config
  (leaf *customize
    :custom `((custom-file
               . ,(expand-file-name "customize.el"
                                     elim:user-variables-directory)))
    :config
    (load custom-file))
  (leaf cocoa
    :custom ((ns-use-native-fullscreen . nil)))
  (leaf frame
    :if window-system
    :preface
    (defun elim:frame-fullscreen ()
      (set-frame-parameter nil 'fullscreen 'fullboth))
    :config
    (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
    (add-to-list 'default-frame-alist '(ns-appearance . dark))
    :custom ((line-spacing . 4))
    :hook (window-setup-hook . elim:frame-fullscreen))
  (leaf *fonts
    :preface
    (defun elim:set-text-height (height)
      "Set to the HEIGHT and the family to the default face and some faces."
      (let* ((asciifont "Cica") ; ASCII fonts
             (jpfont "Cica") ; Japanese fonts
             (fontspec (font-spec :family asciifont :weight 'normal))
             (jp-fontspec (font-spec :family jpfont :weight 'normal)))
        (set-face-attribute 'default     nil :family asciifont :height height)
        (set-face-attribute 'fixed-pitch nil :family asciifont :height height)
        (set-fontset-font nil 'japanese-jisx0213.2004-1 jp-fontspec)
        (set-fontset-font nil 'japanese-jisx0213-2      jp-fontspec)
        (set-fontset-font nil 'katakana-jisx0201        jp-fontspec)
        (set-fontset-font nil '(#x0080 . #x024F)           fontspec)
        (set-fontset-font nil '(#x0370 . #x03FF)           fontspec)))
    (defun elim:change-interactive-text-height ()
      (interactive)
      (let
          ((height (face-attribute 'default :height))
           (step 10) (char nil))
        (catch 'end:flag
          (while t
            (message "change text height. p:up n:down height:%s" height)
            (setq char (read-char))
            (cond
             ((= char ?p)
              (setq height (+ height step)))
             ((= char ?n)
              (setq height (- height step)))
             ((and (/= char ?p) (/= char ?n))
              (message "quit text height:%s" height)
              (throw 'end:flag t)))
            (elim:set-text-height height)))))
    :config
    (cond
     ((eq window-system 'ns)
      (set-variable 'ns-antialias-text t)
      (elim:set-text-height 180))
     ((eq window-system 'x)
      (elim:set-text-height 140))))
  (leaf ns-win
    :if (featurep 'ns)
    :custom ((ns-pop-up-frames . nil)
             (ns-antialias-text . t)
             (ns-command-modifier . 'meta)
             (ns-alternate-modifier . 'meta)))
  (leaf simple
    :preface
    (defvar elim:auto-delete-trailing-whitespace-enable-p t)
    (defun elim:editorconfig-mode-enabled-p ()
      (not (not (memq 'editorconfig-mode (mapcar #'car minor-mode-alist)))))
    (defun elim:auto-delete-trailing-whitespace ()
      (and elim:auto-delete-trailing-whitespace-enable-p
           (not (elim:editorconfig-mode-enabled-p))
           (delete-trailing-whitespace)))
    :bind (("<delete>" . delete-char)
           ("C-h"      . delete-char)
           ("C-m"      . newline-and-indent)
           ("C-x |"    . split-window-right)
           ("C-x -"    . split-window-below))
    :custom ((kill-ring-max . 8192))
    :config
    (keyboard-translate ?\C-h ?\C-?)
    (line-number-mode +1)
    (transient-mark-mode t)
    :hook (before-save-hook . elim:auto-delete-trailing-whitespace))
  (leaf vc
    :custom (vc-follow-symlinks . t)))

(leaf *utilities
  :config t
  (leaf browse-url
    :bind ("C-x m" . browse-url-at-point))
  (leaf bs
    :bind ("C-x C-b" . bs-show))
  (leaf clipmon
    :ensure t
    :hook (after-init-hook . clipmon-mode-start))

  (leaf dabbrev
    :custom ((dabbrev-abbrev-skip-leading-regexp . "\\$")))
  (leaf desktop
    :custom ((desktop-save-mode . +1))
    :config
    (add-to-list 'desktop-globals-to-save 'extended-command-history)
    (add-to-list 'desktop-globals-to-save 'kill-ring)
    (add-to-list 'desktop-globals-to-save 'log-edit-comment-ring)
    (add-to-list 'desktop-globals-to-save 'read-expression-history))
  (leaf files
    :if (executable-find "gls")
    :custom ((insert-directory-program . "gls")))
  (leaf find-func
    :config
    ;; C-x F => Find Function
    ;; C-x V => Find Variable
    ;; C-x K => Find Function on Key
    (find-function-setup-keys))
  (leaf dictionary
    :if (eq system-type 'darwin)
    :preface
    (defun elim:dictionary-search (word)
      (browse-url
       (concat "dict:///" (url-hexify-string word))))
    (defun elim:dictionary-word ()
      (interactive)
      (elim:dictionary-search
       (substring-no-properties (thing-at-point 'word))))
    (defun elim:dictionary-region (beg end)
      (interactive "r")
      (elim:dictionary-search
       (buffer-substring-no-properties beg end)))
    :bind (("C-x e" . elim:dictionary-word)
           ("C-x y" . elim:dictionary-region)))
  (leaf open-junk-file
    :ensure t
    :bind (("C-x C-z" . open-junk-file))
    :custom ((open-junk-file-format . "~/.junk/%Y/%m/%d-%H%M%S.")
             (open-junk-file-find-file-function . 'find-file)))
  (leaf sort
    :config
    (defun elim:sort-lines-nocase ()
      "Ignore case when the sort the lines."
      (interactive)
      (let ((sort-fold-case t))
        (call-interactively 'sort-lines)))
    (defalias 'sort-lines-nocase #'elim:sort-lines-nocase)))

(leaf *interfaces
  :custom ((frame-title-format . `(" %b " (buffer-file-name "( %f )")))
           (inhibit-startup-screen . t)
           (mouse-drag-copy-region . t)
           (read-buffer-completion-ignore-case . t)
           (read-file-name-completion-ignore-case .  t)
           (require-final-newline . t)
           (ring-bell-function . 'ignore)
           (scroll-conservatively . 1)
           (select-active-regions . nil)
           (show-trailing-whitespace . nil)
           (truncate-lines . nil)
           (visible-bell . t))
  :config
  (put 'narrow-to-region 'disabled nil)
  (put 'dired-find-alternate-file 'disabled nil)
  (set-default 'indent-tabs-mode nil)
  (set-default 'cursor-in-non-selected-windows nil)
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
    :diminish company-mode
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
                  (elscreen-tab-other-screen-face   . '((nil (:foreground "#ccc" :background "#112" :underline nil :box nil))))))
  (leaf executable
    :config
    (defun elim:executable-make-buffer-file-executable-if-script-p ()
      (unless (string-match tramp-file-name-regexp (buffer-file-name))
        (executable-make-buffer-file-executable-if-script-p)))
    :hook (after-save-hook . elim:executable-make-buffer-file-executable-if-script-p))
  (leaf font-core
    :config (global-font-lock-mode t))
  (leaf menu-bar
    :config (menu-bar-mode +1))
  (leaf migemo
    :ensure t
    :require t
    :custom ((migemo-coding-system . 'utf-8-unix)
             (migemo-command . "/usr/local/bin/cmigemo")
             (migemo-options . '("-q" "--emacs"))
             (migemo-dictionary . "/usr/local/share/migemo/utf-8/migemo-dict"))
    :config (migemo-init))
  (leaf popwin
    :ensure t
    :require t
    :custom ((popwin:popup-window-position . 'bottom)
             (popwin:popup-window-height . 20))
    :config
    (push '("*Google Translate*") popwin:special-display-config)
    (popwin-mode +1))
  (leaf rotate :ensure t)
  (leaf *sky-color-clock
    :disabled t
    :require json
    :config
    (let*
        ((credential-file "~/.config/openweathermap/credential.json")
         (json (json-read-file credential-file))
         (api-key (alist-get 'apiKey json))
         (city-id (alist-get 'cityId json)))
      (leaf sky-color-clock
        :el-get zk-phi/sky-color-clock
        :after smart-mode-line
        :require t
        :preface
        :custom ((sky-color-clock-format . "")
                 (sky-color-clock-enable-emoji-icon . t)
                 (sky-color-clock-enable-temperature-indicator . t))
        :config
        (sky-color-clock-initialize 35)
        (sky-color-clock-initialize-openweathermap-client api-key city-id)
        (setq-default mode-line-format
                      (add-to-list 'mode-line-format '(:eval (sky-color-clock)) t)))))
  (leaf scroll-bar
    :config
    (column-number-mode +1)
    (set-scroll-bar-mode 'right)
    (scroll-bar-mode -1))
  (leaf select
    :custom (select-enable-primary . t))
  (leaf wgrep
    :ensure t
    :custom ((wgrep-auto-save-buffer . t)))
  (leaf *theme
    :config
    (leaf *builtins
      :disabled t
      :config
      (load-theme 'tango-dark t))
    (leaf doom-themes
      :ensure t
      :custom ((doom-themes-enable-italic . t)
               (doom-themes-enable-bold . nil))
      :config
      ;; (load-theme 'doom-city-lights t)
      ;; (load-theme 'doom-dracula t)
      ;; (load-theme 'doom-nord t)
      (load-theme 'doom-one t)
      ;; (doom-themes-neotree-config)
      ;; (doom-themes-org-config)
      (set-face-attribute 'show-paren-match nil :weight 'normal)))
  (leaf time
    :custom ((display-time-24hr-format . t))
    :config (display-time))
  (leaf tool-bar
    :preface
    (defun elim:disable-tool-bar () (tool-bar-mode -1))
    :hook (window-setup-hook . elim:disable-tool-bar))
  (leaf uniquify
    :custom ((uniquify-buffer-name-style . 'post-forward-angle-brackets)
             (uniquify-ignore-buffers-re . "*[^*]+*")
             (uniquify-min-dir-content   . 1))))

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
  (leaf autorevert
    :config
    (global-auto-revert-mode t))
  (leaf auto-save-visited-mode
    :bind ("C-x as" . auto-save-visited-mode)
    :config (auto-save-visited-mode)
    :custom ((auto-save-visited-interval . 0.5)))
  (leaf *dired
    :config
    (leaf dired
      :bind (:dired-mode-map
             ("SPC" . elim:dired-toggle-mark)
             ("r" . dired-toggle-read-only))
      :custom ((dired-recursive-copies . 'always)
               (dired-recursive-deletes . 'always))
      :preface
      ;; Mark with space (like the FD)
      (defun elim:dired-toggle-mark (arg)
        "Toggle the current (or next ARG) files."
        ;; S.Namba Sat Aug 10 12:20:36 1996
        (interactive "P")
        (let ((dired-marker-char
               (if (save-excursion (beginning-of-line)
                                   (looking-at " "))
                   dired-marker-char ?\040)))
          (dired-mark arg)
          (dired-next-line 0))))
    (leaf dired-x
      :custom ((dired-bind-jump . nil)
               (dired-guess-shell-alist-user
                . '(("\\.tar\\.gz\\'"  "tar tzvf")
                    ("\\.taz\\'" "tar ztvf")
                    ("\\.tar\\.bz2\\'" "tar tjvf")
                    ("\\.zip\\'" "unzip -l")
                    ("\\.\\(g\\|\\) z\\'" "zcat"))))))
  (leaf diff-mode
    :preface
    (defun elim:diff-mode-refine-automatically ()
      (diff-auto-refine-mode t)) ; Highlight by character unit.
    :hook (diff-mode-hook . elim:diff-mode-refine-automatically)
    :custom-face
    ((diff-added         . '((nil (:foreground "white" :background "dark green"))))
     (diff-removed       . '((nil (:foreground "white" :background "dark red"))))
     (diff-refine-change . '((nil (:foreground nil     :background nil :weight 'bold :inverse-video t))))))
  (leaf editorconfig
    :ensure t
    :diminish editorconfig-mode
    :config (editorconfig-mode 1))
  (leaf eldoc
    :custom ((eldoc-idle-delay . 0.2)
             (eldoc-minor-mode-string . ""))
    :hook ((emacs-lisp-mode
            lisp-interaction-mode
            ielm-mode-hook) . turn-on-eldoc-mode))
  (leaf *flycheck
    :config
    (leaf flycheck
      :ensure t
      :hook (after-init-hook . global-flycheck-mode)
      :init (add-to-list 'exec-path (expand-file-name "bin" user-emacs-directory)))
    (leaf flycheck-posframe
      :ensure t
      :after flycheck
      :hook (flycheck-mode-hook . flycheck-posframe-mode)))
  (leaf flyspell
    :custom ((ispell-dictionary . "american")
             (flyspell-use-meta-tab . nil)))
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
               (helm-ff-auto-update-initial-value . nil))

      :diminish helm-mode)
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
    (leaf helm-posframe
      :disabled t
      :ensure t
      :custom ((helm-posframe-poshandler . #'posframe-poshandler-frame-center))
      :config (helm-posframe-enable))
    (leaf helm-projectile :ensure t
      :after projectile
      :bind ("M-t" . helm-projectile)
      :config (helm-projectile-on)
      :custom (helm-mini-default-sources
               . '(helm-source-buffers-list
                   helm-source-recentf
                   helm-source-projectile-recentf-list
                   helm-source-projectile-buffers-list
                   helm-source-projectile-files-list
                   helm-source-projectile-projects
                   helm-source-buffer-not-found))
      :hook (helm-mode-hook . helm-projectile-on)))
  (leaf help
    :config (temp-buffer-resize-mode t))
  (leaf hideshow
    :bind ((:hs-minor-mode-map
            ("C-c C-M-c" . hs-toggle-hiding)
            ("C-c h"     . hs-toggle-hiding)
            ("C-c l"     . hs-hide-level))))
  (leaf hl-line
    :config (global-hl-line-mode -1))
  (leaf *ivy/counsel
    :disabled t
    :config
    (leaf counsel
      :ensure t
      :custom ((ivy-use-virtual-buffers . t))
      :bind (("C-:"     . counsel-recentf)
             ("C-;"     . counsel-recentf)
             ("C-x :"   . counsel-recentf)
             ("C-x ;"   . counsel-recentf)
             ("C-x C-:" . counsel-recentf)
             ("C-x C-;" . counsel-recentf)
             ("C-x C-f" . counsel-find-file)
	     ("C-x C-y" . counsel-yank-pop)
	     (:ivy-minibuffer-map
	      ("TAB" . ivy-alt-done)))
      :config
      (ivy-mode 1)
      (counsel-mode 1))
    (leaf counsel-projectile
      :require t
      :ensure t
      :bind ("M-t" . counsel-projectile)))
  (leaf paren
    :url http://0xcc.net/unimag/10/
    :config
    (show-paren-mode 1)
    (defvar elim:paren-face   'paren-face)
    (defvar elim:brace-face   'brace-face)
    (defvar elim:bracket-face 'bracket-face)
    (make-face 'paren-face)
    (make-face 'brace-face)
    (make-face 'bracket-face)
    (set-face-foreground 'paren-face "#88aaff")
    (set-face-foreground 'brace-face "#ffaa88")
    (set-face-foreground 'bracket-face "#aaaa00")
    (leaf lisp-mode
      :config
      (add-to-list 'lisp-el-font-lock-keywords-2 '("(\\|)" . elim:paren-face)))
    (leaf scheme-mode
      :defvar scheme-font-lock-keywords-2
      :config
      (defun elim:scheme-mode-hook-func ()
        (add-to-list 'scheme-font-lock-keywords-2 '("(\\|)" . elim:paren-face)))
      :hook (scheme-mode-hook . elim:scheme-mode-hook-func))
    (leaf cc-mode
      :defvar c-font-lock-keywords-3
      :config
      (defun elim:c-mode-common-hook-func-paren ()
        (add-to-list 'c-font-lock-keywords-3 '("(\\|)"     . elim:paren-face))
        (add-to-list 'c-font-lock-keywords-3 '("{\\|}"     . elim:brace-face))
        (add-to-list 'c-font-lock-keywords-3 '("\\[\\|\\]" . elim:bracket-face)))
      :hook ((c-mode-common-hook . elim:c-mode-common-hook-func-paren))))
  (leaf persistent-scratch
    :ensure t
    :custom `((persistent-scratch-save-file
               . ,(expand-file-name "scratch"
                                     elim:user-variables-directory)))
    :config (persistent-scratch-setup-default))
  (leaf projectile
    :ensure t
    :config (projectile-mode +1)
    :custom (projectile-enable-caching . t)
    :diminish projectile-mode)
  (leaf rainbow-mode
    :ensure t
    :diminish t
    :hook ((css-mode-hook
            emacs-lisp-mode-hook
            scss-mode-hook
            php-mode-hook
            html-mode-hook) . rainbow-mode))
  (leaf server
    :require t
    :custom (server-window . 'pop-to-buffer)
    :config
    (unless (server-running-p) (server-start))
    (remove-hook
     'kill-buffer-query-functions
     'server-kill-buffer-query-function))
  (leaf *skk
    :config
    (leaf skk
      :ensure ddskk
      :require t
      :bind* (("C-x C-j" . skk-mode)
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
                             #'(lambda () (skk-save-jisyo +1))))
      (skk-mode -1))
    (leaf ddskk-posframe
      :doc "Show Henkan tooltip for ddskk via posframe"
      :after skk
      :el-get conao3/ddskk-posframe.el
      :custom ((ddskk-posframe-mode . t))
      :diminish ddskk-posframe-mode))
  (leaf undo-tree
    :ensure t
    :custom (undo-tree-enable-undo-in-region . nil)
    :config (global-undo-tree-mode t)
    :diminish undo-tree-mode))

(leaf *major-modes
  :config
  (leaf cc-mode
    :preface
    (defun elim:c-mode-common-hook-func ()
      (c-set-style "bsd")
      (set-variable indent-tabs-mode nil)
      (set-variable c-basic-offset 2)
      (c-toggle-auto-hungry-state -1)
      (subword-mode 1))
    :hook ((c-mode-common-hook . elim:c-mode-common-hook-func)))
  (leaf css-mode
    :custom ((css-indent-offset . 2)))
  (leaf dockerfile-mode :ensure t)
  (leaf elisp-mode
    :hook (emacs-lisp-mode-hook . elim:emacs-lisp-mode-hook-func)
    :config
    (defun elim:emacs-lisp-mode-hook-func ()
      (set-variable 'indent-tabs-mode nil)
      (hs-minor-mode +1)))
  (leaf git-modes :el-get magit/git-modes)
  (leaf go-mode
    :ensure t
    :preface
    (defun elim:go-mode-hook-func ()
      (set (make-local-variable 'tab-width) 4))
    :hook (go-mode-hook . elim:go-mode-hook-func))
  (leaf js2-mode
    :ensure t
    :mode ("\\.js\\'" "\\.es6\\'")
    :preface
    (defun elim:js2-mode-hook-func ()
      (set-face-underline 'js2-warning nil)
      (set-variable 'indent-tabs-mode nil)
      (set-variable 'show-trailing-whitespace t)
      (hs-minor-mode +1))
    :custom ((js2-basic-offset . 2)
             (js2-include-browser-externs . t)
             (js2-include-node-externs . t)
             (js2-mode-deactivate-region . t)
             (js2-mode-mode-lighter . "")
             (js2-mode-search-threshold . 1000)
             (js2-mode-use-migemo . t)
             (js2-global-externs
              . '("define" "describe" "xdescribe" "expect" "it" "xit"
                  "require" "$" "_" "angular" "Backbone" "JSON" "setTimeout" "jasmine"
                  "beforeEach" "afterEach" "spyOn")))
    :hook (js2-mode-hook . elim:js2-mode-hook-func))
  (leaf js
    :custom ((js-indent-level . 2)))
  (leaf json-mode :ensure t)
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
    :diminish auto-revert-mode)
  (leaf markdown-mode
    :ensure t
    :bind ((:gfm-mode-map
            ("`" . self-insert-command)
            ([(meta return)] . elim:toggle-fullscreen)))
    :mode ("\\.md\\'" . gfm-mode))
  (leaf *org
    :custom (org-directory . "~/Dropbox/org/")
    :config
    (let*
        ((journal-file (expand-file-name "journal.org" org-directory))
         (note-file    (expand-file-name "notes.org"   org-directory))

         (journal-template-common `(entry
                                    (file+datetree ,journal-file)
                                    "* %U\n%?"
                                    :jump-to-captured t
                                    :unnarrowed t))

         (capture-templates-journal
          `(,(append '("j" "Journal")                  journal-template-common)
            ,(append '("J" "Journal with time-prompt") journal-template-common '(:time-prompt t))))

         (capture-templates-others
          '(("n" "Note" entry (file+headline ,note-file "Notes")
             "* %?\nEntered on %U\n %i\n %a"))))
      (leaf org
        :bind (("C-c a"   . org-agenda)
               ("C-c c"   . org-capture)
               ("C-c C-l" . org-insert-link)
               ("C-c l"   . org-store-link))
        :custom ((org-agenda-files . (list org-directory))
                 (org-capture-templates . (append capture-templates-journal capture-templates-others))
                 (org-image-actual-width . '(400))
                 (org-refile-targets
                  . '((nil :maxlevel . 3)
                      (org-agenda-files :maxlevel . 3)))
                 (org-startup-folded . 'showeverything)
                 (org-startup-indented . nil)
                 (org-startup-truncated . nil)
                 (org-startup-with-inline-images . t)
                 (org-use-speed-commands . t)))
      (leaf org-id
        :custom ((org-id-link-to-org-use-id . 'create-if-interactive-and-no-custom-id)
                 (org-id-track-globally . t)))))
  (leaf php-mode
    :ensure t
    :bind (:php-mode-map
           ("C-c C-[" . beginning-of-defun)
           ("C-c C-]" . end-of-defun))
    :custom ((php-mode-coding-style . 'psr2))
    :preface
    (defun elim:php-mode-hook-func ()
      (setq-local shell-file-name "/bin/sh")
      (setq-local flycheck-phpcs-standard "PSR2")
      (php-enable-psr2-coding-style)
      (hs-minor-mode +1))
    :hook (php-mode-hook . elim:php-mode-hook-func))
  (leaf *ruby
    :config
    (leaf ruby-end :ensure t)
    (leaf ruby-mode
      :ensure t
      :bind (:ruby-mode-map
             ("C-m" . reindent-then-newline-and-indent))
      :custom ((ruby-deep-indent-paren-style . nil)
               (ruby-flymake-use-rubocop-if-available . nil)
               (ruby-insert-encoding-magic-comment . nil)))
    (leaf rspec-mode :ensure t))
  (leaf salt-mode
    :ensure t
    :mode ("\\.sls\\'" "\\master\\'" "\\roster\\'" "\\Saltfile\\'"))
  (leaf sh-script
    :mode ("\\.env\\'" "\\.env.sample\\'")
    :custom ((sh-basic-offset . 2)
             (sh-indentation . 2)))
  (leaf slim-mode :ensure t)
  (leaf text-mode
    :preface
    (defun elim:text-mode-hook-func ()
      (set-variable 'indent-tabs-mode nil))
    :hook (text-mode-hook . elim:text-mode-hook-func))
  (leaf terraform-mode :ensure t)
  (leaf *typescript
    (leaf typescript-mode
      :ensure t
      :preface
      (defun elim:typescript-mode-hook-func ()
        (tide-setup)
        (flycheck-mode t)
        (setq flycheck-check-syntax-automatically '(save mode-enabled))
        (eldoc-mode t)
        (company-mode-on))
      :hook (typescript-mode-hook . elim:typescript-mode-hook-func))
    (leaf tide :ensure t))
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
             (web-mode-style-padding . 2)))
  (leaf yaml-mode :ensure t))

;;; init.el ends here
