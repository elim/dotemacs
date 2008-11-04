;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(and (autoload-if-found 'riece "riece" nil t)
     (setq riece-server-alist
           '(("default"
              :host "localhost"
              :service 6667
              :coding utf-8))
           riece-server "default"
           riece-ndcc-server-address "localhost"
           riece-channel-buffer-mode t
           riece-user-list-buffer-mode t
           riece-layout "middle-left"

           riece-preference-directory
           (expand-file-name "riece" base-directory)

           riece-addon-directory
           (expand-file-name "addons" riece-preference-directory)

           riece-saved-variables-file
           (expand-file-name "save" riece-preference-directory)

           riece-variables-file
           (expand-file-name "init" riece-preference-directory)

           riece-variables-files (list riece-variables-file
                                       riece-saved-variables-file)

           riece-saved-forms '(riece-channel-buffer-mode
                               riece-others-buffer-mode
                               riece-user-list-buffer-mode
                               riece-channel-list-buffer-mode
                               riece-layout riece-addons)

           riece-addons '(riece-alias
                          riece-button
                          riece-ctcp riece-guess riece-highlight
                          riece-history riece-icon riece-keyword
                          riece-menu riece-skk-kakutei riece-unread
                          riece-url)

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

           riece-keywords `(,@riece-my-nicks
                            ("[Ee]macs" . 0)
                            ("[Rr]uby"  . 0)
                            ("[Zz]sh"   . 0))

           riece-notify-sound-player
           (enum/find '(lambda (fname)
                         (executable-find fname))
                      (list "mplayer" "aplay" "esdplay"))

           riece-notify-sound
           (enum/find '(lambda (fname)
                         (file-readable-p fname))
                      (list "~/sounds/notify.wav"
                            "/System/Library/Sounds/Funk.aiff")))

     (and riece-notify-sound
          riece-notify-sound-player

          (defun riece-notify-keyword-function (keyword)
            (when (member keyword riece-my-nicks)
              (start-process keyword "*Messages*"
                             riece-notify-sound-player
                             (expand-file-name riece-notify-sound))))

          (add-hook 'riece-notify-keyword-functions
                    #'riece-notify-keyword-function))

     (add-hook 'riece-startup-hook
               '(lambda ()
                  (define-key riece-command-mode-map [(control x) (n)]
                    'riece-command-enter-message-as-notice))))