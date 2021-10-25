;;; init.el --- A setting of my own Emacs. -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(set-variable 'debug-on-error t)
(set-variable 'init-file-debug t)
(set-variable 'load-prefer-newer t)

(defun elim:first-existing-path-in (list)
  "Return first existing path in LIST."
  (car (remove-if-not #'file-exists-p list)))

;; this enables this running method
;;   emacs -q -l ~/.debug.emacs.d/init.el
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

;;; leaf.el
;;
(eval-and-compile
  (customize-set-variable
   'package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("org"   . "https://orgmode.org/elpa/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :config
    ;; optional packages if you want to use :hydra, :el-get,,,
    (leaf hydra :ensure t)
    (leaf blackout :ensure t)

    ;; initialize leaf-keywords.el
    (leaf-keywords-init)))

(leaf *environments
  :custom `((enable-recursive-minibuffers . t)
            (gc-cons-threshold . ,(* 128 1024 1024))
            (use-dialog-box . nil)
            (user-mail-address . "takeru.naito@gmail.com")
            (user-full-name . "Takeru Naito"))
  :config
  (defalias 'yes-or-no-p 'y-or-n-p)
  (leaf async
    :ensure t)
  (leaf cus-edit
    :doc "Just prevent appending to this file (not load at startup)."
    :custom `((custom-file . ,(locate-user-emacs-file ".custom.el"))))
  (leaf frame
    :if window-system
    :preface
    (defun elim:frame-fullscreen ()
      ;; FIXME: Sometimes may become native full screen on macOS even
      ;;        the ns-use-native-fullscreen is nil (especially on
      ;;        startup).
      (set-frame-parameter nil 'fullscreen 'fullboth))
    :config
    (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
    (add-to-list 'default-frame-alist '(ns-appearance . dark))
    :custom ((line-spacing . 4))
    :hook (window-setup-hook . elim:frame-fullscreen))
  (leaf *completion
    :url https://blog.tomoya.dev/posts/a-new-wave-has-arrived-at-emacs
    :url https://emacs-jp.slack.com/archives/C1B5WTJLQ/p1623851956426000
    :url https://github.com/uwabami/emacs
    :config
    (leaf affe
      :ensure t
      :after orderless
      :custom
      ((affe-highlight-function . 'orderless-highlight-matches)
       (affe-regexp-function  . 'orderless-pattern-compiler)))
    (leaf consult
      :ensure t
      :preface
      ;; C-uを付けるとカーソル位置の文字列を使うmy-consult-lineコマンドを定義する
      (defun tomoya:consult-line (&optional at-point)
        "Consult-line uses things-at-point if set C-u prefix."
        (interactive "P")
        (if at-point
            (consult-line (thing-at-point 'symbol))
          (consult-line)))
      :bind (([remap apropos-command]               . consult-apropos)             ; F1 a
             ([remap switch-to-buffer]              . consult-buffer)              ; C-x b
             ([remap switch-to-buffer-other-window] . consult-buffer-other-window) ; C-x 4 b
             ([remap display-buffer-other-frame]    . consult-buffer-other-frame)  ; C-x 5 b
             ([remap repeat-complex-command]        . consult-complex-command)     ; C-x C-:
             ([remap pop-global-mark]               . consult-global-mark)         ; C-x C-SPC
             ([remap goto-line]                     . consult-goto-line)           ; M-g g
             ([remap yank-pop]                      . consult-yank-pop)            ; M-y

             ("C-;" . consult-buffer)
             ("C-x C-;" . consult-buffer)

             ("C-x C-o" . consult-file-externally) ; orig. delete-blank-lines
             ("C-x C-p" . consult-find)            ; orig. mark-page
             ("M-s M-s" . tomoya:consult-line)
             ("C-S-s"   . consult-imenu)           ; orig. imenu
             ))
    (leaf embark-consult
      :ensure t
      :require t
      :after consult)
    (leaf marginalia
      :ensure t
      :global-minor-mode t)
    (leaf orderless
      :ensure t
      :custom (completion-styles . '(orderless)))
    (leaf savehist
      :global-minor-mode t)
    (leaf vertico
      :url https://github.com/uwabami/emacs
      :preface
      (defun uwabami:filename-upto-parent ()
        "Move to parent directory like \"cd ..\" in find-file."
        (interactive)
        (let ((sep (eval-when-compile (regexp-opt '("/" "\\")))))
          (save-excursion
            (left-char 1)
            (when (looking-at-p sep)
              (delete-char 1)))
          (save-match-data
            (when (search-backward-regexp sep nil t)
              (right-char 1)
              (filter-buffer-substring (point)
                                       (save-excursion (end-of-line) (point))
                                       #'delete)))))
      :ensure t
      :bind (:vertico-map
             (("C-l" . uwabami:filename-upto-parent)
              ("C-r" . vertico-previous)
              ("C-s" . vertico-next)))
      :custom (vertico-count . 20)
      :global-minor-mode t))
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
      (elim:set-text-height 160))))
  (leaf ns
    :if (featurep 'ns)
    :custom
    ((ns-antialias-text        . t)
     (ns-pop-up-frames         . nil)
     (ns-use-native-fullscreen . nil)

     (ns-alternate-modifier       . 'meta)
     (ns-command-modifier         . 'meta)
     (ns-right-alternate-modifier . 'hyper)
     (ns-right-command-modifier   . 'super)))
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
    :global-minor-mode line-number-mode transient-mark-mode
    :hook (before-save-hook . elim:auto-delete-trailing-whitespace))
  (leaf timer-list
    :config (put 'list-timers 'disabled nil))
  (leaf vc
    :custom (vc-follow-symlinks . t)))

(leaf *utilities
  :config
  (leaf add-node-modules-path
    :ensure t
    :hook ((js-mode-hook . add-node-modules-path)
           (www-mode-hook . add-node-modules-path)))
  (leaf auth-source
    :custom `(auth-sources . '(,(locate-user-emacs-file ".authinfo.plist"))))
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
    :defvar desktop-globals-to-save
    :custom `((desktop-base-file-name . ,(locate-user-emacs-file ".desktop.el"))
              (desktop-base-lock-name . ,(locate-user-emacs-file ".desktop.lock"))
              (desktop-restore-eager  . 0)
              (desktop-restore-frames . nil)
              (desktop-save-mode      . +1))
    :config
    (add-to-list 'desktop-globals-to-save 'extended-command-history)
    (add-to-list 'desktop-globals-to-save 'kill-ring)
    (add-to-list 'desktop-globals-to-save 'log-edit-comment-ring)
    (add-to-list 'desktop-globals-to-save 'read-expression-history))
  (leaf eslint-fix
    :ensure t)
  (leaf files
    :if (executable-find "gls")
    :custom ((insert-directory-program . "gls")))
  (leaf find-func
    :config
    ;; C-x F => Find Function
    ;; C-x V => Find Variable
    ;; C-x K => Find Function on Key
    (find-function-setup-keys))
  (leaf forge
    :after magit
    :ensure t
    :custom `(forge-database-file . ,(locate-user-emacs-file ".forge-database.sqlite")))
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
  (leaf help-fns
    :bind (("H-b" . describe-binding)
           ("H-f" . describe-function)
           ("H-k" . describe-key)
           ("H-v" . describe-variable)))
  (leaf open-junk-file
    :ensure t
    :bind (("C-x C-z" . open-junk-file))
    :custom ((open-junk-file-format . "~/.junk/%Y/%m/%d-%H%M%S.")
             (open-junk-file-find-file-function . 'find-file)))
  (leaf paradox
    :after async
    :ensure t
    :custom `((paradox-execute-asynchronously . t)
              (paradox-github-token
               . ,(cadr (auth-source-user-and-password
                         "api.github.com" "elim^paradox"))))
    :config (paradox-enable))
  (leaf recentf
    :defvar recentf-auto-save-timer
    :custom `((recentf-auto-save-timer
               . ,(run-with-idle-timer 30 t #'recentf-save-list))
              (recentf-max-saved-items . 512)
              (recentf-save-file . ,(locate-user-emacs-file ".recentf.el")))
    :global-minor-mode t)
  (leaf sort
    :config
    (defun elim:sort-lines-nocase ()
      "Ignore case when the sort the lines."
      (interactive)
      (let ((sort-fold-case t))
        (call-interactively 'sort-lines)))
    (defalias 'sort-lines-nocase #'elim:sort-lines-nocase))
  (leaf sqlformat
    :ensure t
    :custom (sqlformat-command . 'pgformatter)))

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
    :blackout company-mode
    :hook (after-init-hook . global-company-mode))
  (leaf company-quickhelp
    :ensure t
    :global-minor-mode company-quickhelp-mode)
  (leaf doom-modeline
    :ensure t
    :leaf-defer nil
    :custom
    ((doom-modeline-buffer-file-name-style . 'truncate-with-project)
     (doom-modeline-major-mode-icon . nil)
     (doom-modeline-minor-modes . nil)
     (inhibit-compacting-font-caches . t))
    :custom-face
    ((mode-line  . '((t (:height 160))))
     (mode-line-inactive . '((t (:height 160)))))
    :config (doom-modeline-mode))
  (leaf elscreen
    :ensure t
    :bind (("M-{" . elscreen-previous)
           ("M-}" . elscreen-next))
    :leaf-defer nil
    :custom `((elscreen-set-prefix-key . ,(kbd "C-z"))
              (elscreen-tab-display-control . nil)
              (elscreen-tab-display-kill-screen . nil)
              (elscreen-display-tab . t))
    :custom-face ((elscreen-tab-background-face     . '((nil (:foreground "#112" :background "#ccc" :underline nil :box nil))))
                  (elscreen-tab-control-face        . '((nil (:foreground "#ccc" :background "#112" :underline nil :box nil))))
                  (elscreen-tab-current-screen-face . '((nil (:foreground "#ccc" :background "#336" :underline nil :box nil))))
                  (elscreen-tab-other-screen-face   . '((nil (:foreground "#ccc" :background "#112" :underline nil :box nil)))))
    :config
    (mapc (lambda (i)
            (global-set-key (kbd (format "M-%d" i))
                            `(lambda ()
                               (interactive)
                               (elscreen-goto ,i))))
          (number-sequence 0 9))
    (elscreen-start))
  (leaf executable
    :config
    (defun elim:executable-make-buffer-file-executable-if-script-p ()
      (unless (string-match tramp-file-name-regexp (buffer-file-name))
        (executable-make-buffer-file-executable-if-script-p)))
    :hook (after-save-hook . elim:executable-make-buffer-file-executable-if-script-p))
  (leaf font-core
    :config (global-font-lock-mode t))
  (leaf menu-bar
    :if (eq system-type 'darwin)
    :global-minor-mode t)
  (leaf mouse
    :bind (("C-<down-mouse-1>" . nil)
           ("C-<drag-mouse-1>" . nil)
           ("S-<down-mouse-1>" . nil)
           ("S-<drag-mouse-1>" . nil)))
  (leaf nyan-mode
    :ensure t
    :leaf-defer nil
    :global-minor-mode t
    :custom ((nyan-animate-nyancat . t)
             (nyan-wavy-trail . t)))
  (leaf popwin
    :ensure t
    :require t
    :custom ((popwin:popup-window-position . 'bottom)
             (popwin:popup-window-height . 20))
    :config
    (push '("*Google Translate*") popwin:special-display-config)
    :global-minor-mode t)
  (leaf rotate :ensure t)
  (leaf scroll-bar
    :if (fboundp 'scroll-bar-mode)
    :config
    (set-scroll-bar-mode 'right)
    (scroll-bar-mode -1)
    :global-minor-mode column-number-mode)
  (leaf select
    :custom ((select-enable-primary . nil)
             (select-enable-clipboard . t)
             (selection-coding-system . 'utf-8)))
  (leaf wgrep
    :ensure t
    :custom ((wgrep-auto-save-buffer . t)))
  (leaf *theme
    :config
    ;; (load-theme 'tango-dark t))
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
  (leaf uniquify
    :custom ((uniquify-buffer-name-style . 'post-forward-angle-brackets)
             (uniquify-ignore-buffers-re . "*[^*]+*")
             (uniquify-min-dir-content   . 1)))
  (leaf which-key
    :ensure t
    :hook (after-init-hook . which-key-mode))
  (leaf windmove
    :custom ((windmove-wrap-around . t))
    :bind (("C-c C-b" . windmove-left)
           ("C-c C-n" . windmove-down)
           ("C-c C-p" . windmove-up)
           ("C-c C-f" . windmove-right))))

(leaf *minor-modes
  :config
  (leaf anzu
    :ensure t
    :bind (([remap query-replace]        . anzu-query-replace)
           ([remap query-replace-regexp] . anzu-query-replace-regexp))
    :custom ((anzu-mode-lighter . "")
             (anzu-deactivate-region . t)
             (anzu-search-threshold . 1000))
    :global-minor-mode global-anzu-mode)
  (leaf atomic-chrome
    :ensure t
    :preface
    (defun elim:atomic-chrome-edit-done-hook-func ()
      (kill-new (buffer-string)))
    :custom ((atomic-chrome-default-major-mode . 'markdown-mode)
             (atomic-chrome-url-major-mode-alist
              . '(("github\\.com" . gfm-mode)
                  ("esa\\.io"     . gfm-mode)
                  ("redmine"      . textile-mode))))
    :hook ((after-init-hook
            . atomic-chrome-start-server)
           (atomic-chrome-edit-done-hook
            . elim:atomic-chrome-edit-done-hook-func)))
  (leaf autorevert
    :global-minor-mode global-auto-revert-mode)
  (leaf auto-save-visited-mode
    :bind ("C-x as" . auto-save-visited-mode)
    :leaf-defer nil
    :custom ((auto-save-visited-interval . 0.5))
    :global-minor-mode t)
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
    :init
    (defun elim:coordinate-editorconfig-with-web-mode (props)
      "When using web mode, leaves the code format to prettifiers."
      (when (derived-mode-p 'web-mode)
        (set-variable 'web-mode-script-padding 0)
        (set-variable 'web-mode-style-padding  0)))
    :hook (editorconfig-after-apply-functions
           . elim:coordinate-editorconfig-with-web-mode)
    :global-minor-mode editorconfig-mode
    :blackout editorconfig-mode)
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
  (leaf help
    :config (temp-buffer-resize-mode t))
  (leaf hideshow
    :bind ((:hs-minor-mode-map
            ("C-c C-M-c" . hs-toggle-hiding)
            ("C-c h"     . hs-toggle-hiding)
            ("C-c l"     . hs-hide-level))))
  (leaf hl-line
    :global-minor-mode global-hl-line-mode)
  (leaf paren
    :url http://0xcc.net/unimag/10/
    :global-minor-mode show-paren-mode
    :config
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
    :leaf-defer nil
    :custom `(persistent-scratch-save-file . ,(locate-user-emacs-file ".scratch.el"))
    :config
    (with-current-buffer "*scratch*"
      (emacs-lock-mode 'kill))
    (persistent-scratch-setup-default))
  (leaf projectile
    :ensure t
    :bind (("M-t" . projectile-command-map))
    :global-minor-mode t
    :custom (projectile-enable-caching . t)
    :blackout projectile-mode)
  (leaf rainbow-mode
    :ensure t
    :blackout t
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
      :bind* (("C-x C-j" . skk-mode)
              ("C-x t" . nil)
              ("C-x j" . nil))
      :custom `((default-input-method . "japanese-skk")
                (skk-user-directory . ,(expand-file-name "ddskk" (getenv "XDG_CONFIG_HOME")))
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
                             #'(lambda () (skk-save-jisyo +1)))))
    (leaf ddskk-posframe
      :doc "Show Henkan tooltip for ddskk via posframe"
      :after skk
      :ensure t
      :custom ((ddskk-posframe-mode . t))
      :blackout ddskk-posframe-mode))
  (leaf undo-tree
    :ensure t
    :bind ((:undo-tree-visualizer-mode-map
            ("C-g" . undo-tree-visualizer-quit)))
    :advice
    (:before undo-tree-visualize       elim:advice:undo-tree-visualize:before)
    (:after  undo-tree-visualizer-quit elim:advice:undo-tree-visualizer-quit:after)
    :leaf-defer nil
    :custom (undo-tree-enable-undo-in-region . nil)
    :blackout undo-tree-mode
    :config
    (defvar elim:before:auto-save-visited-mode nil
      "Store the value of auto-save-visited-mode.")
    (defun elim:advice:undo-tree-visualize:before ()
      (set-variable (quote elim:before:auto-save-visited-mode)
                    auto-save-visited-mode)
      (auto-save-visited-mode -1))
    (defun elim:advice:undo-tree-visualizer-quit:after ()
      (auto-save-visited-mode elim:before:auto-save-visited-mode))
    (global-undo-tree-mode)))

(leaf *major-modes
  :config
  (leaf cc-mode
    :preface
    (defun elim:c-mode-common-hook-func ()
      (c-set-style "bsd")
      (set-variable 'indent-tabs-mode nil)
      (set-variable 'c-basic-offset 2)
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
  (leaf elm-mode :ensure t)
  (leaf feature-mode
    :ensure t
    :after org org-table)
  (leaf gitattributes-mode :ensure t)
  (leaf gitconfig-mode :ensure t)
  (leaf gitignore-mode :ensure t)
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
    :bind (("C-x v s" . magit-status)
           ("C-x v f" . magit-diff-buffer-file))
    :custom (magit-diff-refine-hunk . 'all)
    :hook (git-commit-setup-hook . elim:git-commit-setup-hook-func)
    :init (add-to-list 'process-coding-system-alist '("git" utf-8 . utf-8))
    :config
    (defun elim:git-commit-setup-hook-func ()
      (flyspell-mode +1)
      (set (make-local-variable
            'elim:auto-delete-trailing-whitespace-enable-p) nil))
    :blackout auto-revert-mode)
  (leaf markdown-mode
    :ensure t
    :mode (("\\.md\\'" "\\ISSUE_EDITMSG\\'") . gfm-mode)
    :bind (:markdown-mode-map
           ("C-c 1" . markdown-insert-header-atx-1)
           ("C-c 2" . markdown-insert-header-atx-2)
           ("C-c b" . markdown-insert-bold)
           ("C-c i" . markdown-insert-italic))
    :custom
    ((markdown-asymmetric-header            . t)
     (markdown-fontify-code-blocks-natively . t)
     (markdown-gfm-use-electric-backquote   . nil)
     (markdown-header-scaling               . nil)
     (markdown-hr-strings                   . '("* * *\n\n"))
     (markdown-marginalize-headers          . nil)))
  (leaf mmm-mode
    :ensure t
    :config
    (leaf *hack-indentation
      ;; https://github.com/AdamNiederer/vue-mode/issues/74#issuecomment-539711083
      :preface
      (defun elim:disable-syntax-ppss-table ()
        (set-variable 'syntax-ppss-table nil))
      :hook
      ((mmm-js-mode-enter-hook         . elim:disable-syntax-ppss-table)
       (mmm-typescript-mode-enter-hook . elim:disable-syntax-ppss-table))))
  (leaf org :require org org-table)
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
    (leaf rubocop :ensure t)
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
    :config
    (leaf typescript-mode
      :ensure t
      :preface
      (defun elim:typescript-mode-hook-func ()
        (tide-setup)
        (flycheck-mode t)
        (set-variable 'flycheck-check-syntax-automatically '(save mode-enabled))
        (eldoc-mode t)
        (company-mode-on))
      :hook (typescript-mode-hook . elim:typescript-mode-hook-func))
    (leaf tide :ensure t))
  (leaf web-mode
    :after flycheck
    :ensure t
    :doc "https://github.com/ananthakumaran/tide/tree/6faea517957f56467cac5be689277d6365f3aa1a#tsx"
    :preface
    (defun elim:web-mode-hook-func ()
      (when (string-equal "tsx" (file-name-extension buffer-file-name))
        (tide-setup)))
    :mode ("\\.ctp\\'"
           "\\.html.erb\\'"
           "\\.js.erb\\'"
           "\\.p?html?\\'"
           "\\.tsx\\'"
           "\\.vue\\'")
    :custom (;; general
             (web-mode-enable-auto-indentation . nil)
             (web-mode-enable-engine-detection . t)
             ;; offsets
             (web-mode-code-indent-offset . 2)
             (web-mode-css-indent-offset . 2)
             (web-mode-markup-indent-offset . 2)
             ;; paddings
             (web-mode-block-padding . 2)
             (web-mode-script-padding . 0)
             (web-mode-style-padding . 0)
             ;; styles
             (web-mode-comment-style . 1)
             (web-mode-indent-style . 1))
    :hook (web-mode-hook . elim:web-mode-hook-func)
    :config (flycheck-add-mode 'javascript-eslint 'web-mode))
  (leaf yaml-mode :ensure t))

(provide 'init)

;;; init.el ends here
