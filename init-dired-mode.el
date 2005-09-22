; -*- emacs-lisp -*-
; $Id$

(setq dired-bind-jump nil)
(add-hook 'dired-load-hook
	  (lambda ()
	    (load "dired-x")))

(setq dired-guess-shell-alist-user
      '(("\\.tar\\.gz\\'"  "tar ztvf")
	("\\.taz\\'" "tar ztvf")
	("\\.tar\\.bz2\\'" "tar Itvf")
	("\\.zip\\'" "unzip -l")
	("\\.\\(g\\|\\) z\\'" "zcat")
	("\\.mp3\\'" "mpg321")
	("\\.ogg\\'" "ogg123")
	("\\.\\(avi\\|mpg\\|asf\\|wmv\\)\\'" "xine")
	("\\.\\(jpg\\|JPG\\|gif\\|GIF\\)\\'"
	 (if (eq system-type 'windows-nt)
	     "fiber" "display"))
	("\\.ps\\'"
	 (if (eq system-type 'windows-nt)
	     "fiber" "ggv"))))
