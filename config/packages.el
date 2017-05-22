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

;; Preferred libraries
(el-get-bundle tarao/with-eval-after-load-feature-el)

(el-get-bundle ag)
(el-get-bundle anzu)
(el-get-bundle buffer-move)
(el-get-bundle company-mode)
(el-get-bundle company-quickhelp)
(el-get-bundle ddskk)
(el-get-bundle editorconfig)
(el-get-bundle elim/auto-save-buffers-enhanced)
(el-get-bundle elpa:async)
(el-get-bundle elscreen)
(el-get-bundle emacs-helm/helm-elscreen :depends (elscreen helm))
(el-get-bundle flycheck)
(el-get-bundle fujimisakari/microsoft-translator :depends (request))
(el-get-bundle gist:5457732:ginger-api :depends (json popwin request))
(el-get-bundle gist:666807b53f2b2cf503c1:clipboard-to-kill-ring :depends (deferred))
(el-get-bundle gist:7349439:ginger-rephrase-api :depends (popwin request))
(el-get-bundle git-modes)
(el-get-bundle glynnforrest/mmm-jinja2)
(el-get-bundle glynnforrest/salt-mode)
(el-get-bundle go-mode)
(el-get-bundle google-translate)
(el-get-bundle helm :depends (async))
(el-get-bundle helm-css-scss)
(el-get-bundle helm-descbinds)
(el-get-bundle helm-git-grep)
(el-get-bundle helm-projectile)
(el-get-bundle jinja2-mode)
(el-get-bundle js2-mode)
(el-get-bundle json-mode)
(el-get-bundle magit)
(el-get-bundle markdown-mode)
(el-get-bundle migemo)
(el-get-bundle mmm-mode)
(el-get-bundle open-junk-file)
(el-get-bundle php-mode)
(el-get-bundle popwin)
(el-get-bundle puppet-mode)
(el-get-bundle rainbow-mode)
(el-get-bundle rspec-mode)
(el-get-bundle ruby-end)
(el-get-bundle ruby-mode)
(el-get-bundle Simplify/flycheck-typescript-tslint)
(el-get-bundle slim-mode)
(el-get-bundle tide)
(el-get-bundle twittering-mode)
(el-get-bundle typescript-mode)
(el-get-bundle w-vi/apib-mode)
(el-get-bundle web-mode)
(el-get-bundle wgrep)
(el-get-bundle yaml-mode)

;;; packages.el ends here
