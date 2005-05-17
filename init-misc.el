;-*- emacs-lisp -*-
; $Id$
; X$B$G$N%+%i!<I=<((B
(require 'font-lock)
(if (not (featurep 'xemacs))
    (global-font-lock-mode t))

;; goto-line
(global-set-key "\C-cg" 'goto-line)

;; Delete$B%-!<$G%+!<%=%k0LCV$NJ8;z$,>C$($k$h$&$K$9$k(B
(global-set-key [delete] 'delete-char)

;; C-h $B%-!<$G%+!<%=%k$N:8$NJ8;z$,>C$($k$h$&$K$9$k!#(B
(global-set-key "\C-h" 'backward-delete-char)

;;$BJd40;~$KBgJ8;z$H>.J8;z$r6hJL$5$;$J$$(B
(setq completion-ignore-case t)

;; $B%X%k%WEy$N(B window $B$r2DJQ$K$9$k(B
(temp-buffer-resize-mode 1)

;; visible-bell
(setq visible-bell t)

;; $B9THV9f$rI=<($9$k(B
(line-number-mode t)

;; $B7eHV9f$rI=<($9$k(B
(column-number-mode t)

;; $B%a%K%e!<$r>C$9(B
(menu-bar-mode nil)

;; $B%D!<%k%P!<$r>C$9(B
(tool-bar-mode nil)

;;$B%9%/%m!<%k%P!<$r1&$K(B
(set-scroll-bar-mode 'right)

;; $B%9%/%m!<%k%P!<$r>C$9(B
(scroll-bar-mode nil)

;; window system $B$G$O9T4V$r6u$1$k(B
(setq-default line-spacing 2)

;; $B%P%C%U%!$N:G8e$G(B newline $B$G?75,9T$rDI2C$9$k$N$r6X;_$9$k(B
(setq next-line-add-newlines nil)

;; $BF10l%U%!%$%kL>$N%P%C%U%!L>$rJ,$+$j$d$9$/(B
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")
(setq uniquify-min-dir-content 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; grep-edit
;;
(require 'grep-edit)

;;kill-ring $B$KF1$8FbMF$NJ8;zNs$rJ#?tF~$l$J$$(B
(defadvice kill-new (before ys:no-kill-new-duplicates activate)
  (setq kill-ring (delete (ad-get-arg 0) kill-ring)))

(setq x-select-enable-clipboard t)