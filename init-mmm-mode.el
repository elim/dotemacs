(require 'mmm-mode)
;;(require 'mmm-auto)
;;(setq mmm-global-mode t)
(setq mmm-global-mode 'maybe)

;; mmm-mode�򥫥�ե��
(setq mmm-submode-decoration-level 2)

;; mmm-mode�����ʿ����طʿ������촹���롣
;(invert-face 'mmm-default-submode-face)
;; mmm-mode�Υե��������ѹ�
;(set-face-bold-p 'mmm-default-submode-face t)
(set-face-background 'mmm-default-submode-face "White")
;; �طʤ�̵������
;(set-face-background 'mmm-default-submode-face nil)

;; eRuby
(mmm-add-mode-ext-class nil "\\.erb?\\'" 'html-erb)
(mmm-add-classes
 '((html-erb
 :submode ruby-mode
     :match-face (("<%#" . mmm-comment-submode-face)
     		 ("<%=" . mmm-output-submode-face)
		 		 ("<%" . mmm-code-submode-face))
         :front "<%[#=]?"
	    :back "%>")))
(add-to-list 'auto-mode-alist '("\\.erb?\\'" . html-mode))
