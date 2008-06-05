;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-
;;; $Id$
;; based upon
;;   http://www.namazu.org/%7Etsuchiya/elisp/#chmod

(defun make-file-executable ()
  "Make the file of this buffer executable, when it is a script source."
  (save-restriction
    (widen)
    (if (string= "#!" (buffer-substring-no-properties 1 (min 3 (point-max))))
	(let ((name (buffer-file-name)))
	  (or (equal ?. (string-to-char (file-name-nondirectory name)))
	      (let ((mode (file-modes name)))
		(set-file-modes
		 name (logior mode (logand (/ mode 4) 73)))))))))
(add-hook 'after-save-hook 'make-file-executable)
