;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(defun elim:set-text-height (height)
  (let* ((asciifont "Ricty") ; ASCII fonts
         (jpfont "Ricty") ; Japanese fonts
         (fontspec (font-spec :family asciifont :weight 'normal))
         (jp-fontspec (font-spec :family jpfont :weight 'normal)))
    (set-face-attribute 'default nil :family asciifont :height height)
    (set-fontset-font nil 'japanese-jisx0213.2004-1 jp-fontspec)
    (set-fontset-font nil 'japanese-jisx0213-2 jp-fontspec)
    (set-fontset-font nil 'katakana-jisx0201 jp-fontspec)
    (set-fontset-font nil '(#x0080 . #x024F) fontspec)
    (set-fontset-font nil '(#x0370 . #x03FF) fontspec)))

(defun elim:change-interactive-text-height ()
  (interactive)
  (let
      ((height (face-attribute 'default :height))
       (step 10) (char nil))
    (catch 'end:flag
      (while t
        (message "change text height. p:up n:down height:%s" height)
        (setq char (read-char))
        (cond
         ((= char ?p)
          (setq height (+ height step)))
         ((= char ?n)
          (setq height (- height step)))
         ((and (/= char ?p) (/= char ?n))
          (message "quit text height:%s" height)
          (throw 'end:flag t)))
        (elim:set-text-height height)))))

(cond
 ((eq window-system 'ns)
  (setq ns-antialias-text t)
  (elim:set-text-height 180))
 ((eq window-system 'x)
  (elim:set-text-height 140)))
