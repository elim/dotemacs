;; -*- emacs-lisp -*-
;; $Id$

(when window-system
  (setq default-frame-alist
	(append
	 '((foreground-color . "gray")
	   (background-color . "black")
	   (cursor-color  . "blue")
;; 	   (top . 10)
;; 	   (left . 10)
	   (width . 100)
	   (height . 40))
	 default-frame-alist)))

;; (when (eq window-system 'mac)
;;   (when (functionp 'set-active-alpha)
;;     (set-active-alpha 0.9))
;;   (when (functionp 'set-iactive-alpha)
;;     (set-inactive-alpha 0.8))))