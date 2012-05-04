;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (autoload 'riece "riece" nil t)
  (setq riece-directory (expand-file-name "riece" user-emacs-directory)
        riece-addon-directory (expand-file-name "addons" riece-directory)
        riece-saved-variables-file (expand-file-name "save" riece-directory)
        riece-variables-file (expand-file-name "init" riece-directory)
        riece-variables-files (list riece-variables-file
                                    riece-saved-variables-file)

        riece-saved-forms nil
        riece-addons '(riece-alias riece-button
                                   riece-ctcp riece-ctlseq riece-guess
                                   riece-highlight riece-history
                                   riece-icon riece-keyword
                                   riece-menu riece-skk-kakutei
                                   riece-unread riece-url)

        riece-server-alist '(("default"
                              :host "localhost"
                              :service 6667
                              :coding utf-8))

        riece-ndcc-server-address "localhost"
        riece-channel-buffer-mode t
        riece-user-list-buffer-mode t
        riece-layout "middle-left"

        riece-nickname "elim"
        riece-user-agent 'emacs-riece-config

        riece-my-nicks (list
                        "elim"         "Elim"
                        "えむりん"     "エムリン"
                        "えりむ"       "エリム"
                        "えりめらんく" "エリメランク"
                        "えろす"       "エロス"
                        "えろむ"       "エロム"
                        "えろりむ"     "エロリム"
                        "ろりむ"       "ロリム"
                        "えりも"       "エリモ"        "襟裳"
                        "たける"       "タケル")

        riece-not-my-nicks (list
                            "たけるんば" "タケルンバ")

        riece-keywords `(,@riece-my-nicks
                         ,@riece-not-my-nicks
                         ("[Ee]macs" . 0)
                         ("[Rr]uby"  . 0)
                         ("[Zz]sh"   . 0))

        riece-notify-sound-player
        (fold-left (lambda (x y)
                     (or x (executable-find y)))
                   nil (list "mplayer" "aplay" "esdplay"))

        riece-notify-sound
        (fold-left (lambda (x y)
                     (or x (and (file-readable-p y) y)))
                   nil (list "~/sounds/notify.wav"
                             "/System/Library/Sounds/Funk.aiff")))

  (and riece-notify-sound
       riece-notify-sound-player
       (defun riece-keyword-notify-sound (keyword message)
         (when (and (not (member keyword riece-not-my-nicks))
                    (member keyword riece-my-nicks))
           (start-process "riece-keyword" " *riece keyword*"
                          riece-notify-sound-player
                          (expand-file-name riece-notify-sound))))
       (add-hook 'riece-keyword-notify-functions #'riece-keyword-notify-sound))

  (add-hook 'riece-after-load-startup-hook
            (lambda ()
              (setq riece-server "default")))

  (eval-after-load "riece"
    '(and
      (define-key riece-command-mode-map [(control x) (n)]
        'riece-command-enter-message-as-notice)))

  (defvar riece-enable-p t)

  (defun riece-toggle ()
    (interactive)
    (message "riese is %s."
             (if (setq riece-enable-p (not riece-enable-p))
                 "enabled" "disabled")))

  (defadvice riece (around riece-wrapper (&optional confirm))
    (if riece-enable-p
        ad-do-it (message "riece is disabled.")))

  (ad-activate-regexp "^riece-wrapper$"))
