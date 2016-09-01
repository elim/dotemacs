;;; init-js2-mode.el --- A setting of the js2-mode.
;;; Commentary:
;;; Code:

(add-to-list 'auto-mode-alist '("\\.js\\'"  . js2-mode))
(add-to-list 'auto-mode-alist '("\\.es6\\'" . js2-mode))

(defun elim:js2-mode-hook-func ()
  (setq indent-tabs-mode nil
        show-trailing-whitespace t
        js2-basic-offset 2
        js2-include-browser-externs t
        js2-include-node-externs t
        js2-mode-deactivate-region t
        js2-mode-mode-lighter ""
        js2-mode-search-threshold 1000
        js2-mode-use-migemo t
        js2-global-externs
        '("define" "describe" "xdescribe" "expect" "it" "xit"
          "require" "$" "_" "angular" "Backbone" "JSON" "setTimeout" "jasmine"
          "beforeEach" "afterEach" "spyOn"))
  (hs-minor-mode 1))

(add-hook 'js2-mode-hook #'elim:js2-mode-hook-func)

(provide 'init-js2-mode)

;;; init-js2-mode.el ends here
