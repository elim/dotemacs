;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$
;;;; based upon dot.wl

;;; [[ Private Setting ]]

;; Header From:
;; this overwrites in a default template later.
(setq wl-from "nobody@example.net")

;; User's mail addresses.
(setq wl-user-mail-address-list nil)

;; Subscribed mailing list.
(setq wl-subscribed-mailing-list nil)

;; If (system-name) does not return FQDN,
;; set following as a local domain name without hostname.
;; this overwrites in a default template later.
(setq wl-local-domain nil)

;; Use `wl-from' for domain part of Message-ID.
(setq wl-message-id-use-wl-from t)

;; Insert Message-ID: field.
(setq wl-insert-message-id t)

;; Folder Carbon Copy
(setq wl-fcc "%Sent")

;; draft folder
(setq wl-draft-folder "%Drafts")

;;; [[ Server Setting ]]
;; IMAP server
(setq elmo-imap4-default-server
      (if (domestic-network-member-p) "idea" "localhost"))
(setq elmo-imap4-default-port
      (if (domestic-network-member-p)  143 10143))
(setq elmo-imap4-default-authenticate-type 'cram-md5)

;; SMTP server
;; this overwrites in a default template later.
(setq wl-smtp-posting-server "example.net")

;; POP server
;; this overwrites in a default template later.
(setq elmo-pop3-default-server nil)

;; NNTP server
(setq elmo-nntp-default-server nil)
(setq wl-nntp-posting-server elmo-nntp-default-server)

;;; [[ Basic Setting ]]
;; Default folder for `wl-summary-goto-folder'.
(setq wl-default-folder "%INBOX")

;; Default string for folder name completion.
(setq wl-default-spec "%")

;; Trash folder
(setq wl-trash-folder "%Trash")

;; Confirm before exitting Wanderlust.
(setq wl-interactive-exit t)

;; Confirm before sending message.
(setq wl-interactive-send t)

;; Criterion for Access group (regexp)
;(setq wl-folder-hierarchy-access-folders
;      '("^%[^¥¥.]*$"))

;; Create opened thread.
;(setq wl-thread-insert-opened t)

;; Keep folder window beside summary. (3 pane)
;(setq wl-stay-folder-window t)

;; Truncate long lines.
;(setq wl-message-truncate-lines t)
;(setq wl-draft-truncate-lines t)
;; Following line is needed for XEmacs older than 21.4.6.
;(setq truncate-partial-width-windows nil)

;; Open new frame for draft buffer.
;(setq wl-draft-use-frame t)

;; Don't limit indent for thread view
(setq wl-summary-indent-length-limit nil)
(setq wl-summary-width nil)

;; Divide thread by change of subject.
;(setq wl-summary-divide-thread-when-subject-changed t)

;; Change format of thread view
;(setq wl-thread-indent-level 2)
;(setq wl-thread-have-younger-brother-str "+"
;      wl-thread-youngest-child-str	 "+"
;      wl-thread-vertical-str		 "|"
;      wl-thread-horizontal-str		 "-"
;      wl-thread-space-str		 " ")

;; display first message automatically.
;(setq wl-auto-select-first t)

;; goto next folder when exit from summary.
;(setq wl-auto-select-next t)

;; skip folder if there is no unread message.
(setq wl-auto-select-next 'skip-no-unread)

;; jump to unread message in 'N' or 'P'.
(setq wl-summary-move-order 'unread)

;; notify mail arrival
(setq wl-biff-check-folder-list '("%INBOX"))
(setq wl-biff-notify-hook '(ding))

;;; [[ Network ]]
;; cache setting.
;; (messages in localdir, localnews, maildir are not cached.)
;(setq elmo-archive-use-cache nil)
;(setq elmo-nntp-use-cache t)
;(setq elmo-imap4-use-cache t)
;(setq elmo-pop3-use-cache t)

;; Enable disconnected operation in IMAP folder.
(setq elmo-enable-disconnected-operation t)

;; Reconnect before summary checking.
(defadvice wl-folder-check-current-entity
  (before before-wl-folder-check-current-entity activate)
  (wl-toggle-plugged 'off)
  (wl-toggle-plugged 'on))

;; Store draft message in queue folder if message is sent in unplugged status.
(setq wl-draft-enable-queuing t)
;; when plug status is changed from unplugged to plugged,
;; queued message is flushed automatically.
(setq wl-auto-flush-queue t)

;; offline at startup.
;(setq wl-plugged nil)
;; change plug status by server or port at startup.
;(add-hook 'wl-make-plugged-hook
;	  '(lambda ()
;	     ;; Add or Change plug status for SERVER and PORT.
;	     (elmo-set-plugged plugged(t/nil) server port)
;	     ;; When omit port, SEVERS all port was changes.
;	     ;; (Can't add plug status without PORT)
;	     (elmo-set-plugged plugged(t/nil) server)
;	     ))

;;; [[ Special Setting ]]

;; open unread group folder after checking.
;(add-hook 'wl-folder-check-entity-hook
;	  '(lambda ()
;	     (wl-folder-open-unread-folder entity)
;	     ))

;; Jump to unfiltered folder by `wl-summary-exit'. It is useful for people who
;; use filtered folder as a temporary folder created by `wl-summary-virtual'.
;(add-hook 'wl-summary-prepared-hook
;	  '(lambda ()
;	     (setq wl-summary-buffer-exit-function
;		   (when (eq 'filter
;			     (elmo-folder-type-internal wl-summary-buffer-elmo-folder))
;		     'wl-summary-unvirtual))))

;; Change summary display function.

;; Set extra field use with `elmo-message-entity-field'.
;; And use with auto-refile.
(setq elmo-msgdb-extra-fields
      '("reply-to"))

;; ML message displays ML name and ML sequence number in subject.
(setq wl-summary-line-format "%n%T%P%M/%D(%W)%h:%m %t%[%17(%c %f%) %] %#%~%s")
;; Set summary line format according to folder name.
;(setq wl-folder-summary-line-format-alist
;      '(("^%inbox\\.emacs\\.wl$" .
;	 "%-5l%T%P%M/%D %h:%m %-4S %[ %17f %] %t%C%s")
;	("^%" . "%T%P%M/%D %h:%m %-4S %[ %17f %] %t%C%s")
;	("^+" . "%n%T%P%M/%D %h:%m %-4S %[ %17f %] %t%C%s")))

;; imput asynchronously.
;; (utils/im-wl.el is needed to be installed.
;;  Don't forget setting ~/.im/Config (Smtpservers).
;;  note that wl-draft-enable-queuing is not valid.)
;(autoload 'wl-draft-send-with-imput-async "im-wl")
;(setq wl-draft-send-function 'wl-draft-send-with-imput-async)

;; non-verbose User-Agent: field
;(setq wl-generate-mailer-string-function
;      'wl-generate-user-agent-string-1)

;; Add content-type to mail DB.
(setq elmo-msgdb-extra-fields
      (cons "content-type" elmo-msgdb-extra-fields))

;; Add indicator `@' if attached files included.
(setq wl-summary-line-format "%n%T%P%1@%M/%D(%W)%h:%m %t%[%17(%c %f%) %] %#%~%s")
(setq wl-summary-line-format-spec-alist
      (append wl-summary-line-format-spec-alist
	      '((?@ (wl-summary-line-attached)))))

;;; [[ Template ]]

;; templates
(setq wl-template-directory
      (expand-file-name "templates" wl-preference-directory))
(setq wl-template-alist nil)

(load-directory-files wl-template-directory "^.+el$")

(defadvice wl-draft (after after-wl-draft activate)
  (wl-template-apply "default")
  (unless
      (wl-message-field-exists-p "To")
    (progn
      (wl-draft-config-body-goto-header)
      (goto-char (point-min))
      (wl-draft-config-sub-eval-insert "To" 'newline)
      (backward-char)
      (wl-complete-field-body-or-tab))))

(defadvice wl-template-select (before before-template-select activate)
  (wl-template-apply "default")) ;; reset variables.

;; signatures
(setq signature-file-name nil)
(setq wl-signature-directory
      (expand-file-name "signatures" wl-preference-directory))

(defadvice wl-template-set (after after-template-set activate)
  (setq signature-file-name
	(expand-file-name
	 wl-template wl-signature-directory)))

;; Change headers in draft sending time.
;(setq wl-draft-config-alist
;      '((reply				; see reply buffer
;	 "^To: .*test-notsend-wl@lists\\.airs\\.net"
;	 (template . "default"))	; template
;	("^To: .*test-notsend-wl@lists\\.airs\\.net"
;	 ding				; function
;	 ("From" . wl-from)		; variable
;	 ("Organization" . "organization")) ; string
;	("^Newsgroups: test.*"
;	 ("Organization" . "organization for nntp."))
;	))

;; Insert Daredevil SKK's version to header.
(when (locate-library "skk-version")
  (add-to-list 'wl-draft-config-alist
	       `(t ("X-Input-Method" . ,(skk-version)))))

;; Turn on Daredevil SKK to draft writing.
;(when (locate-library "skk")
;  (defadvice wl-draft (after after-wl-draft)
;    (skk-mode t))
;  (ad-activate 'wl-draft))

;; Change headers in draft preparation time.
(add-hook 'wl-mail-setup-hook
	  '(lambda ()
	     (unless wl-draft-reedit	; don't apply when reedit.
	       (wl-draft-config-exec wl-draft-config-alist))))

;; [[ Reply ]]
;; header value setting for mail reply.

;; Wide window for draft buffer.
;(setq wl-draft-reply-buffer-style 'full)

;; Remove fullname in reply message header.
(setq wl-draft-reply-use-address-with-full-name nil)

;; "a" (without-argument) reply to author (Reply-To or From).
;; if 'X-ML-Name' and 'Reply-To' exists, reply to 'Reply-To'.
;(setq wl-draft-reply-without-argument-list
;      '((("X-ML-Name" "Reply-To") . (("Reply-To") nil nil))
;	("X-ML-Name" . (("To" "Cc") nil nil))
;	("Followup-To" . (nil nil ("Followup-To")))
;	("Newsgroups" . (nil nil ("Newsgroups")))
;	("Reply-To" . (("Reply-To") nil nil))
;	("Mail-Reply-To" . (("Mail-Reply-To") nil nil))
;	(wl-draft-self-reply-p . (("To") ("Cc") nil))
;	("From" . (("From") nil nil))))

;; old defaults < 2.11.0
;(setq wl-draft-reply-without-argument-list
;      '(((wl-draft-self-reply-p
;	  "Followup-To") . (("To") ("Cc") ("Followup-To")))
;	((wl-draft-self-reply-p
;	  "Newsgroups") . (("To") ("Cc") ("Newsgroups")))
;	((wl-draft-self-reply-p
;	  "From") . (("To") ("Cc") nil))
;	("Followup-To" . (nil nil ("Followup-To")))
;	("Mail-Followup-To" . (("Mail-Followup-To") nil ("Newsgroups")))
;	("Reply-To" . (("Reply-To") ("To" "Cc" "From") ("Newsgroups")))
;	("From" . (("From") ("To" "Cc") ("Newsgroups")))))

;(setq wl-draft-reply-with-argument-list
;      '(((wl-draft-self-reply-p
;	  "Followup-To") . (("To") ("Cc") ("Followup-To")))
;	((wl-draft-self-reply-p
;	  "Newsgroups") . (("To") ("Cc") ("Newsgroups")))
;	((wl-draft-self-reply-p
;	  "From") . (("To") ("Cc") nil))
;	("Reply-To" . (("Reply-To") nil nil))
;	("Mail-Reply-To" . (("Mail-Reply-To") nil nil))
;	("From" . (("From") nil nil))))

;;; [[ Message Display Settings ]]

;; Hidden header field in message buffer.
(setq wl-message-ignored-field-list
      '(".*Received:" ".*Path:" ".*Id:" "^References:"
	"^Replied:" "^Errors-To:"
	"^Lines:" "^Sender:" ".*Host:" "^Xref:"
	"^Content-Type:" "^Precedence:"
	"^Status:" "^X-VM-.*:"))

;; Displayed header field in message buffer.
;; This value precedes `wl-message-ignored-field-list'
(setq wl-message-visible-field-list '("^Message-Id:"))

;; X-Face
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

;; Scoring.
;; "all.SCORE" file is used regardless of wl-score-folder-alist.
;(setq wl-score-folder-alist
;      '(("^-comp\\."
;	 "news.comp.SCORE"
;	 "news.SCORE")
;	("^-"
;	 "news.SCORE")))

;; rule for auto refile.
;(setq wl-refile-rule-alist
;      '(
;	("x-ml-name"
;	 ("^Wanderlust" . "+wl")
;	 ("^Elisp" . "+elisp"))
;	("From"
;	 ("foo@example\\.com" . "+foo"))))

;; Marks to skip auto-refile (default is "N" "U" "!").
;; nil means all message is auto-refiled.
;(setq wl-summary-auto-refile-skip-marks nil)

;;; [[ Spam Filter Settings ]]

;; Use bogofilter as a back end.
;(setq elmo-spam-scheme 'bogofilter)

;(require 'wl-spam)

;; In moving to summary, judge whether a message is a spam.
;(setq wl-spam-auto-check-folder-regexp-list '("\\+inbox"))

;; Judge *first* whether a message is a spam
;; when `o' (wl-summary-refile) is performed in a summary buffer.
;(unless (memq 'wl-refile-guess-by-spam wl-refile-guess-functions)
;  (setq wl-refile-guess-functions
;	(cons #'wl-refile-guess-by-spam
;	      wl-refile-guess-functions)))

;; Judge *first* whether a message is a spam
;; when `C-o' (wl-summary-auto-refile) is performed in a summary buffer.
;(unless (memq 'wl-refile-guess-by-spam wl-auto-refile-guess-functions)
;  (setq wl-auto-refile-guess-functions
;	(cons #'wl-refile-guess-by-spam
;	      wl-auto-refile-guess-functions)))

;; When you want to give priority to refile-rule (same as spamfilter-wl.el
;; or bogofilter-wl.el), please confirm the setup here.
;(unless (memq 'wl-refile-guess-by-spam wl-auto-refile-guess-functions)
;  (setq wl-auto-refile-guess-functions
;	(append wl-auto-refile-guess-functions
;		'(wl-refile-guess-by-spam))))

;;; dot.wl ends here
