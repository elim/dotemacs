;-*- emacs-lisp -*-
;$Id$
(eval-safe
 (require 'auto-save-buffers)
 (run-with-idle-timer 2 t 'auto-save-buffers)) ; アイドル 2 秒で保存