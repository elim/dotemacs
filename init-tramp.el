;; -*- emcas-lisp -*-
;; http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=175346
;; http://yoichi.geiin.org/d/?date=20030328#p01

(setq auto-save-file-name-transforms
      `(("\\`/[^/]*:\\(.+/\\)*\\(.*\\)"
	  ,(expand-file-name "\\2" temporary-file-directory))))
