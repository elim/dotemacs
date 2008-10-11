;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when window-system
  (setq-default line-spacing
                (if (featurep 'mac-carbon) nil 2))
  (setq default-frame-alist
        (append
         '((foreground-color . "gray")
           (background-color . "black")
           (cursor-color  . "blue")
           (alpha . (90 95)))
         default-frame-alist))

  (setq initial-frame-alist
        (append
         '((fullscreen . fullboth))
         default-frame-alist))

  ;; http://lists.sourceforge.jp/mailman/archives/macemacsjp-english/2006-April/000569.html
  (when carbon-p
    (defun hide-others ()
      (interactive)
      (do-applescript
       "tell application \"System Events\"
          set visible of every process whose (frontmost is false) and (visible is true) to false
        end tell"))

    (defun hide-emacs ()
      (interactive)
      (do-applescript
       "tell application \"System Events\"
          set theFrontProcess to process 1 whose (frontmost is true) and (visible is true)
          set visible of theFrontProcess to false
        end tell")))

  ;; http://groups.google.com/group/carbon-emacs/msg/287876a967948923
  (defun toggle-fullscreen ()
    (interactive)
    (set-frame-parameter nil
                         'fullscreen
                         (if (frame-parameter nil
                                              'fullscreen)
                             nil 'fullboth)))

  (global-set-key [(meta return)] 'toggle-fullscreen))