;; -*- emacs-lisp -*-
;; $Id;
(when (autoload-if-found 'liece "liece" nil t)
  (setq liece-ask-for-nickname t)
  (setq liece-ask-for-password t)
  (setq liece-beep-on-bells nil)
  (setq liece-default-beep t)
  (setq liece-nickname "Elim")
  (setq liece-server "localhost")
  (setq liece-url-browser-function 'browse-url)
  (setq liece-window-default-style "middle"))
