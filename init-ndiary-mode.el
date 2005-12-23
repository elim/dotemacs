;-*- emacs-lisp -*-
;$Id$

(when (autoload-if-found
       'ndiary-mode "ndiary-mode" "Mode for editing ndiary." t)
  (setq ndiary-diary-file-coding-system 'euc-jp-unix)
  (setq ndiary-latest-filename "~/public_html/LifeLog/index.html")
  (setq ndiary-log-directory "~/public_html/LifeLog/source/")
  (setq ndiary-mode-abbrev-table t))

