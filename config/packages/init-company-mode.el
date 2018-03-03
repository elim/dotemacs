;;; init-company-mode.el --- A setting of the company-mode.
;;; Commentary:
;;; Code:

(use-package company
  :bind (("C-M-i" . company-complete)
         ;; C-n, C-pで補完候補を次/前の候補を選択
         :map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous)
         ;; C-sで絞り込む
         :map company-active-map
         ("C-s" . company-filter-candidates)
         ;; TABで候補を設定
         :map company-active-map
         ("C-i" . company-complete-selection))
  :config
  (set-face-attribute 'company-tooltip nil
                      :foreground "black" :background "lightgrey")
  (set-face-attribute 'company-tooltip-common nil
                      :foreground "black" :background "lightgrey")
  (set-face-attribute 'company-tooltip-common-selection nil
                      :foreground "white" :background "steelblue")
  (set-face-attribute 'company-tooltip-selection nil
                      :foreground "black" :background "steelblue")
  (set-face-attribute 'company-preview-common nil
                      :background nil :foreground "lightgrey" :underline t)
  (set-face-attribute 'company-scrollbar-fg nil
                      :background "orange")
  (set-face-attribute 'company-scrollbar-bg nil
                      :background "gray40")

  :delight
  :hook (after-init . global-company-mode))

;;; init-company-mode.el ends here
