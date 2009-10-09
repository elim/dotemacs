;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (autoload-if-found 'riece "riece" nil t)
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

        riece-notify-nicks (list "ave-dx")

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
                             "/System/Library/Sounds/Funk.aiff"))

        riece-growled-p nil)

  (and riece-notify-sound
       riece-notify-sound-player
       (defun riece-keyword-notify-sound (keyword message)
         (when (and (not (member keyword riece-not-my-nicks))
                    (member keyword riece-my-nicks))
           (start-process "riece-keyword" " *riece keyword*"
                          riece-notify-sound-player
                          (expand-file-name riece-notify-sound))))
       (add-hook 'riece-keyword-notify-functions #'riece-keyword-notify-sound))

  (defadvice riece-keyword-message-filter
    (around extended-riece-keyword-message-filter (message) activate)

    (setq riece-growled-p nil)

    (let ((speaker (aref (riece-message-speaker message) 0))
          (message-text (riece-message-text message))
          (channel (mapconcat (lambda (x) (format "%s" x))
                              (riece-message-target message)""))
          (message-type (riece-message-type message)))

      (mapcar (lambda (nick)
                (when (and (string-match nick speaker)
                           (null message-type))
                  (growl (format "%s\n%s: %s" channel speaker message-text))
                  (setq riece-growled-p t)
                  (put-text-property 0 (length speaker)
                                     'riece-overlay-face
                                     riece-keyword-face
                                     speaker)))
              riece-notify-nicks))
    ad-do-it)

  (add-hook 'riece-after-load-startup-hook
            (lambda ()
              (setq riece-server "default")))

  (eval-after-load "riece"
    '(and
      (define-key riece-command-mode-map [(control x) (n)]
        'riece-command-enter-message-as-notice)
      (ad-activate-regexp ".+riece.+"))))