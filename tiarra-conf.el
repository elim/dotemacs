;; -*- emacs-lisp -*-
;; ----------------------------------------------------------------------------
;; $Id: tiarra-conf.el,v 1.2 2003/05/21 04:17:25 admin Exp $
;; ----------------------------------------------------------------------------
;; tiarra.conf編集用モード。
;; ----------------------------------------------------------------------------

;; キーマップ
(defvar tiarra-conf-mode-map nil
  "Keymap for tiarra conf mode.")

;; 構文定義
(defvar tiarra-conf-mode-syntax-table nil
  "Syntax table used while in tiarra conf mode.")
(if tiarra-conf-mode-syntax-table
    ()   ; 構文テーブルが既存ならば変更しない
  (setq tiarra-conf-mode-syntax-table (make-syntax-table))
  (modify-syntax-entry ?{ "(}")
  (modify-syntax-entry ?} "){"))

;; 略語定義
(defvar tiarra-conf-mode-abbrev-table nil
  "Abbrev table used while in tiarra conf mode.")
(define-abbrev-table 'tiarra-conf-mode-abbrev-table ())

;; フック
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

  ; フォントロックの設定
  (make-local-variable 'font-lock-defaults)
  (setq tiarra-conf-font-lock-keywords
	(list '("^[\t ]*#.*$"
		. font-lock-comment-face) ; コメント
	      '("^[\t ]*@.*$"
		. font-lock-warning-face) ; @文
	      '("^[\t ]*\\+[\t ]+.+$"
		. font-lock-type-face) ; + モジュール
	      '("^[\t ]*-[\t ]+.+$"
		. font-lock-constant-face) ; - モジュール 
	      '("^[\t ]*\\([^:\n]+\\)\\(:\\).*$"
		(1 font-lock-variable-name-face) ; key
		(2 font-lock-string-face)) ; ':'
	      '("^[\t ]*[^{}\n]+"
		. font-lock-function-name-face))) ; ブロック名
  (setq font-lock-defaults '(tiarra-conf-font-lock-keywords t))
  
  (run-hooks 'tiarra-conf-mode-hook))