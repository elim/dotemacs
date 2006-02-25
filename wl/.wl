;; dot.wl -- sample setting file for Wanderlust	-*- emacs-lisp -*-
;; $Id$
;; [[ $BF0:n$KI,MW$J@_Dj(B ]]

;; $B$^$:!"<!$N@_Dj$r(B ~/.emacs $B$J$I$K=q$$$F$/$@$5$$!#(B
;; XEmacs $B$N(B package $B$H$7$F%$%s%9%H!<%k$5$l$F$$$k>l9g$OI,MW$"$j$^$;$s!#(B
;(autoload 'wl "wl" "Wanderlust" t)
;(autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
;(autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

;; $B%"%$%3%s$rCV$/%G%#%l%/%H%j(B
;; XEmacs $B$N(B package $B$H$7$F%$%s%9%H!<%k$5$l$F$$$k>l9g$OI,MW$"$j$^$;$s!#(B
;(setq wl-icon-directory "/usr/local/lib/emacs/etc")


;; [[ SEMI $B$N@_Dj(B ]]

;; HTML $B%Q!<%H$rI=<($9$k$+(B
;; mime-setup $B$,%m!<%I$5$l$kA0$K5-=R$9$kI,MW$,$"$j$^$9!#(B
(setq mime-setup-enable-inline-html nil)

;; $BBg$-$$%a%C%;!<%8$rAw?.;~$KJ,3d$9$k$+(B
(setq mime-edit-split-message nil)

;; $BBg$-$$%a%C%;!<%8$H$_$J$99T?t$N@_Dj(B
;(setq mime-edit-message-default-max-lines 1000)

;;; [[ $B8D?M>pJs$N@_Dj(B ]]

;; From: $B$N@_Dj(B
(setq wl-from "Takeru Naito <fascinating_logic@ybb.ne.jp>")

;; $B<+J,$N%a!<%k%"%I%l%9$N%j%9%H(B
(setq wl-user-mail-address-list
      (list (wl-address-header-extract-address wl-from)
	    "fascinating_logic@ybb.ne.jp"
	    "a.k.a.elim@gmail.com"
	    "takeru@at-mac.com"
	    "elim@TerokNor.org"
	    "picard@mx12.freecom.ne.jp"))

;; $B<+J,$N;22C$7$F$$$k%a!<%j%s%0%j%9%H$N%j%9%H(B
(setq wl-subscribed-mailing-list
      '("debian-users@debian.or.jp"
	"ruby-list@ruby-lang.org"
	"wl@lists.airs.net"
	"apel-ja@m17n.or"
	"emacs-mime-ja@m17n.org"
	"DeepSpace@panda.starfleet.ac"
	"alib@alib.jp"
	"share@alib.jp"))

;; (system-name) $B$,(B FQDN $B$rJV$5$J$$>l9g!"(B
;; `wl-local-domain' $B$K%[%9%HL>$r=|$$$?%I%a%$%sL>$r@_Dj$7$F$/$@$5$$!#(B
;; (system-name)  "." wl-local-domain $B$,(B Message-ID $B$K;HMQ$5$l$^$9!#(B
;(setq system-name "elim.teroknor.org")

(cond
 ((not (string-match "fascinating.local$" system-name))
  (setq wl-local-domain "elim.teroknor.org")))

;; Message-ID $B$N%I%a%$%s%Q!<%H$r6/@)E*$K;XDj(B
(setq wl-message-id-domain "elim.teroknor.org")

;; Message-ID $B$N%I%a%$%s%Q!<%H$r(B wl-from $B$+$i@8@.$7$^$9!#(B
;; global$B$J(BIP$B$r;}$?$J$$>l9g$K;H$C$F$/$@$5$$!#(B
;; wl-local-domain, wl-message-id-domain$B$KM%@h$7$^$9!#(B
(setq wl-message-id-use-wl-from nil)

;; Message-ID $B$r<+F0IUM?$7$J$$(B
;; (setq wl-insert-message-id nil)

;;; [[ $B%5!<%P$N@_Dj(B ]]
(setq my-wl-server-name
 (cond
  ((string-match "fascinating.local$" system-name)
   "idea")
  (t
   "localhost")))

;; IMAP $B%5!<%P$N@_Dj(B
(setq elmo-imap4-default-server my-wl-server-name)
;; POP $B%5!<%P$N@_Dj(B
(setq elmo-pop3-default-server my-wl-server-name)
;; SMTP $B%5!<%P$N@_Dj(B
(setq wl-smtp-posting-server my-wl-server-name)
(setq wl-smtp-posting-user "takeru")
(setq wl-smtp-authenticate-type "cram-md5")
;; $B%K%e!<%9%5!<%P$N@_Dj(B
(setq elmo-nntp-default-server "news.media.kyoto-u.ac.jp")
;; $BEj9F@h$N%K%e!<%9%5!<%P(B
(setq wl-nntp-posting-server elmo-nntp-default-server)
;; $B%K%e!<%9%5!<%P$N%f!<%6L>(B
(setq elmo-nntp-default-user "fascinating_logic@ybb.ne.jp")

;; IMAP $B%5!<%P$NG'>ZJ}<0$N@_Dj(B
;(setq elmo-imap4-default-authenticate-type 'clear) ; $B@8%Q%9%o!<%I(B
(setq elmo-imap4-default-authenticate-type 'cram-md5) ; CRAM-MD5

;; POP-before-SMTP
;(setq wl-draft-send-mail-function 'wl-draft-send-mail-with-pop-before-smtp)

;; IMAP $B%5!<%P$N%]!<%H(B
;; IMAP $B%5!<%P$H$NDL?.J}<0(B
(cond
 ((string-match "fascinating.local$" system-name)
  (setq elmo-imap4-default-port 993)
  (setq elmo-imap4-default-stream-type 'ssl))
  (t
   (setq elmo-imap4-default-port 10143)))

;;; [[ $B4pK\E*$J@_Dj(B ]]

;; `wl-summary-goto-folder' $B$N;~$KA*Br$9$k%G%U%)%k%H$N%U%)%k%@(B
(setq wl-default-folder "%INBOX")

;; $B%U%)%k%@L>Jd40;~$K;HMQ$9$k%G%U%)%k%H$N%9%Z%C%/(B
(setq wl-default-spec "%")

;; Folder Carbon Copy
(setq wl-fcc "%Sent")

;; draft folder
(setq wl-draft-folder "%Drafts")

;; trash folder
(setq wl-trash-folder "%Trash")

;; $B=*N;;~$K3NG'$9$k(B
(setq wl-interactive-exit t)

;; $B%a!<%kAw?.;~$K$O3NG'$9$k(B
(setq wl-interactive-send t)

;; $B%9%l%C%I$O>o$K3+$/(B
;(setq wl-thread-insert-opened t)

;; $B%5%^%j%P%C%U%!$N:8$K%U%)%k%@%P%C%U%!$rI=<($9$k(B (3$B%Z%$%sI=<((B)
;(setq wl-stay-folder-window t)

;; $BD9$$9T$r@Z$j=L$a$k(B
;(setq wl-message-truncate-lines t)
;(setq wl-draft-truncate-lines t)
;; XEmacs (21.4.6 $B$h$jA0(B) $B$N>l9g!"0J2<$bI,MW!#(B
;(setq truncate-partial-width-windows nil)

;; $B%I%i%U%H$r?7$7$$%U%l!<%`$G=q$/(B
;(setq wl-draft-use-frame t)

;; $B%9%l%C%II=<($N%$%s%G%s%H$rL5@)8B$K$9$k!#(B
(setq wl-summary-indent-length-limit nil)
(setq wl-summary-width nil)

;; $B%5%V%8%'%/%H$,JQ$o$C$?$i%9%l%C%I$r@Z$C$FI=<((B
;(setq wl-summary-divide-thread-when-subject-changed t)

;; $B%9%l%C%I$N8+$?L\$rJQ$($k(B
;(setq wl-thread-indent-level 2)
;(setq wl-thread-have-younger-brother-str "+"
;      wl-thread-youngest-child-str	 "+"
;      wl-thread-vertical-str		 "|"
;      wl-thread-horizontal-str		 "-"
;      wl-thread-space-str		 " ")

;; $B%5%^%j0\F08e$K@hF,%a%C%;!<%8$rI=<($9$k(B
;(setq wl-auto-select-first t)

;; $B%5%^%jFb$N0\F0$GL$FI%a%C%;!<%8$,$J$$$H<!$N%U%)%k%@$K0\F0$9$k(B
;(setq wl-auto-select-next t)

;; $BL$FI$,$J$$%U%)%k%@$OHt$P$9(B(SPC$B%-!<$@$1$GFI$_?J$a$k>l9g$OJXMx(B)
(setq wl-auto-select-next 'skip-no-unread)

;; $BL$FI%a%C%;!<%8$rM%@hE*$KFI$`(B
(setq wl-summary-move-order 'unread)

;; $BCe?.DLCN$N@_Dj(B
(setq wl-biff-check-folder-list '("%INBOX"))
(setq wl-biff-notify-hook '(ding))


;;; [[ $B%M%C%H%o!<%/(B ]]

;; $B%U%)%k%@<oJL$4$H$N%-%c%C%7%e$N@_Dj(B
;; (localdir, localnews, maildir $B$O%-%c%C%7%e$G$-$J$$(B)
;(setq elmo-archive-use-cache nil)
;(setq elmo-nntp-use-cache t)
;(setq elmo-imap4-use-cache t)
;(setq elmo-pop3-use-cache t)

;; $B%*%U%i%$%s(B(unplugged)$BA`:n$rM-8z$K$9$k(B($B8=:_$O(BIMAP$B%U%)%k%@$N$_(B)
(setq elmo-enable-disconnected-operation t)

;; unplugged $B>uBV$GAw?.$9$k$H!$%-%e!<(B(`wl-queue-folder')$B$K3JG<$9$k(B
(setq wl-draft-enable-queuing t)
;; unplugged $B$+$i(B plugged $B$KJQ$($?$H$-$K!$%-%e!<$K$"$k%a%C%;!<%8$rAw?.$9$k(B
(setq wl-auto-flush-queue t)

;; $B5/F0;~$O%*%U%i%$%s>uBV$K$9$k(B
;(setq wl-plugged nil)
;; $B5/F0;~$K%]!<%H$4$H$N(Bplug$B>uBV$rJQ99$9$k(B
;(add-hook 'wl-make-plugged-hook
;	  '(lambda ()
;	     ;; server,port$B$N(Bplug$B>uBV$r?75,DI2C$b$7$/$OJQ99$9$k(B
;	     (elmo-set-plugged plugged$BCM(B(t/nil) server port)
;	     ;; port $B$r>JN,$9$k$H(Bserver$B$NA4(Bport$B$,JQ99$5$l$k(B
;	     ;; (port $B$r>JN,$7$F?75,$NDI2C$O$G$-$J$$(B)
;	     (elmo-set-plugged plugged$BCM(B(t/nil) server)
;	     ))


;;; [[ $BFC<l$J@_Dj(B ]]

;; $B%5%^%j$G$N(B "b" $B$r%a%C%;!<%8:FAw$K$9$k(B (mutt $B$N(B "b"ounce)
;(add-hook 'wl-summary-mode-hook
;	  '(lambda ()
;	     (define-key wl-summary-mode-map "b" 'wl-summary-resend-message)))

;; $B%0%k!<%W$r(Bcheck$B$7$?8e$KL$FI$,$"$k%U%)%k%@$N%0%k!<%W$r<+F0E*$K3+$/(B
;(add-hook 'wl-folder-check-entity-hook
;	  '(lambda ()
;	     (wl-folder-open-unread-folder entity)
;	     ))

;; $B%5%^%jI=<(4X?t$rJQ99$9$k(B

;; `elmo-msgdb-overview-entity-get-extra-field' $B$G;2>H$7$?$$%U%#!<%k%I!#(B
;; $B<+F0%j%U%!%$%k$G;2>H$7$?$$%U%#!<%k%I$b@_Dj$9$k!#(B
(setq elmo-msgdb-extra-fields
      '("reply-to"))

;; ML $B$N%a%C%;!<%8$G$"$l$P!$%5%^%j$N(B Subject $BI=<($K(B
;; ML$BL>(B $B$d(B ML$B$K$*$1$k%a%C%;!<%8HV9f$bI=<($9$k(B
(setq wl-summary-line-format "%n%T%P%M/%D(%W)%h:%m %t%[%17(%c %f%) %] %#%~%s")
;; $B%U%)%k%@Kh$K%5%^%j$NI=<(7A<0$rJQ$($k@_Dj(B
;(setq wl-folder-summary-line-format-alist
;      '(("^%inbox\\.emacs\\.wl$" .
;	 "%-5l%T%P%M/%D %h:%m %-4S %[ %17f %] %t%C%s")
;	("^%" . "%T%P%M/%D %h:%m %-4S %[ %17f %] %t%C%s")
;	("^+" . "%n%T%P%M/%D %h:%m %-4S %[ %17f %] %t%C%s")))

;; imput $B$K$h$jHsF14|$GAw?.$9$k(B
;; (utils/im-wl.el $B$r%$%s%9%H!<%k$7$F$*$/I,MW$,$"$j$^$9!#(B
;;  $B$^$?!$(B~/.im/Config $B$N@_Dj(B(Smtpservers)$B$rK:$l$J$$$3$H$H!$(B
;;  wl-draft-enable-queuing $B$N5!G=$,F/$+$J$/$J$k$3$H$KCm0U!#(B)
;(autoload 'wl-draft-send-with-imput-async "im-wl")
;(setq wl-draft-send-function 'wl-draft-send-with-imput-async)


;; $BC;$$(B User-Agent: $B%U%#!<%k%I$r;H$&(B
;(setq wl-generate-mailer-string-function
;      'wl-generate-user-agent-string-1)



;; $B%a!<%k(BDB$B$K(Bcontent-type$B$r2C$($k(B
(setq elmo-msgdb-extra-fields
    (cons "content-type" elmo-msgdb-extra-fields))
;; $BE:IU%U%!%$%k$,$"$k>l9g$O!V(B@$B!W$rI=<((B
(setq wl-summary-line-format "%n%T%P%1@%M/%D(%W)%h:%m %t%[%17(%c %f%) %] %#%~%s")
(setq wl-summary-line-format-spec-alist
      (append wl-summary-line-format-spec-alist
	      '((?@ (wl-summary-line-attached)))))

;; $BJQ99$5$l$?%I%i%U%H$,$"$l$P(B 20 $BIC$4$H$K<+F0J]B8$9$k!#(B
;; (defun my-wl-auto-save-draft-buffers ()
;;   (let ((buffers (wl-collect-draft)))
;;     (save-excursion
;;       (while buffers
;; 	(set-buffer (car buffers))
;; 	(if (buffer-modified-p) (wl-draft-save))
;; 	(setq buffers (cdr buffers))))))
;; (run-with-idle-timer 20 t 'my-wl-auto-save-draft-buffers)


;;; [[ $B%F%s%W%l!<%H(B ]]

;; $B%F%s%W%l!<%H$N@_Dj(B
(setq wl-template-alist
      '(("default"
	 (wl-smtp-posting-server . "ybbsmtp.mail.yahoo.co.jp")
	 (wl-smtp-posting-port . "25")
	 (wl-smtp-authenticate-type . "plain")
	 (wl-smtp-posting-user . "fascinating_logic")
	 ("From" . "Takeru Naito <fascinating_logic@ybb.ne.jp>")
	 (signature-file-name . "~/.signature"))
;; 	("gmail"
;; 	 (wl-smtp-posting-server . "smtp.gmail.com")
;; 	 (wl-smtp-posting-user . "a.k.a.elim@gmail.com")
;; 	 (wl-smtp-connection-type . "starttls")
;; 	 (wl-smtp-posting-port . "587")
;; 	 (wl-smtp-authenticate-type . "plain")
;; 	 ("From" . "Takeru Naito  <a.k.a.elim@gmail.com>")
;; 	 (signature-file-name . "~/.signature.gmail"))
	("terok"
	 (wl-smtp-posting-server . "mail.teroknor.org")
	 (wl-smtp-posting-port . "25")
	 (wl-smtp-authenticate-type . "plain")
	 (wl-smtp-posting-user . "elim")
	 ("From" . "Elim Garak <elim@TerokNor.org>")
	 (signature-file-name . "~/.signature.terok"))
	("elim.terok"
	 (wl-smtp-posting-server . my-wl-server-name)
	 (wl-smtp-posting-port . "25")
	 (wl-smtp-authenticate-type . "cram-md5")
	 (wl-smtp-posting-user . "takeru")
	 ("From" . "Takeru Naito  <takeru@elim.teroknor.org>")
	 (signature-file-name . "~/.signature.terok"))))

;; $B%I%i%U%H%P%C%U%!$NFbMF$K$h$j(B From $B$d(B Organization $B$J$I$N%X%C%@$r<+(B
;; $BF0E*$KJQ99$9$k(B
(setq wl-draft-config-alist
      '(("^From.*TerokNor"
;        $B%I%i%U%H(B<$B%P%C%U%!$N%X%C%@$K%^%C%A$9$l$PE,MQ$9$k(B
;	 (top-file . "$B<+F0A^F~$N;n83$G$9!#!@(Bn")	; $BK\J8@hF,$X$NA^F~(B
;	 (setq wl-message-id-domain "mail.TerokNor.org")
;	 (setq wl-draft-send-mail-function 'wl-draft-send-mail-with-pop-before-smtp)
;	 (wl-smtp-posting-server . "mail.TerokNor.org")
;	 (wl-pop-before-smtp-server . "mail.TerokNor.org")
	)))
;; Daredevil SKK $B$N(B version $B$r%X%C%@$KF~$l$k(B
(when (locate-library "skk-version")
  (add-to-list 'wl-draft-config-alist
	       `(t ("X-Input-Method" . ,(skk-version)))))

;; $B%I%i%U%H:n@.;~(B($BJV?.;~(B)$B$K!$<+F0E*$K%X%C%@$rJQ99$9$k(B
(add-hook 'wl-mail-setup-hook
	  '(lambda ()
	     (unless wl-draft-reedit	; $B:FJT=8;~$OE,MQ$7$J$$(B
	       (wl-draft-config-exec wl-draft-config-alist))))


;;; [[ $BJV?.;~$N@_Dj(B ]]

;; $BJV?.;~$N%&%#%s%I%&$r9-$/$9$k(B
;(setq wl-draft-reply-buffer-style 'full)

;; $BJV?.;~$N%X%C%@$KAj<j$NL>A0$rF~$l$J$$!#(B
(setq wl-draft-reply-use-address-with-full-name nil)

;; $B%a!<%k$NJV?.;~$K08@h$rIU$1$kJ}?K$N@_Dj(B
;; $B2<5-JQ?t$N(B alist $B$NMWAG(B
;; ("$BJV?.85$KB8:_$9$k%U%#!<%k%I(B" .
;;   ('To$B%U%#!<%k%I(B' 'Cc$B%U%#!<%k%I(B' 'Newsgroups$B%U%#!<%k%I(B'))

;; "a" (without-argument)$B$G$O(B Reply-To: $B$d(B From: $B$J$I$G;XDj$5$l$?M#0l?M(B
;; $B$^$?$OM#0l$D$NEj9F@h$KJV?.$9$k!#$^$?!$(BX-ML-Name: $B$H(B Reply-To: $B$,$D$$(B
;; $B$F$$$k$J$i(B Reply-To: $B08$K$9$k!#(B
;(setq wl-draft-reply-without-argument-list
;      '((("X-ML-Name" "Reply-To") . (("Reply-To") nil nil))
;	("X-ML-Name" . (("To" "Cc") nil nil))
;	("Followup-To" . (nil nil ("Followup-To")))
;	("Newsgroups" . (nil nil ("Newsgroups")))
;	("Reply-To" . (("Reply-To") nil nil))
;	("Mail-Reply-To" . (("Mail-Reply-To") nil nil))
;	("From" . (("From") nil nil))))

;; "C-u a" (with-argument)$B$G$"$l$P4X78$9$kA4$F$N?M!&Ej9F@h$KJV?.$9$k!#(B
;(setq wl-draft-reply-with-argument-list
;      '(("Followup-To" . (("From") nil ("Followup-To")))
;	("Newsgroups" . (("From") nil ("Newsgroups")))
;	("Mail-Followup-To" . (("Mail-Followup-To") nil ("Newsgroups")))
;	("From" . (("From") ("To" "Cc") ("Newsgroups")))))


;;; [[ $B%a%C%;!<%8I=<($N@_Dj(B ]]

;; $B1#$7$?$$%X%C%@$N@_Dj(B
(setq wl-message-ignored-field-list
      '(".*Received:" ".*Path:" ".*Id:" "^References:"
	"^Replied:" "^Errors-To:"
	"^Lines:" "^Sender:" ".*Host:" "^Xref:"
	"^Content-Type:" "^Precedence:"
	"^Status:" "^X-VM-.*:"))

;; $BI=<($9$k%X%C%@$N@_Dj(B
;; 'wl-message-ignored-field-list' $B$h$jM%@h$5$l$k(B
(setq wl-message-visible-field-list '("^Message-Id:"))


;; X-Face $B$rI=<($9$k(B
(when window-system
  (cond ((and (featurep 'xemacs)	; for XEmacs
	      (module-installed-p 'x-face))
	 (autoload 'x-face-xmas-wl-display-x-face "x-face")
	 (setq wl-highlight-x-face-function 'x-face-xmas-wl-display-x-face))

	;; for Emacs21
	((and (not (featurep 'xemacs))
	      (= emacs-major-version 21)
	      (module-installed-p 'x-face-e21))
	 (autoload 'x-face-decode-message-header "x-face-e21")
	 (setq wl-highlight-x-face-function 'x-face-decode-message-header))

	;; for Emacs 19.34, Emacs 20.x
	((module-installed-p 'x-face-mule)
	 ;; x-face-mule distributed with bitmap-mule 8.0 or later
	 (autoload 'x-face-decode-message-header "x-face-mule")
	 (setq wl-highlight-x-face-function 'x-face-decode-message-header))))

;; $B%9%3%"5!G=$N@_Dj(B
;; `wl-score-folder-alist' $B$N@_Dj$K4X$o$i$:I,$:(B "all.SCORE" $B$O;HMQ$5$l$k!#(B
;(setq wl-score-folder-alist
;      '(("^-comp\\."
;	 "news.comp.SCORE"
;	 "news.SCORE")
;	("^-"
;	 "news.SCORE")))


;; $B<+F0%j%U%!%$%k$N%k!<%k@_Dj(B
;; (setq wl-refile-rule-alist '(
;; 	("Subject"
;; 	 ("foo" . "+inbox/foo"))
;; 	("x-ml-name"
;; 	 ("^Elisp" . "+elisp"))
;; 	("From"
;; 	 ("bar" . "+inbox/bar"))))

;; $B<+F0%j%U%!%$%k$7$J$$1JB3%^!<%/$r@_Dj(B
;; $BI8=`$G$O(B "N" "U" "!" $B$K$J$C$F$*$j!"L$FI%a%C%;!<%8$r<+F0%j%U%!%$%k$7(B
;; $B$^$;$s!#(Bnil $B$G$9$Y$F$N%a%C%;!<%8$,BP>]$K$J$j$^$9!#(B
;(setq wl-summary-auto-refile-skip-marks nil)


;;; dot.wl ends here