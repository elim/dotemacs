;-*- emacs-lisp -*-
; $Id$

(autoload 'skk "skk" nil t)
(autoload 'skk-setup "skk-setup" nil t)
(autoload 'skk-mode "skk" nil t)
(autoload 'skk-auto-fill-mode "skk" nil t)
(autoload 'skk-tutorial "skk-tut" nil t)
(autoload 'skk-check-jisyo "skk-tools" nil t)
(autoload 'skk-merge "skk-tools" nil t)
(autoload 'skk-diff "skk-tools" nil t)
(autoload 'skk-isearch-mode-setup "skk-isearch" nil t)
(autoload 'skk-isearch-mode-cleanup "skk-isearch" nil t)

(setq skk-indicator-use-cursor-color nil)

(if (featurep 'meadow)
    (setq skk-init-file (expand-file-name "~/dot.files/.skk")) nil)


(global-set-key "\C-x\C-j" 'skk-mode)
;(global-set-key "\C-xj" 'skk-auto-fill-mode)
(global-set-key "\C-xj" nil)
;(global-set-key "\C-xt" 'skk-tutorial)
(global-set-key "\C-xt" nil)


;; @@ 基本の設定

(setq skk-count-private-jisyo-candidates-exactly t)
(setq skk-server-jisyo "/usr/local/share/skk/SKK-JISYO.L")
(setq skk-server-prog "/cygwin/usr/local/sbin/skkserv.rb")
(setq skk-share-private-jisyo t)

;; Mule 2.3 (Emacs 19) を使っている場合は必要
;; (require 'skk-setup)

;; カタカナ/ひらがな キーで SKK を起動する
;(global-set-key [hiragana-katakana] 'skk-mode)

;; ~/.skk にいっぱい設定を書いているのでバイトコンパイルしたい
;(setq skk-byte-compile-init-file t)
;; 注) 異なる種類の Emacsen を使っている場合は nil にします

;; SKK を Emacs の input method として使用する
(setq default-input-method "japanese-skk")

;; SKK を起動していなくても、いつでも skk-isearch を使う
(add-hook 'isearch-mode-hook 'skk-isearch-mode-setup)
(add-hook 'isearch-mode-end-hook 'skk-isearch-mode-cleanup)

;; @@ 応用的な設定

;; ~/.skk* なファイルがたくさんあるので整理したい
;(if (not (file-directory-p "~/.ddskk"))
;    (make-directory "~/.ddskk"))
;(setq skk-init-file "~/.ddskk/init.el"
;      skk-custom-file "~/.ddskk/custom.el"
;      skk-emacs-id-file "~/.ddskk/emacs-id"
;      skk-record-file "~/.ddskk/record"
;      skk-jisyo "~/.ddskk/jisyo"
;      skk-backup-jisyo "~/.ddskk/jisyo.bak")
;; 注) SKK の個人辞書は skkinput などのプログラムでも参照しますから、
;;     上記の設定をした場合はそれらのプログラムの設定ファイルも書き
;;     かえる必要があります。

;; migemo を使うから skk-isearch にはおとなしくしていて欲しい
;; (setq skk-isearch-start-mode 'latin)

;; super-smart-find のための設定 (意味あるかな？)
(setq super-smart-find-self-insert-command-list
      '(canna-self-insert-command
	egg-self-insert-command
	self-insert-command
	tcode-self-insert-command-maybe
	skk-insert))

;; YaTeX のときだけ句読点を変更したい
(add-hook 'yatex-mode-hook
	  (lambda ()
	    (require 'skk)
	    (setq skk-kutouten-type 'en)))

