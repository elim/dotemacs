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

(leaf *minor-modes
  :config
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
    :ensure t))

;; Preferred libraries
(el-get-bundle tarao/with-eval-after-load-feature-el)
(el-get-bundle use-package)

(load "environment")
(load "builtins")
(load "packages")
(load "theme")
(load "local" t)

;;; init.el ends here
