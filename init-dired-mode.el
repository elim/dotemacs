;-*- emcs-lisp -*-
(setq dired-bind-jump nil)
(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")))


