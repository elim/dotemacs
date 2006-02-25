;; dot.wl -- sample setting file for Wanderlust	-*- emacs-lisp -*-
;; $Id$
;; [[ 動作に必要な設定 ]]

;; まず、次の設定を ~/.emacs などに書いてください。
;; XEmacs の package としてインストールされている場合は必要ありません。
;(autoload 'wl "wl" "Wanderlust" t)
;(autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
;(autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

;; アイコンを置くディレクトリ
;; XEmacs の package としてインストールされている場合は必要ありません。
;(setq wl-icon-directory "/usr/local/lib/emacs/etc")


;; [[ SEMI の設定 ]]

;; HTML パートを表示するか
;; mime-setup がロードされる前に記述する必要があります。
(setq mime-setup-enable-inline-html nil)

;; 大きいメッセージを送信時に分割するか
(setq mime-edit-split-message nil)

;; 大きいメッセージとみなす行数の設定
;(setq mime-edit-message-default-max-lines 1000)

;;; [[ 個人情報の設定 ]]

;; From: の設定
(setq wl-from "Takeru Naito <fascinating_logic@ybb.ne.jp>")

;; 自分のメールアドレスのリスト
(setq wl-user-mail-address-list
      (list (wl-address-header-extract-address wl-from)
	    "fascinating_logic@ybb.ne.jp"
	    "a.k.a.elim@gmail.com"
	    "takeru@at-mac.com"
	    "elim@TerokNor.org"
	    "picard@mx12.freecom.ne.jp"))

;; 自分の参加しているメーリングリストのリスト
(setq wl-subscribed-mailing-list
      '("debian-users@debian.or.jp"
	"ruby-list@ruby-lang.org"
	"wl@lists.airs.net"
	"apel-ja@m17n.or"
	"emacs-mime-ja@m17n.org"
	"DeepSpace@panda.starfleet.ac"
	"alib@alib.jp"
	"share@alib.jp"))

;; (system-name) が FQDN を返さない場合、
;; `wl-local-domain' にホスト名を除いたドメイン名を設定してください。
;; (system-name)  "." wl-local-domain が Message-ID に使用されます。
;(setq system-name "elim.teroknor.org")

(cond
 ((not (string-match "fascinating.local$" system-name))
  (setq wl-local-domain "elim.teroknor.org")))

;; Message-ID のドメインパートを強制的に指定
(setq wl-message-id-domain "elim.teroknor.org")

;; Message-ID のドメインパートを wl-from から生成します。
;; globalなIPを持たない場合に使ってください。
;; wl-local-domain, wl-message-id-domainに優先します。
(setq wl-message-id-use-wl-from nil)

;; Message-ID を自動付与しない
;; (setq wl-insert-message-id nil)

;;; [[ サーバの設定 ]]
(setq my-wl-server-name
 (cond
  ((string-match "fascinating.local$" system-name)
   "idea")
  (t
   "localhost")))

;; IMAP サーバの設定
(setq elmo-imap4-default-server my-wl-server-name)
;; POP サーバの設定
(setq elmo-pop3-default-server my-wl-server-name)
;; SMTP サーバの設定
(setq wl-smtp-posting-server my-wl-server-name)
(setq wl-smtp-posting-user "takeru")
(setq wl-smtp-authenticate-type "cram-md5")
;; ニュースサーバの設定
(setq elmo-nntp-default-server "news.media.kyoto-u.ac.jp")
;; 投稿先のニュースサーバ
(setq wl-nntp-posting-server elmo-nntp-default-server)
;; ニュースサーバのユーザ名
(setq elmo-nntp-default-user "fascinating_logic@ybb.ne.jp")

;; IMAP サーバの認証方式の設定
;(setq elmo-imap4-default-authenticate-type 'clear) ; 生パスワード
(setq elmo-imap4-default-authenticate-type 'cram-md5) ; CRAM-MD5

;; POP-before-SMTP
;(setq wl-draft-send-mail-function 'wl-draft-send-mail-with-pop-before-smtp)

;; IMAP サーバのポート
;; IMAP サーバとの通信方式
(cond
 ((string-match "fascinating.local$" system-name)
  (setq elmo-imap4-default-port 993)
  (setq elmo-imap4-default-stream-type 'ssl))
  (t
   (setq elmo-imap4-default-port 10143)))

;;; [[ 基本的な設定 ]]

;; `wl-summary-goto-folder' の時に選択するデフォルトのフォルダ
(setq wl-default-folder "%INBOX")

;; フォルダ名補完時に使用するデフォルトのスペック
(setq wl-default-spec "%")

;; Folder Carbon Copy
(setq wl-fcc "%Sent")

;; draft folder
(setq wl-draft-folder "%Drafts")

;; trash folder
(setq wl-trash-folder "%Trash")

;; 終了時に確認する
(setq wl-interactive-exit t)

;; メール送信時には確認する
(setq wl-interactive-send t)

;; スレッドは常に開く
;(setq wl-thread-insert-opened t)

;; サマリバッファの左にフォルダバッファを表示する (3ペイン表示)
;(setq wl-stay-folder-window t)

;; 長い行を切り縮める
;(setq wl-message-truncate-lines t)
;(setq wl-draft-truncate-lines t)
;; XEmacs (21.4.6 より前) の場合、以下も必要。
;(setq truncate-partial-width-windows nil)

;; ドラフトを新しいフレームで書く
;(setq wl-draft-use-frame t)

;; スレッド表示のインデントを無制限にする。
(setq wl-summary-indent-length-limit nil)
(setq wl-summary-width nil)

;; サブジェクトが変わったらスレッドを切って表示
;(setq wl-summary-divide-thread-when-subject-changed t)

;; スレッドの見た目を変える
;(setq wl-thread-indent-level 2)
;(setq wl-thread-have-younger-brother-str "+"
;      wl-thread-youngest-child-str	 "+"
;      wl-thread-vertical-str		 "|"
;      wl-thread-horizontal-str		 "-"
;      wl-thread-space-str		 " ")

;; サマリ移動後に先頭メッセージを表示する
;(setq wl-auto-select-first t)

;; サマリ内の移動で未読メッセージがないと次のフォルダに移動する
;(setq wl-auto-select-next t)

;; 未読がないフォルダは飛ばす(SPCキーだけで読み進める場合は便利)
(setq wl-auto-select-next 'skip-no-unread)

;; 未読メッセージを優先的に読む
(setq wl-summary-move-order 'unread)

;; 着信通知の設定
(setq wl-biff-check-folder-list '("%INBOX"))
(setq wl-biff-notify-hook '(ding))


;;; [[ ネットワーク ]]

;; フォルダ種別ごとのキャッシュの設定
;; (localdir, localnews, maildir はキャッシュできない)
;(setq elmo-archive-use-cache nil)
;(setq elmo-nntp-use-cache t)
;(setq elmo-imap4-use-cache t)
;(setq elmo-pop3-use-cache t)

;; オフライン(unplugged)操作を有効にする(現在はIMAPフォルダのみ)
(setq elmo-enable-disconnected-operation t)

;; unplugged 状態で送信すると，キュー(`wl-queue-folder')に格納する
(setq wl-draft-enable-queuing t)
;; unplugged から plugged に変えたときに，キューにあるメッセージを送信する
(setq wl-auto-flush-queue t)

;; 起動時はオフライン状態にする
;(setq wl-plugged nil)
;; 起動時にポートごとのplug状態を変更する
;(add-hook 'wl-make-plugged-hook
;	  '(lambda ()
;	     ;; server,portのplug状態を新規追加もしくは変更する
;	     (elmo-set-plugged plugged値(t/nil) server port)
;	     ;; port を省略するとserverの全portが変更される
;	     ;; (port を省略して新規の追加はできない)
;	     (elmo-set-plugged plugged値(t/nil) server)
;	     ))


;;; [[ 特殊な設定 ]]

;; サマリでの "b" をメッセージ再送にする (mutt の "b"ounce)
;(add-hook 'wl-summary-mode-hook
;	  '(lambda ()
;	     (define-key wl-summary-mode-map "b" 'wl-summary-resend-message)))

;; グループをcheckした後に未読があるフォルダのグループを自動的に開く
;(add-hook 'wl-folder-check-entity-hook
;	  '(lambda ()
;	     (wl-folder-open-unread-folder entity)
;	     ))

;; サマリ表示関数を変更する

;; `elmo-msgdb-overview-entity-get-extra-field' で参照したいフィールド。
;; 自動リファイルで参照したいフィールドも設定する。
(setq elmo-msgdb-extra-fields
      '("reply-to"))

;; ML のメッセージであれば，サマリの Subject 表示に
;; ML名 や MLにおけるメッセージ番号も表示する
(setq wl-summary-line-format "%n%T%P%M/%D(%W)%h:%m %t%[%17(%c %f%) %] %#%~%s")
;; フォルダ毎にサマリの表示形式を変える設定
;(setq wl-folder-summary-line-format-alist
;      '(("^%inbox\\.emacs\\.wl$" .
;	 "%-5l%T%P%M/%D %h:%m %-4S %[ %17f %] %t%C%s")
;	("^%" . "%T%P%M/%D %h:%m %-4S %[ %17f %] %t%C%s")
;	("^+" . "%n%T%P%M/%D %h:%m %-4S %[ %17f %] %t%C%s")))

;; imput により非同期で送信する
;; (utils/im-wl.el をインストールしておく必要があります。
;;  また，~/.im/Config の設定(Smtpservers)を忘れないことと，
;;  wl-draft-enable-queuing の機能が働かなくなることに注意。)
;(autoload 'wl-draft-send-with-imput-async "im-wl")
;(setq wl-draft-send-function 'wl-draft-send-with-imput-async)


;; 短い User-Agent: フィールドを使う
;(setq wl-generate-mailer-string-function
;      'wl-generate-user-agent-string-1)



;; メールDBにcontent-typeを加える
(setq elmo-msgdb-extra-fields
    (cons "content-type" elmo-msgdb-extra-fields))
;; 添付ファイルがある場合は「@」を表示
(setq wl-summary-line-format "%n%T%P%1@%M/%D(%W)%h:%m %t%[%17(%c %f%) %] %#%~%s")
(setq wl-summary-line-format-spec-alist
      (append wl-summary-line-format-spec-alist
	      '((?@ (wl-summary-line-attached)))))

;; 変更されたドラフトがあれば 20 秒ごとに自動保存する。
;; (defun my-wl-auto-save-draft-buffers ()
;;   (let ((buffers (wl-collect-draft)))
;;     (save-excursion
;;       (while buffers
;; 	(set-buffer (car buffers))
;; 	(if (buffer-modified-p) (wl-draft-save))
;; 	(setq buffers (cdr buffers))))))
;; (run-with-idle-timer 20 t 'my-wl-auto-save-draft-buffers)


;;; [[ テンプレート ]]

;; テンプレートの設定
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

;; ドラフトバッファの内容により From や Organization などのヘッダを自
;; 動的に変更する
(setq wl-draft-config-alist
      '(("^From.*TerokNor"
;        ドラフト<バッファのヘッダにマッチすれば適用する
;	 (top-file . "自動挿入の試験です。＼n")	; 本文先頭への挿入
;	 (setq wl-message-id-domain "mail.TerokNor.org")
;	 (setq wl-draft-send-mail-function 'wl-draft-send-mail-with-pop-before-smtp)
;	 (wl-smtp-posting-server . "mail.TerokNor.org")
;	 (wl-pop-before-smtp-server . "mail.TerokNor.org")
	)))
;; Daredevil SKK の version をヘッダに入れる
(when (locate-library "skk-version")
  (add-to-list 'wl-draft-config-alist
	       `(t ("X-Input-Method" . ,(skk-version)))))

;; ドラフト作成時(返信時)に，自動的にヘッダを変更する
(add-hook 'wl-mail-setup-hook
	  '(lambda ()
	     (unless wl-draft-reedit	; 再編集時は適用しない
	       (wl-draft-config-exec wl-draft-config-alist))))


;;; [[ 返信時の設定 ]]

;; 返信時のウィンドウを広くする
;(setq wl-draft-reply-buffer-style 'full)

;; 返信時のヘッダに相手の名前を入れない。
(setq wl-draft-reply-use-address-with-full-name nil)

;; メールの返信時に宛先を付ける方針の設定
;; 下記変数の alist の要素
;; ("返信元に存在するフィールド" .
;;   ('Toフィールド' 'Ccフィールド' 'Newsgroupsフィールド'))

;; "a" (without-argument)では Reply-To: や From: などで指定された唯一人
;; または唯一つの投稿先に返信する。また，X-ML-Name: と Reply-To: がつい
;; ているなら Reply-To: 宛にする。
;(setq wl-draft-reply-without-argument-list
;      '((("X-ML-Name" "Reply-To") . (("Reply-To") nil nil))
;	("X-ML-Name" . (("To" "Cc") nil nil))
;	("Followup-To" . (nil nil ("Followup-To")))
;	("Newsgroups" . (nil nil ("Newsgroups")))
;	("Reply-To" . (("Reply-To") nil nil))
;	("Mail-Reply-To" . (("Mail-Reply-To") nil nil))
;	("From" . (("From") nil nil))))

;; "C-u a" (with-argument)であれば関係する全ての人・投稿先に返信する。
;(setq wl-draft-reply-with-argument-list
;      '(("Followup-To" . (("From") nil ("Followup-To")))
;	("Newsgroups" . (("From") nil ("Newsgroups")))
;	("Mail-Followup-To" . (("Mail-Followup-To") nil ("Newsgroups")))
;	("From" . (("From") ("To" "Cc") ("Newsgroups")))))


;;; [[ メッセージ表示の設定 ]]

;; 隠したいヘッダの設定
(setq wl-message-ignored-field-list
      '(".*Received:" ".*Path:" ".*Id:" "^References:"
	"^Replied:" "^Errors-To:"
	"^Lines:" "^Sender:" ".*Host:" "^Xref:"
	"^Content-Type:" "^Precedence:"
	"^Status:" "^X-VM-.*:"))

;; 表示するヘッダの設定
;; 'wl-message-ignored-field-list' より優先される
(setq wl-message-visible-field-list '("^Message-Id:"))


;; X-Face を表示する
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

;; スコア機能の設定
;; `wl-score-folder-alist' の設定に関わらず必ず "all.SCORE" は使用される。
;(setq wl-score-folder-alist
;      '(("^-comp\\."
;	 "news.comp.SCORE"
;	 "news.SCORE")
;	("^-"
;	 "news.SCORE")))


;; 自動リファイルのルール設定
;; (setq wl-refile-rule-alist '(
;; 	("Subject"
;; 	 ("foo" . "+inbox/foo"))
;; 	("x-ml-name"
;; 	 ("^Elisp" . "+elisp"))
;; 	("From"
;; 	 ("bar" . "+inbox/bar"))))

;; 自動リファイルしない永続マークを設定
;; 標準では "N" "U" "!" になっており、未読メッセージを自動リファイルし
;; ません。nil ですべてのメッセージが対象になります。
;(setq wl-summary-auto-refile-skip-marks nil)


;;; dot.wl ends here