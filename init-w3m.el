;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (and
       (executable-find "w3m")
       (require 'w3m-load nil t))

  (setq w3m-preference-directory
        (expand-file-name "w3m" user-emacs-directory)
        w3m-init-file
        (expand-file-name "init.el" w3m-preference-directory)
        w3m-use-cookies t)

  (mapc '(lambda (lib)
           (apply #'autoload-if-found lib))
        (list
         '(w3m "w3m" "*Interface for w3m on Emacs." t)
         '(w3m-filter "w3m-filter" "*w3m filter advertisements." t)
         '(w3m-find-file "w3m" "*w3m interface function for local file." t)
         '(w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
         '(w3m-search "w3m-search" "*Search QUERY using SEARCH-ENGINE." t)
         '(w3m-weather "w3m-weather" "*Display weather report." t)
         '(w3m-antenna "w3m-antenna" "*Report chenge of WEB sites." t)))

  (global-set-key "\C-cs" 'w3m-search)

  (eval-after-load 'w3m-search
    '(add-to-list
      'w3m-search-engine-alist
      `("google"
        ,(concat
          "http://www.google.com/search?"
          "hl=en&lr=lang_ja&q=%s&oe=utf-8&ie=utf-8&safe=off") utf-8)))

  (require 'w3m-wget nil t)

  (when (and
         (require 'mime-view nil t)
         (require 'mime-w3m nil t))
    (eval-after-load "mime-view"
      '(progn
         (ctree-set-calist-strictly
          'mime-preview-condition
          '((type . text)
            (subtype . html)
            (body . visible)
            (body-presentation-method . mime-w3m-preview-text/html)))
         (set-alist 'mime-view-type-subtype-score-alist
                    '(text . html) 3)))))



;; http://ko.meadowy.net/%7Eshirai/diary/20070223.html#p01
(setq w3m-use-filter t)
(setq w3m-filter-rules
      `(("\\`https?://\\(www.\\)?amazon\\.co\\.jp/.+" w3m-filter-amazon)))

(defun w3m-filter-amazon (url)
  (when (and url
             (or (string-match
                  "^\\(https?://\\(?:www\\.\\)?amazon\\.co\\.jp\\)/exec/obidos/ASIN/\\([0-9]+\\)"
                  url)
                 (string-match
                  "^\\(https?://\\(?:www\\.\\)?amazon\\.co\\.jp\\)/o/ASIN/\\([0-9]+\\)"
                  url)
                 (string-match
                  "^\\(https?://\\(?:www\\.\\)?amazon\\.co\\.jp\\)/gp/product/\\([0-9]+\\)"
                  url)
                 (string-match
                  "^\\(https?://\\(?:www\\.\\)?amazon\\.co\\.jp\\)/\\(?:[^/]+/\\)?dp/\\([0-9]+\\)"
                  url)))
    (let* ((base (match-string 1 url))
           (asin (match-string 2 url))
           (shorturls `(,(concat base "/dp/" asin "/")
                        ,(concat base "/o/ASIN/" asin "/")
                        ,(concat base "/gp/product/" asin "/")))
           (case-fold-search t)
           shorturl)
      (goto-char (point-min))
      (setq url (file-name-as-directory url))
      (when (search-forward "<body>" nil t)
        (insert "\n")
        (while (setq shorturl (car shorturls))
          (setq shorturls (cdr shorturls))
          (unless (string= url shorturl)
            (insert (format "Amazon Short URL: <a href=\"%s\">%s</a><br>\n"
                            shorturl shorturl))))
        (insert "\n"))))

  ;; http://d.hatena.ne.jp/rubikitch/20080927/1222461058
  (setq google-code-search-languages
        '(;; 機械生成のため、すごいてきとー 要修正
          (actionscript-mode . "actionscript")
          (ada-mode . "ada")
          (applescript-mode . "applescript")
          (asp-mode . "asp")
          (assembly-mode . "assembly")
          (autoconf-mode . "autoconf")
          (automake-mode . "automake")
          (awk-mode . "awk")
          (basic-mode . "basic")
          (bat-mode . "bat")
          (c-mode . "c")
          (c++-mode . "c++")
          (csharp-mode . "c#")
          (cobol-mode . "cobol")
          (coldfusion-mode . "coldfusion")
          (configure-mode . "configure")
          (css-mode . "css")
          (d-mode . "d")
          (eiffel-mode . "eiffel")
          (erlang-mode . "erlang")
          (fortran-mode . "fortran")
          (haskell-mode . "haskell")
          (inform-mode . "inform")
          (java-mode . "java")
          (javascript-mode . "javascript")
          (jsp-mode . "jsp")
          (lex-mode . "lex")
          (limbo-mode . "limbo")
          (lisp-mode . "lisp")
          (emacs-lisp-mode . "lisp")
          (lua-mode . "lua")
          (m4-mode . "m4")
          (makefile-mode . "makefile")
          (maple-mode . "maple")
          (mathematica-mode . "mathematica")
          (matlab-mode . "matlab")
          (messagecatalog-mode . "messagecatalog")
          (modula2-mode . "modula2")
          (modula3-mode . "modula3")
          (objectivec-mode . "objectivec")
          (ocaml-mode . "ocaml")
          (pascal-mode . "pascal")
          (perl-mode . "perl")
          (php-mode . "php")
          (pod-mode . "pod")
          (prolog-mode . "prolog")
          (python-mode . "python")
          (r-mode . "r")
          (rebol-mode . "rebol")
          (ruby-mode . "ruby")
          (sas-mode . "sas")
          (scheme-mode . "scheme")
          (scilab-mode . "scilab")
          (shell-mode . "shell")
          (sgml-mode . "sgml")
          (smalltalk-mode . "smalltalk")
          (sql-mode . "sql")
          (sml-mode . "sml")
          (svg-mode . "svg")
          (tcl-mode . "tcl")
          (tex-mode . "tex")
          (texinfo-mode . "texinfo")
          (troff-mode . "troff")
          (verilog-mode . "verilog")
          (vhdl-mode . "vhdl")
          (vim-mode . "vim")
          (xslt-mode . "xslt")
          (xul-mode . "xul")
          (yacc-mode . "yacc")
          (aladdin-mode . "aladdin")
          (artistic-mode . "artistic")
          (apache-mode . "apache")
          (apple-mode . "apple")
          (bsd-mode . "bsd")
          (cpl-mode . "cpl")
          (gpl-mode . "gpl")
          (lgpl-mode . "lgpl")
          (disclaimer-mode . "disclaimer")
          (ibm-mode . "ibm")
          (lucent-mode . "lucent")
          (mit-mode . "mit")
          (mozilla-mode . "mozilla")
          (nasa-mode . "nasa")
          (python-mode . "python")
          (qpl-mode . "qpl")
          (sleepycat-mode . "sleepycat")
          (zope-mode . "zope")))

  ;; depends 50background.el
  (eval-after-load "w3m"
    '(progn
       (defun google-code-search (query &optional lang)
         (interactive
          (let ((lang (gcs-read-language)))
            (list (read-string
                   (format "Google code search (lang:%s): " lang)) lang)))
         (let ((w3m-pop-up-windows t))
           (if (one-window-p) (split-window))
           (other-window 1)
           (w3m
            (format
             "http://www.google.com/codesearch?q=%s+lang:%s&hl=ja&num=20"
             query lang)
            t)))
       (defun gcs-read-language ()
         (let ((cell (assq major-mode google-code-search-languages)))
           (if cell (cdr cell)
             (read-string "Language: "))))

       (defalias 'gcode 'google-code-search))))
