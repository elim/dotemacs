;-*- emcs-lisp -*-
; $Id$

(setq default-frame-alist
      (append
       '((foreground-color . "gray")  ; 前景色
	 (background-color . "black") ; 背景色
	 (cursor-color     . "blue")  ; カーソル色
	 (width            . 114)     ; フレーム幅(文字数)
	 (height           . 44)      ; フレーム高(文字数)
	 (top              . 50)      ; フレームの Y 位置(ピクセル数)
	 (left             . 10)      ; フレームの X 位置(ピクセル数)
	 )
 default-frame-alist))
