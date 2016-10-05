;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when window-system
  (setq-default line-spacing 4)
  (setq frame-alpha-lower-limit 20
        frame-alpha-upper-limit 100
        default-frame-alist (append
                             '((foreground-color . "gray")
                               (background-color . "black")
                               (cursor-color  . "blue")
                               (alpha . (99 95)))
                             default-frame-alist))


  (defun set-alpha (elt)
    (interactive
     (list (list
            (set-alpha-internal
             "Foreground(%): " (car (frame-parameter nil 'alpha)))
            (set-alpha-internal
             "Background(%): " (cadr (frame-parameter nil 'alpha))))))
    (set-frame-parameter nil 'alpha elt))

  (defun set-alpha-internal (prompt current)
    (let (val)
      (while
          (not (and
                (setq val (read-number prompt current))
                (<= frame-alpha-lower-limit val)
                (>= frame-alpha-upper-limit val))))
      val))

  ;; http://kuraku.net/krk/2007/10/emacs-lisp.html
  (defun change-interactive-alpha ()
    (interactive)
    (let ((tr (car (frame-parameter nil 'alpha))))
      (catch 'endFlg
        (while t
          (message "change alpha set. p:up n:down alpha:%s/%s" tr (- tr 10))
          (setq c (read-char))
          (cond ((= c ?p)
                 (setq tr (or (and (> (+ tr 5) 100) 100) (+ tr 5)))
                 (set-alpha (list tr (- tr 10))))
                ((= c ?n)
                 (setq tr (or (and (<= (- tr 5) 0) 1) (- tr 5)))
                 (set-alpha (list tr (- tr 10))))
                ((and (/= c ?p) (/= c ?n))
                 (message "quit alpha:%s/%s" tr (- tr 10))
                 (throw 'endFlg t)))))))

  (global-set-key [(control c)(control x)(a)] 'change-interactive-alpha)

  ;; http://groups.google.com/group/carbon-emacs/msg/287876a967948923
  ;; http://www.computerartisan.com/meadow/diary.txt

  (when nt-p (defvar nt-fullscreen-p nil))

  (defun frame-fullscreen ()
    (interactive)
    (if nt-p
        (progn
          (w32-send-sys-command 61488)
          (setq nt-fullscreen-p t))
      (set-frame-parameter nil 'fullscreen 'fullboth)))

  (defun frame-restore ()
    (interactive)
    (if nt-p
        (progn
          (w32-send-sys-command 61728)
          (setq nt-fullscreen-p nil))
      (set-frame-parameter nil 'fullscreen nil)))

  (setq ns-use-native-fullscreen nil)
  (defun toggle-fullscreen ()
    (interactive)
    (cond
     ((and ns-p (fboundp 'ns-toggle-fullscreen))
      (ns-toggle-fullscreen))
     ((or (and nt-p nt-fullscreen-p)
          (frame-parameter nil 'fullscreen))
      (frame-restore))
     ((or (and nt-p (not nt-fullscreen-p))
          (not (frame-parameter nil 'fullscreen)))
      (frame-fullscreen))))

  (global-set-key [(meta return)] 'toggle-fullscreen)

  (add-hook 'window-setup-hook #'toggle-fullscreen))
