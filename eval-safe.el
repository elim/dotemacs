;-*- emacs-lisp -*-
; $Id: init-emacs.el 101 2005-05-07 13:40:20Z takeru $
; http://www.sodan.org/%7Eknagano/emacs/dotemacs.html

(defmacro eval-safe (&rest body)
  "安全な評価。評価に失敗してもそこで止まらない。"
  `(condition-case err
       (progn ,@body)
     (error (message "[eval-safe] %s" err))))

;; 使い方は、
;;
;; (eval-safe (some-suspicious-code))
;; ;; nesting もできます。
;; (eval-safe
;;  (insert "1")
;;  (eval-safe
;;   (insert "2")
;;   (no-such-function))
;;  (insert "3")
;;  (no-such-function))
