;-*- emcs-lisp -*-
; $Id$

;; @@ ���ܤ�����

;; Mule 2.3 (Emacs 19) ��ȤäƤ������ɬ��
;; (require 'skk-setup)

;; ��������/�Ҥ餬�� ������ SKK ��ư����
;(global-set-key [hiragana-katakana] 'skk-mode)

;; ~/.skk �ˤ��äѤ������񤤤Ƥ���ΤǥХ��ȥ���ѥ��뤷����
;(setq skk-byte-compile-init-file t)
;; ��) �ۤʤ����� Emacsen ��ȤäƤ������ nil �ˤ��ޤ�

;; SKK �� Emacs �� input method �Ȥ��ƻ��Ѥ���
(setq default-input-method "japanese-skk")

;; SKK ��ư���Ƥ��ʤ��Ƥ⡢���ĤǤ� skk-isearch ��Ȥ�
(add-hook 'isearch-mode-hook 'skk-isearch-mode-setup)
(add-hook 'isearch-mode-end-hook 'skk-isearch-mode-cleanup)

;; @@ ����Ū������

;; ~/.skk* �ʥե����뤬�������󤢤�Τ�����������
;(if (not (file-directory-p "~/.ddskk"))
;    (make-directory "~/.ddskk"))
;(setq skk-init-file "~/.ddskk/init.el"
;      skk-custom-file "~/.ddskk/custom.el"
;      skk-emacs-id-file "~/.ddskk/emacs-id"
;      skk-record-file "~/.ddskk/record"
;      skk-jisyo "~/.ddskk/jisyo"
;      skk-backup-jisyo "~/.ddskk/jisyo.bak")
;; ��) SKK �θĿͼ���� skkinput �ʤɤΥץ����Ǥ⻲�Ȥ��ޤ����顢
;;     �嵭������򤷤����Ϥ����Υץ���������ե�������
;;     ������ɬ�פ�����ޤ���

;; migemo ��Ȥ����� skk-isearch �ˤϤ��Ȥʤ������Ƥ����ߤ���
;; (setq skk-isearch-start-mode 'latin)

;; super-smart-find �Τ�������� (��̣���뤫�ʡ�)
(setq super-smart-find-self-insert-command-list
      '(canna-self-insert-command
	egg-self-insert-command
	self-insert-command
	tcode-self-insert-command-maybe
	skk-insert))

;; YaTeX �ΤȤ��������������ѹ�������
(add-hook 'yatex-mode-hook
	  (lambda ()
	    (require 'skk)
	    (setq skk-kutouten-type 'en)))


;(global-set-key "\C-xj" 'skk-auto-fill-mode)
(global-set-key "\C-xj" nil)
;(global-set-key "\C-xt" 'skk-tutorial)
(global-set-key "\C-xt" nil)
