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

  :custom-face
  (company-preview-common           ((nil (:foreground "lightgrey" :underline t))))
  (company-scrollbar-bg             ((nil (:background "gray40"))))
  (company-scrollbar-fg             ((nil (:background "orange"))))
  (company-tooltip                  ((nil (:foreground "black" :background "lightgrey"))))
  (company-tooltip-common           ((nil (:foreground "black" :background "lightgrey"))))
  (company-tooltip-common-selection ((nil (:foreground "white" :background "steelblue"))))
  (company-tooltip-selection        ((nil (:foreground "black" :background "steelblue"))))

  :delight
  :hook (after-init . global-company-mode))

;;; init-company-mode.el ends here
