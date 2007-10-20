;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; http://homepage1.nifty.com/blankspace/emacs/tips.html
(defadvice display-completion-list (after display-completion-list-highlight activate)
  (let* ((str-list (mapcar (lambda(x) (cond ((stringp x) x)
					    ((symbolp x) (symbol-name x))
					    ((listp x) (concat (car x)
							       (cadr x)))))
			   (ad-get-arg 0)))
	 (str (car str-list)))
    (mapcar (lambda (x)
	      (while (or (> (length str) (length x))
			 (not (string= (substring str 0 (length str))
				       (substring   x 0 (length str)))))
		(setq str (substring str 0 -1))))
	    str-list)
    (save-current-buffer
      (set-buffer "*Completions*")
      (save-excursion
	(re-search-forward "Possible completions are:" (point-max) t)
	(while (re-search-forward (concat "[ \n]\\<" str) (point-max) t)
	  (let ((o1 (make-overlay (match-beginning 0) (match-end 0)))
		(o2 (make-overlay (match-end 0)       (1+ (match-end 0)))))
	    (overlay-put o1 'face '(:foreground "HotPink3"))
	    (overlay-put o2 'face '(:foreground "white" :background "DeepSkyBlue4"))))))))
