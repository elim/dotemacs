;; -*- emacs-lisp -*-
;; ----------------------------------------------------------------------------
;; $Id: tiarra-conf.el,v 1.2 2003/05/21 04:17:25 admin Exp $
;; ----------------------------------------------------------------------------
;; tiarra.conf�Խ��ѥ⡼�ɡ�
;; ----------------------------------------------------------------------------

;; �����ޥå�
(defvar tiarra-conf-mode-map nil
  "Keymap for tiarra conf mode.")

;; ��ʸ���
(defvar tiarra-conf-mode-syntax-table nil
  "Syntax table used while in tiarra conf mode.")
(if tiarra-conf-mode-syntax-table
    ()   ; ��ʸ�ơ��֥뤬��¸�ʤ���ѹ����ʤ�
  (setq tiarra-conf-mode-syntax-table (make-syntax-table))
  (modify-syntax-entry ?{ "(}")
  (modify-syntax-entry ?} "){"))

;; ά�����
(defvar tiarra-conf-mode-abbrev-table nil
  "Abbrev table used while in tiarra conf mode.")
(define-abbrev-table 'tiarra-conf-mode-abbrev-table ())

;; �եå�
(defvar tiarra-conf-mode-hook nil
  "Normal hook runs when entering tiarra-conf-mode.")

(defun tiarra-conf-mode ()
  "Major mode for editing tiarra conf file.
\\{tiarra-conf-mode-map}
Turning on tiarra-conf-mode runs the normal hook `tiarra-conf-mode-hook'."
  (interactive)
  (kill-all-local-variables)
  (use-local-map tiarra-conf-mode-map)
  (set-syntax-table tiarra-conf-mode-syntax-table)
  (setq local-abbrev-table tiarra-conf-mode-abbrev-table)
  (setq mode-name "Tiarra-Conf")
  (setq major-mode 'tiarra-conf-mode)

  ; �ե���ȥ�å�������
  (make-local-variable 'font-lock-defaults)
  (setq tiarra-conf-font-lock-keywords
	(list '("^[\t ]*#.*$"
		. font-lock-comment-face) ; ������
	      '("^[\t ]*@.*$"
		. font-lock-warning-face) ; @ʸ
	      '("^[\t ]*\\+[\t ]+.+$"
		. font-lock-type-face) ; + �⥸�塼��
	      '("^[\t ]*-[\t ]+.+$"
		. font-lock-constant-face) ; - �⥸�塼�� 
	      '("^[\t ]*\\([^:\n]+\\)\\(:\\).*$"
		(1 font-lock-variable-name-face) ; key
		(2 font-lock-string-face)) ; ':'
	      '("^[\t ]*[^{}\n]+"
		. font-lock-function-name-face))) ; �֥�å�̾
  (setq font-lock-defaults '(tiarra-conf-font-lock-keywords t))
  
  (run-hooks 'tiarra-conf-mode-hook))