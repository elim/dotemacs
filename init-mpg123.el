;; -*- emas-lisp -*-
;; $Id$

(when (autoload-if-found 'mpg123 "mpg123" nil t)
  (setq mpg123-mpg123-command "mpg321") ; mpg123�Υ��ޥ��̾
  (setq mpg123-startup-volume 70)       ; ��ư���β���
  (setq mpg123-default-repeat -1)       ; �����֤������-1�ϱʱ�˷����֤���
  (setq mpg123-default-dir              ; ��ư���Υǥ��쥯�ȥ�
	(expand-file-name "/opt/share/iTunes/iTunes Music/")))