;; ndiary-mode.el --- mode for editing ndiary's diary file
;; ISHIKURA Hiroyuki <hiro@nekomimist.org>
;; ----------------------------------------------------------------------
;; History:
;; 2000/03/29 ver.0.1  initial Release
;; 2000/04/16 ver.0.2  generic.el$B$r;H$o$J$$$h$&$KJQ99(B
;;                     .emacs$BFb$G(Bfont-lock$BDj5A$rJQ99!&DI2C$G$-$k$h$&$K$7$?(B
;; 2000/08/07 ver.0.21 ndiary-font-lock-keyword$B$r$A$g$$$H8+D>$7(B
;; 2000/09/10 ver.0.3  akihisa@alles.or.jp$B;a$N%3!<%I$r0lIt%^!<%8(B. 
;;                     $B$H$O$$$(;d$N<qL#$GBgI}$K=q$-$J$*$7$F$$$^$9(B (__)
;; 2000/09/14 ver.0.31 start-process$BA0$KF1L>$N(Bprocess$B$r(Bkill$B$9$k;v$K$7$?(B
;; 2000/09/25 ver.0.32 ndiary-preview$B$N$O$:$+$7$$%P%0$r=$@5(B
;; 2000/12/06 ver.0.33 ndiary-upload$B$G$O(Bcall-process$B$G=hM}$9$k$3$H$K$7$?(B
;;		       ($B%U%!%$%kE>Aw$r(Basync$B$G$d$k$N$O%"%l$+$J!A$H!D(B)
;; 2001/02/19 ver.0.4  customize$BBP1~(B($B$+$J$j!V$H$j$"$($:!W(B)
;; 2003/01/13 ver.0.41 face$BDI2C(B
;; 2003/01/30 ver.0.5  ndiary-edit$B$r(Bndiary-edit-internal$B$H(Bndiary-edit$B$KJ,3d(B
;;                     ndiary-edit$B$K0z$-?tDI2C(B($B0z$-?tJ,$@$1F|IU$r$:$i$9(B)
;;                     $B$$$/$D$+%(%i!<%a%C%;!<%8$r=$@5(B
;; 2003/01/31 ver.0.6  waka$B;a$N%3!<%I$r85$K!"(Byathml$B$+$i(Byahtml-insert-amps$B$r(B
;;                     $B$A$g$C$HJQ99$7$F<h$j9~$s$@(B
;; 2003/02/01 ver.0.61 ndiary-mode-version$B$rJQ$(K:$l$F$?(B :-)
;;                     ndiary-font-lock-keywords$B$N%G%U%)%k%HCM$r=$@5(B
;;
;; TODO:
;; $B!&%I%-%e%a%s%H$N=<<B(B
;; $B!&1Q8lHG(B($B$)(B
;; ----------------------------------------------------------------------
;; USAGE:
;; 1.$B$^$:(BnDiary$B$r;H$($k$h$&$K$-$A$s$H4D6-$r@0Hw$7$^$7$g$&(B. 
;;   cmd.exe$B$"$k$$$O(Bcommand.com$B$+$i(BnDiary$B$r<B9T$G$-$k$h$&$K(BPATH$B$J$I$r@_Dj(B
;;   $B$9$k$N$,%Y%9%H$G$7$g$&(B. 
;;
;; 2.APEL(http://www.m17n.org/APEL/)$B$r%$%s%9%H!<%k$7$^$7$g$&(B. Meadow$B$G$"(B
;;   $B$l$PG[I[%Q%C%1!<%8$K4^$^$l$F$$$k2DG=@-$,9b$$$G$9$,!"$^$!:G?7HG$K$9$k(B
;;   $B$N$b0-$/$J$$$G$7$g$&(B. 
;;
;; 3.$B$"$J$?$,$b$7(BMeadow1.14$B0JA0$r;H$C$F$$$k$N$G$"$l$P!"(BMeadow$B$,(Bruby$B%9%/%j(B
;;   $B%W%H$rD>@\(Bstart-process$B$d(Bcall-process$B$G$-$k$h$&$K$9$k$?$a$K!"(B.emacs$B$K(B
;;   $B0J2<$N<!$N(B5$B9T$r=q$-B-$7$^$7$g$&(B. (mw32script.el$B$r=q$-$+$($k$N$b2D(B)
;;       (require 'mw32script)
;;       (setq mw32script-argument-editing-alist
;;             (append '(("/ruby$" . "ruby.exe"))
;;                     mw32script-argument-editing-alist))
;;   Meadow1.15$B0J9_(B(Meadow2$B7O4^$`(B)$B$J$i0J2<$N0l9T$r(B.emacs$B$KB-$;$P$h$$$G$9(B. 
;;       (mw32script-init)
;;   ndiary-diary-command$B$K(BRuby$B%9%/%j%W%H$=$N$b$N$G$J$$J*(B(rbexe$BEy$r;H$C(B
;;   $B$F@8@.$7$?<B9T%U%!%$%k$H$+(B)$B$r;XDj$9$k$N$G$"$l$P!"$b$A$m$s$3$N5-=R$O(B
;;   $BI,MW$"$j$^$;$s(B. 
;;
;; 4.$B$"$J$?$N4D6-$K9g$&$h$&$K(B.emacs$B$NCf$G3F<o$N@_Dj$r9T$$$^$7$g$&(B. 
;;   Ver.0.4$B$G$O(Bcustomize$B$KBP1~$7$?$N$G!"(Bcustomize$B$r;H$&$[$&$,9,$;$+$b(B. 
;;   $B$A$J$_$K(BVer.0.3$B;~E@$G$O!";d$O<!$N$h$&$J@_Dj$rF~$l$F;H$C$F$$$^$7$?(B. 
;;       (require 'ndiary-mode)
;;       (setq ndiary-log-directory "~/diary/log")
;;       (setq ndiary-latest-filename "~/public_html/d/index.html")
;;       (setq ndiary-upload-command "sitecopy")
;;       (setq ndiary-upload-command-option "-u rim")
;;
;; 5.$B$3$l$G(BEmacs(or Meadow)$B$rN)$A$"$2$J$*$;$P4pK\E*$K$O=`Hw40N;$G$9(B. 
;;   M-x ndiary-edit $B$GF|5-JT=8%b!<%I$KF~$j$^$9$7!"(B
;;   $B$3$N%b!<%I$G(BM-x ndiary-compile (C-cC-c) $B$9$l$P(Bhtml$B$,@8@.$5$l$^$9$7!"(B
;;   $B$3$N%b!<%I$G(BM-x ndiary-upload (C-cC-u) $B$9$l$P(Bupload$B$b$G$-$^$9(B. 
;;   ($B$"$"!"$b$A$m$s(Bupload$B$9$k%D!<%k$N@_Dj$O<+J,$G$d$C$F$/$@$5$$$M(B. )
;; ----------------------------------------------------------------------
;; $Id: ndiary-mode.el,v 1.12 2003/01/31 16:33:05 neko Exp $

;; ndiary-mode requires APEL.
(require 'path-util)
(require 'alist)

;; $BDj?t(B
(defconst ndiary-mode-version "0.61" "ndiary-mode$B$N%P!<%8%g%s$r<($7$^$9(B.")

;; face$BDj5A(B
(defface ndiary-topic-head-face 
  '((((class color) (background light)) (:foreground "ForestGreen"))
    (((class color) (background dark)) (:foreground "PaleGreen"))
    (t (:bold t :underline t)))
  "$B%H%T%C%/$NKAF,5-9f$N(Bface."
  :group 'ndiary-mode)
(defvar ndiary-topic-head-face 'ndiary-topic-head-face)
(defface ndiary-topic-body-face
  '((((class color) (background light)) (:foreground "Blue"))
    (((class color) (background dark)) (:foreground "LightSkyBlue"))
    (t (:inverse-video t :bold t)))
  "$B%H%T%C%/$NK\BN$N(Bface."
  :group 'ndiary-mode)
(defvar ndiary-topic-body-face 'ndiary-topic-body-face)
(defface ndiary-item-head-face
  '((((class color) (background light)) (:foreground "Red" :bold t))
    (((class color) (background dark)) (:foreground "Pink" :bold t))
    (t (:inverse-video t :bold t)))
  "$BNs5s$N9TF,$N(Bface."
  :group 'ndiary-mode)
(defvar ndiary-item-head-face 'ndiary-item-head-face)
(defface ndiary-item-body-face
  '((((class color) (background light)) (:foreground "Blue"))
    (((class color) (background dark)) (:foreground "LightSkyBlue"))
    (t (:inverse-video t :bold t)))
  "$BNs5s$N9TF,0J30$N(Bface."
  :group 'ndiary-mode)
(defvar ndiary-item-body-face 'ndiary-item-body-face)
(defface ndiary-code-face
  '((((class color) (background light)) (:foreground "Red" :bold t))
    (((class color) (background dark)) (:foreground "Pink" :bold t))
    (t (:inverse-video t :bold t)))
  "Code:$B$H(BQuote:$B$N(Bface."
  :group 'ndiary-mode)
(defvar ndiary-code-face 'ndiary-code-face)
(defface ndiary-commant-face
  '((((class color) (background light)) (:foreground "Firebrick"))
    (((class color) (background dark)) (:foreground "OrangeRed"))
    (t (:bold t :italic t)))
  "$B%3%a%s%H$N(Bface."
  :group 'ndiary-mode)
(defvar ndiary-comment-face 'ndiary-comment-face)
(defface ndiary-tag-face
  '((((class color) (background light)) (:foreground "Purple"))
    (((class color) (background dark)) (:foreground "Cyan"))
    (t (:bold t)))
  "HTML$B$N%?%0(B($B$i$7$-$b$N(B)$B$N(Bface."
  :group 'ndiary-mode)
(defvar ndiary-tag-face 'ndiary-tag-face)
(defface ndiary-emphasis-face
  '((((class color) (background light)) (:foreground "Blue" :bold t))
    (((class color) (background dark)) (:foreground "Yellow" :bold t))
    (t (:bold t)))
  "$B6/D47O$N(Bface."
  :group 'ndiary-mode)
(defvar ndiary-emphasis-face 'ndiary-emphasis-face)

;; $BJQ?t(B
(defgroup ndiary-mode nil "Top of ndiary-mode customization group."
  :group 'hypermedia)
(defcustom ndiary-log-directory "~/diary/log"
  "$BF|5-$NCV$$$F$"$k%G%#%l%/%H%j(B."
  :type 'directory
  :group 'ndiary-mode)
(defcustom ndiary-latest-filename "~/public_html/d/index.html"
  "$B!V:G6a$NF|5-$N%@%$%8%'%9%H!W$N%U%!%$%kL>(B."
  :type 'file
  :group 'ndiary-mode)
(defcustom ndiary-split-month t
  "$B7nKh$K(Bdiary$B%U%!%$%k$r:n@.$9$k%G%#%l%/%H%j$rJ,$1$k$+H]$+(B."
  :type 'boolean
  :group 'ndiary-mode)
(defcustom ndiary-yesterday-time 2
  "$B$3$N;~4V(B(hour)$B$rD6$($k$^$G$OA0F|$H$7$F(Bdiary$B%U%!%$%k$r:n@.(B/$B<h$j$"$D$+$&(B."
  :type 'number
  :group 'ndiary-mode)
(defcustom ndiary-diary-file-coding-system 'sjis-unix
  "ndiary-mode$B$G?75,:n@.$9$k(Bdiary$B%U%!%$%k$N(Bcoding-system."
  :type 'sexp
  :group 'ndiary-mode)
(defcustom ndiary-mode-abbrev-table nil
  "ndiary-mode$B$G;H$o$l$k(Babbrev table."
  :type 'boolean
  :group 'ndiary-mode)
(defcustom ndiary-diary-command "diary"
  "$BF|5-@8@.MQ$N%3%^%s%I(B. Emacs$B$,<B9T2DG=$J%U%!%$%k$G$"$kI,MW$,$"$k(B."
  :type 'filename
  :group 'ndiary-mode)
(defcustom ndiary-diary-command-option ""
  "$BF|5-@8@.MQ$N%3%^%s%I$N%*%W%7%g%s(B."
  :type 'string
  :group 'ndiary-mode)
(defcustom ndiary-upload-command nil
  "$BF|5-%"%C%W%m!<%IMQ$N%3%^%s%I(B. Emacs$B$,<B9T2DG=%U%!%$%k$G$"$kI,MW$,$"$k(B."
  :type 'filename
  :group 'ndiary-mode)
(defcustom ndiary-upload-command-option ""
  "$BF|5-%"%C%W%m!<%IMQ$N%3%^%s%I$N%*%W%7%g%s(B."
  :type 'string
  :group 'ndiary-mode)
(defcustom ndiary-font-lock-keywords
  '(("\\(^$B"#(B\\|^$B!{(B\\|^$B!}(B\\|^$B""(B\\|^$B!~(B\\|^$B"!(B\
\\|^$B"$(B\\|^$B"%(B\\|^$B"&(B\\|^$B"'(B\\|^$B!y(B\\|^$B!z(B\\)\\(.*\\)"
     (1 ndiary-topic-head-face)
     (2 ndiary-topic-body-face))
    ("^\\($B!&(B\\)\\(.*\\)$"
     (1 ndiary-item-head-face)
     (2 ndiary-item-body-face))
    ("^\\(\\(Code:\\|Quote:\\)\\( -.*\\)?\\|^<<\\)$"
     (0 ndiary-code-face))
    ("\\((\\*[^)]*)\\|((-.*-))\\)"
     (0 ndiary-comment-face))
    ("<[^>]*>"
     (0 ndiary-tag-face)))
  "ndiary-mode$BMQ$N(Bfont-lock-keywords."
  :type 'sexp	; $B<jH4$-!D!#(B
  :group 'ndiary-mode)
(defcustom ndiary-entity-reference-chars-alist
  '((?> . "gt") (?< . "lt") (?& . "amp") (?\" . "quot"))
  "ndiary-insert-amps$BMQ$NJQ49%F!<%V%k(B"
  :type 'sexp
  :group 'ndiary-mode)
(defcustom ndiary-insert-amps-enable t
  "ndiary-insert-amps$B$rM-8z$K$9$k$+H]$+(B"
  :type 'boolean
  :group 'ndiary-mode)
(defvar ndiary-file-name nil
  "$B8=:_JT=8Cf$N(B.diary$B%U%!%$%k$N%U%k%Q%9L>$r3JG<$9$k(B. ")
(defvar ndiary-buffer nil
  "$B8=:_JT=8Cf$N(B.diary$B%U%!%$%k$N%P%C%U%!$r3JG<$9$k(B. ")

;; hooks
(defcustom ndiary-mode-load-hook nil nil
  :type 'hook
  :group 'ndiary-mode)
(defcustom ndiary-edit-hook nil	nil
  :type 'hook
  :group 'ndiary-mode)
(defcustom ndiary-pre-compile-hook nil
  "$BF|5-%U%!%$%k$r:n@.$9$kA0$K<B9T$5$l$k(Bhook.
text-adjust$B$NMQ$J%F%-%9%H@07AMQ(BLisp$B%Q%C%1!<%8$r;H$&$N$K;H$&(B."
  :type 'hook
  :group 'ndiary-mode)
(defcustom ndiary-aft-compile-hook nil
  "$BF|5-%U%!%$%k$r:n@.$7$?8e$K<B9T$5$l$k(Bhook."
  :type 'hook
  :group 'ndiary-mode)
(defcustom ndiary-pre-upload-hook nil nil
  :type 'hook
  :group 'ndiary-mode)
(defcustom ndiary-aft-upload-hook nil nil
  :type 'hook
  :group 'ndiary-mode)
(defcustom ndiary-preview-hook nil nil
  :type 'hook
  :group 'ndiary-mode)

(defun ndiary-mode ()
  "nDiary$B$G;HMQ$9$k(B.diary$B%U%!%$%k$rJT=8$9$k$?$a$N(BMajor mode.
private-abbrev-table$B$H!"0J2<$N%-!<%P%$%s%I$rDs6!$7$^$9(B:

\\[ndiary-compile]\t$BF|5-$r@8@.$9$k%3%^%s%I$r8F$S=P$9(B.
\\[ndiary-encode-region]\tregion$BFb$N(B\"<, >, &\"$B$r!"$=$l$>$l(B\"&lt; &gt; &amp;\"$B$K%(%s%3!<%I$9$k(B.
\\[ndiary-upload]\t$BF|5-$r%"%C%W%m!<%I$9$k%3%^%s%I$r8F$S=P$9(B.
\\[ndiary-preview]\tbrowse-url$B$r;H$C$FF|5-$r(Bpreview$B$9$k(B."
  (interactive)
  (kill-all-local-variables)
  (setq mode-name "nDiary")
  (setq major-mode 'ndiary-mode)
  (make-local-variable 'font-lock-keywords-only)
  (setq font-lock-keywords-only t)
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '(ndiary-font-lock-keywords))
  (setq buffer-file-coding-system ndiary-diary-file-coding-system)
  (setq local-abbrev-table ndiary-mode-abbrev-table)
  (abbrev-mode t)
  (local-set-key "\C-c\C-c" 'ndiary-compile)
  (local-set-key "\C-ce" 'ndiary-encode-region)
  (local-set-key "\C-cu" 'ndiary-upload)
  (local-set-key "\C-cp" 'ndiary-preview)
  (local-set-key "&" 'ndiary-insert-amps)
  (run-hooks 'ndiary-mode-hook))

(defun ndiary-encode-region ()		; < > &
  "$B%j!<%8%g%sFb$N(B\"<, >, &\"$B$r!"(B\
$B$=$l$>$l(B\"&lt; &gt; &amp;\"$B$K%(%s%3!<%I$7$^$9(B."
  (interactive)
  (let (end-point (head-pointp (< (point) (mark))))
    (or head-pointp (exchange-point-and-mark))
    (save-excursion
      (while (re-search-forward "[<>&]" (mark) t)
	(let (tl)
	  (setq tl (buffer-substring (match-beginning 0) (match-end 0)))
	  (cond ((string= tl "<") (replace-match "&lt;"))
		((string= tl ">") (replace-match "&gt;"))
		((string= tl "&") (replace-match "&amp;"))))))))

(defun ndiary-edit-internal (time)
  "time$B$G<($5$l$kF|IU$NF|5-%U%!%$%k$rJT=8$9$k(B."
  (let (dir)
    ;; ndiary-log-directory$B$,%"%/%;%9ITG=$J$i$*$7$^$$(B
    (if (not (file-accessible-directory-p ndiary-log-directory))
	(error "ndiary-log-directory$B$N@_Dj$,@5$7$/$J$$$H;W$o$l$^$9(B."))

    ;; $BF|5-$N%U%!%$%kL>$r7hDj$9$k(B
    (cond
     ((eq ndiary-split-month t)
      (setq dir (expand-file-name
		 (format-time-string "%Y/%m" time) ndiary-log-directory))
      (if (not (file-accessible-directory-p dir))
	  (make-directory dir t)))
     (t
      (setq dir ndiary-log-directory)))

    ;; $B%P%C%U%!$r:n$k(B
    (setq ndiary-file-name (expand-file-name 
			    (format-time-string "%Y%m%d.diary" time) dir))
    (setq ndiary-buffer (find-file ndiary-file-name)))
  (run-hooks 'ndiary-edit-hook))

(defun ndiary-edit (arg)
  "$BF|5-%U%!%$%k$rJT=8$9$k(B."
  (interactive "P")
  (let ((now (current-time)) (days 0) dateh datel daysec daysh daysl dir)
    ;; "$B:#F|(B"$B$NF|IU$N7W;;(B
    ;; $B!&(Bhour$B$,(Bndiary-yesterday-time$B0JA0$G$"$l$P(B1$BF|A0$K$:$i$9(B
    ;; $B!&0z?t$"$j8F=P$J$i(Bprompt$B$r=P$7!"F~NO$5$l$??tCM$@$1!V:#!W$+$i$:$i$9(B
    (if arg
	(setq days (floor (string-to-number
			   (read-from-minibuffer "offset: ")))))
    (setq daysec (* -1.0 days 60 60 24))
    (setq daysh (floor (/ daysec 65536.0)))
    (setq daysl (round (- daysec (* daysh 65536.0))))
    (setq dateh (- (nth 0 now) daysh))
    (setq datel (- (nth 1 now) (* ndiary-yesterday-time 3600) daysl))
    (if (< datel 0)
	(progn
	  (setq datel (+ datel 65536))
	  (setq dateh (1- dateh))))
    (if (< dateh 0)
	(setq dateh 0))
    (setq now (list dateh datel))
    (ndiary-edit-internal now)))

(defun ndiary-compile (arg)
  "$BF|5-@8@.%3%^%s%I$rH/9T$7$F(Bhtml$B%U%!%$%k$r@8@.$9$k(B. 
C-u ndiary-compile $B$H$9$k$H(B diary $B$KM?$($k%*%W%7%g%s$r;XDj$G$-$k(B."
  (interactive "P")
  (let ((com ndiary-diary-command)
	(opt ndiary-diary-command-option))
    (run-hooks 'ndiary-pre-compile-hook)
    (ndiary-save-buffers)    ;; $B<B9TA0$K(Bndiary$B4XO"%P%C%U%!$rA4$F%;!<%V$9$k!#(B
    (if (not (exec-installed-p ndiary-diary-command))
	(error "ndiary-diary-command$B$,@5$7$/@_Dj$5$l$F$$$J$$$h$&$G$9(B."))
    (if arg
	(setq com (read-from-minibuffer "diary command: " com)
	      opt (read-from-minibuffer "diary command option: " opt)))
    (save-excursion
      (set-buffer (get-buffer-create "*ndiary-compile*"))
      (if (get-process "ndiary-compile")
	  (progn
	    (delete-process "ndiary-compile")))
      (erase-buffer)
      (apply (function start-process)
	     "ndiary-compile" "*ndiary-compile*" com (split-string opt))
      (display-buffer "*ndiary-compile*"))
    (run-hooks 'ndiary-aft-compile-hook)))

(defun ndiary-upload (arg)
  "upload$BMQ%3%^%s%I(B(sitecopy$BEy(B)$B$rH/9T$7$FF|5-$r(Bupload$B$9$k(B."
  (interactive "P")
  (let ((com ndiary-upload-command)
	(opt ndiary-upload-command-option))
    (run-hooks 'ndiary-pre-upload-hook)
    (if (not (exec-installed-p com))
	(error "ndiary-upload-command$B$,@5$7$/@_Dj$5$l$F$$$J$$$h$&$G$9(B."))
    (if arg
	(setq com (read-from-minibuffer "upload command: " com)
	      opt (read-from-minibuffer "upload command option: " opt)))
    (save-excursion
      (set-buffer (get-buffer-create "*ndiary-upload*"))
      (erase-buffer)
      (display-buffer "*ndiary-upload*"))
      (apply (function call-process)
	     com nil "*ndiary-upload*" t (split-string opt))
    (run-hooks 'ndiary-aft-upload-hook)))

(defun ndiary-preview (arg)
  "latest diary file$B$r(Bpreview$B$9$k(B."
  (interactive "P")
  (let ((filename ndiary-latest-filename))
    (run-hooks 'ndiary-preview-hook)
    (if arg
	(setq filename (read-from-minibuffer "preview file: "
					     ndiary-latest-filename)))
    (setq filename (expand-file-name filename))
    (if (file-readable-p filename)
	(browse-url-of-file filename)
      (error "$B;XDj$5$l$?%U%!%$%k$OB8:_$7$J$$$h$&$G$9(B."))))

(defun ndiary-save-buffers ()
  "Save buffers whose major-mode is equal to current major-mode."
  (basic-save-buffer)
  (let ((cmm 'ndiary-mode))
    (save-excursion
      (mapcar '(lambda (buf)
		 (set-buffer buf)
		 (if (and (buffer-file-name buf)
			  (eq major-mode cmm)
			  (buffer-modified-p buf)
			  (y-or-n-p (format "Save %s" (buffer-name buf))))
		     (save-buffer buf)))
	      (buffer-list)))))

(defun ndiary-insert-amps-internal (args)
  (interactive "P")
  (let* ((mess "") c
	 (list ndiary-entity-reference-chars-alist) (l list))
    (while l
      (setq mess (format "%s %c" mess (car (car l)) (cdr (car l)))
			l (cdr l)))
    (message "Char-entity reference:  %s  SPC=& RET=&; Other=&#..;" mess)
    (setq c (read-char))
    (cond
     ((equal c (car-safe (assoc c list)))
      (insert (format "&%s;" (cdr (assoc c list)))))
     ((or (equal c ?\n) (equal c ?\r))
      (insert "&;")
      (forward-char -1))
     ((equal c ? )
      (insert ?&))
     (t (insert (format "&#%d;" c))))))

(defun ndiary-insert-amps (args)
  (interactive "P")
  "Insert char-entity references via ampersand"
  (if ndiary-insert-amps-enable
      (ndiary-insert-amps-internal args)
    (self-insert-command (prefix-numeric-value args))))

(defun ndiary-toggle-insert-amps ()
  "&$BF~NO$G(Bndiary-insert-amps$B$r8F$V$+H]$+$r@Z$j$+$($k(B."
  (interactive)
  (setq ndiary-insert-amps-enable (not ndiary-insert-amps-enable)))

(setq auto-mode-alist
      (modify-alist '(("\\.diary\\'" . ndiary-mode))
		    auto-mode-alist))
(run-hooks 'ndiary-mode-load-hook)

(provide 'ndiary-mode)
