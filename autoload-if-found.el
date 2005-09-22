; -*- emacs-lisp -*-
; $Id: init-w3m.el 126 2005-09-01 11:03:02Z takeru $
; http://www.sodan.org/~knagano/emacs/dotemacs.html

(defun autoload-if-found (function file &optional docstring interactive type)
  "set autoload iff. FILE has found."
  (and (locate-library file)
       (autoload function file docstring interactive type)))
;; �Ȥ���
;; ������ autoload ������Ʊ���Ǥ���-if-found ���դ������
(when (autoload-if-found 'bs-show "bs" "buffer selection" t)
  ;; autoload �������������Τ� non-nil ���֤��Τǡ�
  ;; when �ξ�������֤����Ȥǡ���¸�ط��ˤ���������ܤ�����ɽ���Ǥ��ޤ���
  (global-set-key [(control x) (control b)] 'bs-show)
  (setq bs-max-window-height 10))