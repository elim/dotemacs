;;; dot.skk --- init file for SKK
;;;  -*- emacs-lisp -*-

;;; Commentary:

;; �ʲ��� ~/.skk ��������Ǥ���

;;; Code:

;; @@ ������δ��ܤ�����

;; SKK ���������뼭�� (�����Ф�Ȥ�ʤ��Ȥ�)
;; (setq skk-large-jisyo "/usr/share/skk/SKK-JISYO.L")

;; �����Ф�Ȥ����������
(setq skk-server-host "localhost")
(setq skk-server-portnum 1178)

;; @@ ɽ��������

;; ��å����������ܸ�����Τ���
(setq skk-japanese-message-and-error t)

;; �Ѵ�������� (annotation) ��ɽ������
(setq skk-show-annotation t)

;; ��������˿����դ��ʤ�
;; (setq skk-use-color-cursor nil)

;; (when skk-use-color-cursor
;;   ;; �������뿧���Ѥ��Ƥߤ�
;;   (setq skk-cursor-hiragana-color "blue"
;;	   skk-cursor-katakana-color "green"
;;	   skk-cursor-abbrev-color "red"
;;	   skk-cursor-jisx0208-latin-color "red"
;;	   skk-cursor-jisx0201-color "purple"))

;; ���󥸥������˿����դ��ʤ�
;; (setq skk-indicator-use-cursor-color nil)

;; �Ѵ����ʸ�����ϥ��饤�Ȥ��ʤ�
;; (setq skk-use-face nil)

;; (when skk-use-face
;;   ;; �Ѵ�ʸ����ο����Ѥ��Ƥߤ�
;;   (skk-make-face 'DimGray/PeachPuff1)
;;   (setq skk-henkan-face 'DimGray/PeachPuff1))

;; @@ ����Ū�ʥ桼�������󥿡��ե�����

;; Enter �����򲡤����Ȥ��ˤϳ��ꤹ��
;(setq skk-egg-like-newline t)

;; ���⡼�ɤ� BS �򲡤����Ȥ��ˤϳ��ꤷ�ʤ����������ɽ������
;(setq skk-delete-implies-kakutei nil)

;; �б������ĳ�̤�ưŪ����������
;;(setq skk-auto-insert-paren t)

;; ���⡼�ɤȢ��⡼�ɻ��Υ���ɥ������Ͽ���ʤ�
;; (setq skk-undo-kakutei-word-only t)

;; �������� , . ��Ȥ�
(setq skk-kuten-touten-alist '(
    (jp . ("��" . "��" ))
    (en . (". " . ", "))))
;; jp �ˤ���ȡ֡����פ�Ȥ��ޤ�
(setq-default skk-kutouten-type 'en)

;; ưŪ���䴰��Ȥ�
;; (setq skk-dcomp-activate t)

;; viper ���Ȥ߹�碌�ƻȤ�
;; (setq skk-use-viper t)

;; ����ˤ� C-j �Ǥʤ����Ѵ�������Ȥ�
;; (setq skk-kakutei-key [henkan])
;; ��) �Ѵ������ϡ�Emacs on XFree86  �Ǥ� [henkan]
;;                 XEmacs on XFree86 �Ǥ� [henkan-mode]
;;                 Meadow            �Ǥ� [convert]

;; ��Ƭ���������Ѵ��Υ��������ꤹ��
;; �� 1) ɸ�������
;; (setq skk-special-midashi-char-list '(?> ?< ??))
;; �� 2) ? �����̤����Ϥ��������鳰��
;; (setq skk-special-midashi-char-list '(?> ?<))
;; �� 3) ʸ�����������̤����Ϥ���������¾�Υ�����Ȥ�
;; (setq skk-special-midashi-char-list nil)
;; (define-key skk-j-mode-map [muhenkan] 'skk-process-prefix-or-suffix)

;; @@ �Ѵ�ư���Ĵ��

;; ���겾̾����̩�������������ͥ�褷��ɽ������
 (setq skk-henkan-strict-okuri-precedence t)

;; ������Ͽ�ΤȤ���;�פ����겾̾������ʤ��褦�ˤ���
 (setq skk-check-okurigana-on-touroku 'auto)

;; @@ �����˴�Ϣ��������

;; look ���ޥ�ɤ�Ȥä������򤹤�
;; (setq skk-use-look t)

;; (when skk-use-look
;;   ;; look �����Ĥ�����򸫽Ф���Ȥ��Ƹ�������
;;   (setq skk-look-recursive-search t)
;;   ;; ispell �� look �Ȱ��˻Ȥ��ΤϤ���
;;   (setq skk-look-use-ispell nil)
;;   ;; `skk-abbrev-mode' �� skk-look ��Ȥä������򤷤��Ȥ��˳�������
;;   ;; �Ŀͼ���˵�Ͽ���ʤ��褦�ˤ���
;;   (setq skk-search-excluding-word-pattern-function
;;	   ;; KAKUTEI-WORD ������ˤ��ƥ����뤵���Τǡ����פǤ��������
;;	   ;; ɬ�פ���
;;	   (lambda (kakutei-word)
;;	     (and skk-abbrev-mode
;;		  (save-match-data
;;		    ;; `skk-henkan-key' �� "*" �ǽ����Ȥ�
;;		    (string-match "\\*$" skk-henkan-key))))))

;; lookup �����Ѥ����Ѵ���Ԥ�
;; (setq skk-search-prog-list
;;       (skk-nunion skk-search-prog-list
;;		     '((skk-lookup-search))))

;; ���ꤢ���Ѵ�������ʤ��Ѵ���Ʊ�����ǤǤ���褦�ˤ���
;; (setq skk-auto-okuri-process t)

;; �������ʸ���Ѵ�����˲ä���
;;(setq skk-search-prog-list
;;      (skk-nunion skk-search-prog-list
;;		  '((skk-search-katakana))))

;; �����ѳʳ��Ѥ�ư������ꤢ���Ѵ������褦�ˤ���
(setq skk-search-prog-list
      (skk-nunion skk-search-prog-list
		   '((skk-search-sagyo-henkaku))))

;; @@ �������ϴ�Ϣ������

;; Ⱦ�ѥ������ϥ᥽�åɤ�Ȥ�
;; (setq skk-use-jisx0201-input-method t)

;; �������󥭡��ܡ��ɤ����Ϥ���
;; (setq skk-use-kana-keyboard t)

;; (when skk-use-kana-keyboard
;;   ;; �� JIS �����Ȥ�
;;   ;; (setq skk-kanagaki-keyboard-type '106-jis)
;;   ;; �ƻإ��եȥ��ߥ�졼������Ȥ�
;;   (setq skk-kanagaki-keyboard-type 'omelet-jis)
;;   ;; OASYS ���θ��ࡦ��å�����Ȥ�
;;   (setq skk-nicola-use-koyubi-functions t))

;; @@ ����¾������

;; ʣ���� Emacsen ��ư���ƸĿͼ����ͭ����
(setq skk-share-private-jisyo t)

;;; dot.skk ends here
