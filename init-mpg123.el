;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

(when (autoload-if-found 'mpg123 "mpg123" nil t)
  (setq mpg123-mpg123-command "mpg321") ; mpg123のコマンド名
  (setq mpg123-startup-volume 70)       ; 起動時の音量
  (setq mpg123-default-repeat -1)       ; 繰り返し回数。-1は永遠に繰り返す。
  (setq mpg123-default-dir              ; 起動時のディレクトリ
	(expand-file-name "/opt/share/music/")))