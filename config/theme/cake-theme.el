(deftheme cake "Yummy syntax theme. Transplanted from DanielPintilei/Cake")

(set-cursor-color "#fe728b")
(setq-default cursor-type '(bar . 3))

(custom-theme-set-faces
 'cake
 '(cursor    ((t (:background "#fe728b"))))
 '(default   ((t (:background "#2e231b" :foreground "#efeef1"))))
 '(region    ((t (:background "#4e3e2b"))))

 '(highlight ((t (:background "#362a20"))))
 '(hl-line   ((t (:inherit highlight :background "#362a20"))))

 '(font-lock-builtin-face       ((t (:foreground "#d99f81"))))
 '(font-lock-comment-face       ((t (:foreground "#796b68"))))
 '(font-lock-constant-face      ((t (:foreground "#d99f81"))))
 '(font-lock-function-name-face ((t (:foreground "#d99f81"))))
 '(font-lock-keyword-face       ((t (:foreground "#c092ce"))))
 '(font-lock-string-face        ((t (:foreground "#efeef1"))))
 '(font-lock-type-face          ((t (:foreground "#ea88b9"))))
 '(font-lock-variable-name-face ((t (:foreground "#ea88b9"))))

 '(mode-line           ((t (:foreground "#ada8a4" :background "#1e1d1b" :box (:line-width 1 :color "#1e1d1b" :style released-button)))))
 '(mode-line-inactive  ((t (:foreground "#ada8a4" :background "#1e1d1b" :box (:line-width 1 :color "#1e1d1b")))))
 '(mode-line-buffer-id ((t (:foreground nil       :background nil))))

 '(show-paren-match-face ((t (:foreground "#efeef1" :background "#ea88b9"))))
 '(paren-face            ((t (:foreground "#efeef1" :background nil))))

 '(js2-external-variable ((t (:foreground "#f04841"))))
 '(js2-function-call     ((t (:foreground "#d99f81"))))
 '(js2-function-param    ((t (:foreground "#efeef1"))))

 '(markdown-url-face    ((t (:foreground "#c092ce" :underline t))))

 '(web-mode-comment-face           ((t (:foreground "#796b68"))))
 '(web-mode-comment-face           ((t (:foreground "#796b68"))))
 '(web-mode-css-at-rule-face       ((t (:foreground "#c092ce"))))
 '(web-mode-css-property-name-face ((t (:foreground "#d99f81"))))
 '(web-mode-css-pseudo-class-face  ((t (:foreground "#fe728b"))))
 '(web-mode-css-selector-face      ((t (:foreground "#fe728b"))))
 '(web-mode-doctype-face           ((t (:foreground "#efeef1"))))
 '(web-mode-html-attr-equal-face   ((t (:foreground "#efeef1"))))
 '(web-mode-html-attr-name-face    ((t (:foreground "#ea88b9"))))
 '(web-mode-html-attr-value-face   ((t (:foreground "#a56e5f"))))
 '(web-mode-html-tag-face          ((t (:foreground "#fe728b"))))
 '(web-mode-server-comment-face    ((t (:foreground "#796b68"))))
 '(web-mode-css-string-face        ((t (:foreground "#d99f81")))))

(provide-theme 'cake)
