;;; pukiwiki-mode.el -- Major mode for Pukiwiki editing -*- coding: iso-2022-7bit -*-

;; Copyright (C) 2003 Hideaki Hori

;; Author: Hideaki Hori <yowaken@cool.ne.jp>

;; $Id$
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; usage:
;;
;; Put the following in ~/.emacs
;;
;;  (setq pukiwiki-site-list
;;        '(("Meadow" "http://www.bookshelf.jp/pukiwiki/pukiwiki.php" nil euc-jp-dos)
;;          ))
;;  (setq pukiwiki-auto-insert t)
;;  (autoload 'pukiwiki-edit "pukiwiki-mode" nil t)
;;  (autoload 'pukiwiki-index "pukiwiki-mode" nil t)
;;  (autoload 'pukiwiki-edit-url "pukiwiki-mode" nil t)

;; pukiwiki-mode $B$O(B hiki-mode $B$r%Y!<%9$K(B Pukiwiki $BBP1~$r9T$C$?$b$N$G$9!#(B
;; $B%P%0$J$I$N:]$K$O(B akihisa@mail.ne.jp $B$+(B
;; http://www.bookshelf.jp/pukiwiki/pukiwiki.php?%A5%A2%A5%A4%A5%C7%A5%A2%BD%B8%2Fpukiwiki-mode
;; $B$KJs9p$r$*4j$$$7$^$9!%(BHideaki Hori $BMM$K?R$M$k$3$H$O$7$J$$$G$/$@$5$$!%(B

;; Hi-lock: (("^;;; .*" (0 (quote hi-black-hb) t)))
;; Hi-lock: ( ("make-variable-buffer-\\(local\\)" (0 font-lock-keyword-face)(1 'italic append)))))
;; Hi-lock: end

(defvar pukiwiki-site-list
  '(("Meadow" "http://www.bookshelf.jp/pukiwiki/pukiwiki.php" nil euc-jp-dos)))
;;(setq pukiwiki-browser-function 'browse-url)

;;; Variable:
(eval-when-compile (require 'cl))
(require 'http)
(if (or (featurep 'xemacs)
        (not (boundp 'emacs-major-version))
        (< emacs-major-version 21))
    (progn
      (require 'poe)
      (require 'poem)))
(require 'derived)
(when (featurep 'xemacs)
  (require 'overlay))

(defconst pukiwiki-mode-version
  (let ((revision "$Revision: 2.26 $"))
    (string-match "\\([0-9.]+\\)" revision)
    (match-string 1 revision)))

(defvar pukiwiki-site-list nil
  "List of Pukiwiki list.
Each element looks like (NAME URL STYLE). STYLE is optional.")

(defvar pukiwiki-list nil
  "`pukiwiki-list' is OBSOLETE; use pukiwiki-site-list.")

(defvar pukiwiki-auto-insert nil)

(defvar pukiwiki-auto-face
  (if (locate-library "facemenu")
      t
    nil))

(defvar pukiwiki-index-wiki-name 50)

(defvar pukiwiki-site-info nil)

(defvar pukiwiki-index-page-info-list nil)
(defvar pukiwiki-index-attach-list nil)

(defvar pukiwiki-index-sort-key nil)

(defvar pukiwiki-pagename nil)

(defvar pukiwiki-prev-buffer nil)

(defvar pukiwiki-pagetitle nil)

(defvar pukiwiki-md5hex nil)

(defvar pukiwiki-edit-newpage nil)

(defvar pukiwiki-password-alist nil)

(defvar pukiwiki-index-mode-hook nil)
(defvar pukiwiki-history-mode-hook nil)

(defvar pukiwiki-browser-function nil
  "Function to call browser.
If non-nil, `pukiwiki-edit-save-page' calls this function.
The function is expected to accept only one argument(URL).")

(defvar pukiwiki-init-file "~/.pukiwiki"
  "Init file for pukiwiki-mode.")

(defvar pukiwiki-non-wikiname-regexp-string "[^A-Za-z0-9]")
(defvar pukiwiki-wikiname-regexp-string
  "\\([A-Z][a-z0-9]+\\([A-Z][a-z0-9]+\\)+\\)")
(defvar pukiwiki-wikiname-regexp-list
  (list
   (cons (concat pukiwiki-non-wikiname-regexp-string
                 pukiwiki-wikiname-regexp-string
                 pukiwiki-non-wikiname-regexp-string) 1)
   (cons (concat "^"
                 pukiwiki-wikiname-regexp-string
                 pukiwiki-non-wikiname-regexp-string) 1)
   (cons (concat pukiwiki-non-wikiname-regexp-string
                 pukiwiki-wikiname-regexp-string "$") 1)
   (cons (concat "^" pukiwiki-wikiname-regexp-string "$") 1)))
(defvar pukiwiki-bracket-name-regexp '("\\[\\[\\([^]:|]+\\)\\]\\]" . 1))
(defvar pukiwiki-rd+-bracket-name-regexp '("((<\\([^>:|]+\\)>))" . 1))

;; regexp for anchor of alias.
(defvar pukiwiki-bracket-alias-regexp
  '("\\[\\[\\([^]:|]+>+[^]:|]+\\)\\]\\]" . 1))

;; InterWikiName
;; regexp for anchor of InterWikiName and Alias.
(defvar pukiwiki-bracket-interwikiname-regexp
  '("\\[\\[\\([^]:|]+>*[^]:|]+:+[^]:|]+\\)\\]\\]" . 1))

;; regexp for anchor of href.
(defvar pukiwiki-view-bracket-url-regexp
  ;; '("\\[+\\(https*:[^]]+\\s-+[^]:|]+\\)\\]+" . 1))
  '("\\[+\\(\\(ht\\|f\\)tps*:[^]]+\\s-+[^]:|]+\\)\\]+" . 1))
(defvar pukiwiki-view-bracket-url-secondhalf-regexp
  ;; '("\\[+\\([^]]+:https*:[^]]+[^]:|]+\\)\\]+" . 1))
  '("\\[+\\([^]]+[>:]\\(ht\\|f\\)tps*:[^]]+[^]:|]+\\)\\]+" . 1))

;; regexp for anchor of href 2.
(defvar pukiwiki-view-no-bracket-url-regexp
  '("\\(h*ttps*:[-+_a-zA-Z0-9/.,~#?&%=]+\\)" . 1))

(defvar pukiwiki-style-anchor-regexp-alist
  (list
   (cons 'default
         (cons pukiwiki-bracket-name-regexp
               pukiwiki-wikiname-regexp-list))
   (cons 'rd+ (list pukiwiki-rd+-bracket-name-regexp))
   (cons 'delete-url-description
         (list pukiwiki-view-bracket-url-regexp
               pukiwiki-bracket-interwikiname-regexp
               pukiwiki-bracket-alias-regexp
               pukiwiki-view-bracket-url-secondhalf-regexp))
   (cons 'leave-url-description
         (list pukiwiki-bracket-name-regexp
               pukiwiki-view-no-bracket-url-regexp)))
  "Alist of regexp for anchor.")

(defvar pukiwiki-anchor-regexp-alist
  (cdr (assoc 'default pukiwiki-style-anchor-regexp-alist)))

(defvar pukiwiki-anchor-face
  (copy-face 'underline 'pukiwiki-anchor-face)
  "Face for Pukiwiki anchor." )

(defcustom pukiwiki-no-proxy-domains-list '("localhost")
  "*Domain list that don't via proxy server."
  :group 'pukiwiki
  :type '(repeat (string :format "Domain name: %v
" :size 0)))

(defcustom pukiwiki-process-sentinel-interval 1
  "*Sentinel time for end of process."
  :group 'pukiwiki
  :type '(integer :size 0))

(defcustom pukiwiki-process-timeout 5
  "*Timeout for end of process."
  :group 'pukiwiki
  :type '(integer :size 0))

(defcustom pukiwiki-jump-display-window-top nil
  "*Non-nil means displaying the pointer which moved at the top of a window."
  :group 'pukiwiki
  :type 'boolean)

(defcustom pukiwiki-jump-display-window-top-without-content nil
  "*Non-nil means excepting, if it is content
when displaying the pointer which moved at the top of a window."
  :group 'pukiwiki
  :type 'boolean)

(defcustom pukiwiki-jump-display-window-top-skip-visible-url nil
  "*Non-nil means ignore, if it is visible url description
when displaying the pointer which moved at the top of a window."
  :group 'pukiwiki
  :type 'boolean)

(defcustom pukiwiki-jump-display-window-upper-margin 0
  "*The margin of the window upper part when displaying the pointer
which moved at the top of a window."
  :group 'pukiwiki
  :type '(integer :size 0))

(defcustom pukiwiki-jump-display-window-top-only-header nil
  "*Non-nil means if it is header
when displaying the pointer which moved at the top of a window."
  :group 'pukiwiki
  :type 'boolean)

(defcustom pukiwiki-diff-using-ediff nil
  "*Non-nil means using `Ediff' package for diff process."
  :group 'pukiwiki
  :type 'boolean)

(defcustom pukiwiki-view-comment-form-name-field-width 20
  "*Width of the NAME input field."
  :group 'pukiwiki
  :type '(integer :size 0))

(defcustom pukiwiki-view-comment-form-comment-field-width 60
  "*Width of the COMMENT input field."
  :group 'pukiwiki
  :type '(integer :size 0))

(defcustom pukiwiki-view-comment-form-subject-field-width 40
  "*Width of the COMMENT input field."
  :group 'pukiwiki
  :type '(integer :size 0))

(defcustom pukiwiki-view-comment-form-message-field-width 64
  "*Width of the COMMENT input field."
  :group 'pukiwiki
  :type '(integer :size 0))

(defcustom pukiwiki-view-comment-form-name-default nil
  "*Default value of the NAME input field."
  :group 'pukiwiki
  :type '(radio (const :tag "Not specified" nil)
                (string :format "Default post name: %v\n" :size 0)))

(defcustom pukiwiki-interwiki-browse-not-match-pukiwiki nil
  "*Non-nil means browse extent browser by browse-url,
url is not match PukiWiki site."
  :group 'pukiwiki
  :type 'boolean)

(defcustom pukiwiki-view-jump-page-history-keep-count 100
  "*Maximum number of history which the HISTORY LIST keeps."
  :group 'pukiwiki
  :type '(integer :size 0))

(defcustom pukiwiki-view-form-textarea-buffer-history-keep-count 50
  "*Maximum number of history which the HISTORY LIST keeps."
  :group 'pukiwiki
  :type '(integer :size 0))

(defcustom pukiwiki-view-chip-away-bracket t
  "*Non-nil means chip away bracket from anchor."
  :group 'pukiwiki
  :type 'boolean)

(defcustom pukiwiki-view-comment-date-regexp
  '("[0-9]+-[0-9]+-[0-9]+" "[0-9]+$BG/(B[0-9]+$B7n(B[0-9]+$BF|(B")
  "*Date pattern list of comment."
  :group 'pukiwiki
  :type '(repeat (string :format "regexp: %v
" :size 0)))

(defcustom pukiwiki-save-post-data nil
  "*Non-nil means saving post data."
  :group 'pukiwiki
  :type 'boolean)

(defcustom pukiwiki-directory "~/pukiwiki"
  "*Directory to save files."
  :group 'pukiwiki
  :type 'directory)

(defvar pukiwiki-keywords
  '("add" "aname" "article" "attach" "back"
    "backup" "bugtrack" "bugtrack_list"
    "calendar" "calendar_edit" "calendar_read"
    "calendar_viewer" "calendar2" "color"
    "contents" "comment" "counter" "deleted" "diff"
    "edit" "filelist" "freeze" "img" "include"
    "includesubmenu" "insert" "interwiki"
    "links" "list" "lookup" "ls" "ls2"
    "map" "md5" "memo" "navi" "new"
    "newpage" "norelated" "online"
    "paint" "pcomment" "popular" "random"
    "read" "recent" "ref" "rename" "rss"
    "rss10" "ruby" "search" "server"
    "showrss" "size" "source" "tb" "template"
    "touchgraph" "tracker" "unfreeze" "version"
    "versionlist" "vote" "yetlist"))

(setq pukiwiki-view-list-face 'pukiwiki-view-list-1-face)
(defvar pukiwiki-font-lock-keywords
  (list
   (cons
    (concat "^[ ]*\\(_\\|\\[[0-9* ]+\\]\\) \\(\\("
            (mapconcat 'identity pukiwiki-view-comment-date-regexp "\\|")
            "\\)[ ]*([^)]+)[ ]*[0-9]+:[0-9]+:[0-9]+ *\\[*[^\r\n]+$\\)")
    '((1 'pukiwiki-view-button-face t t)
      (2 'pukiwiki-view-comment-header-face t t)))

   '("\\(^//[^\n\r]+$\\)" 1 'font-lock-comment-face)
   '("\\(^[>]+[^\n\r]+$\\)" 1 'font-lock-reference-face)
   (cons
    (concat "^#\\("
            (mapconcat 'identity pukiwiki-keywords "\\|")
            "\\)")
    (list 0 'font-lock-keyword-face))
   ;***** (list 0 'font-lock-reference-face))
   (cons
    (concat "^#\\("
            (mapconcat 'identity pukiwiki-keywords "\\|")
            "\\)"
            "(\\([^\n\r]+\\))")
    (list 2 'font-lock-doc-face))

   '("^\\*\\*\\*\\(\\(.*\\)\\|\\)\n" 0 'pukiwiki-heading3-face)
   '("^\\*\\*\\(\\(.*\\)\\|\\)\n"    0 'pukiwiki-heading2-face)
   '("^\\*\\(\\(.*\\)\\|\\)\n"       0 'pukiwiki-heading1-face)
   '("\\(^ [^\n\r]+$\\)" 1 'pukiwiki-view-preformat-face-1)))

(defface pukiwiki-added-face
  '((((class color)
      (background dark))
     (:background "navy" :foreground "honeydew"))
    (((class color)
      (background light))
     (:background "alice blue" :foreground "black"))
    (t
     ())) nil)

(defface pukiwiki-removed-face
  '((((class color)
      (background dark))
     (:background "firebrick4" :foreground "snow3"))
    (((class color)
      (background light))
     (:background "misty rose" :foreground "black"))
    (t
     ())) nil)
(defvar pukiwiki-added-face 'pukiwiki-added-face)
(defvar pukiwiki-removed-face 'pukiwiki-removed-face)

;; view mode $B$N(B face $BDj5A!#(B
(defgroup pukiwiki-face nil
  "The faces used for pukiwiki-mode."
  :group 'pukiwiki
  :prefix "pukiwiki-")

(defface pukiwiki-heading1-face
  '((((class color) (background light))
     (:foreground "Black"
                  :background "SlateGray1"
                  :box (:line-width 2 :color "grey75" :style released-button)
                  :weight bold :height 1.4))
    (t
     (:foreground "gray85" :background "gray13" ;; "LightGray"
                  :box (:line-width 3 :color "blue" :style released-button)
                  :weight bold :height 1.4)))
  "Face for level-1 headings in pukiwiki mode"
  :group 'pukiwiki-face)

(defface pukiwiki-heading2-face
  '((((class color) (background light))
     (:foreground "Black"
                  :background "SlateGray1"
                  :weight bold :height 1.2))
    (t
     (:foreground "gray85"
                  :background "gray13"
                  :weight bold :height 1.2)))
  "Face for level-2 headings in pukiwiki mode"
  :group 'pukiwiki-face)

(defface pukiwiki-heading3-face
  '((((class color) (background light))
     (:foreground "Black"
                  :background "SlateGray1"
                  :height 1.1))
    (t
     (:foreground "gray90"              ;"LightGoldenrod"
                  :underline nil :weight bold :height 1.1)))
  "Face for level-3 headings in pukiwiki mode"
  :group 'pukiwiki-face)

(defface pukiwiki-view-comment-header-face
  '((((class color) (background light)) (:foreground "seagreen"))
    (((class color) (background dark)) (:foreground "medium spring green")))
  "$B%3%a%s%H8+=P$7(B ($BF|IU!";~9o$HEj9F<T$,I=<($5$l$kItJ,(B) $B$N(B face"
  :group 'pukiwiki-face)

(defface pukiwiki-view-cite-face
  '((((class color) (background light)) (:foreground "olivedrab"))
    (((class color) (background dark)) (:foreground "aquamarine")))
  "$B0zMQItJ,$N(B face"
  :group 'pukiwiki-face)

(defface pukiwiki-view-preformat-face
  '((((class color) (background light)) (:foreground "slateblue"))
    (((class color) (background dark)) (:foreground "deep sky blue")))
  "$B@07A:Q$_%F%-%9%H$N(B face ($B9TF,$N6uGr(B 7$B%P%$%H0J>e(B)"
  :group 'pukiwiki-face)

(defface pukiwiki-view-preformat-face-1
  '((((class color) (background light)) (:foreground "slateblue"))
    (((class color) (background dark)) (:foreground "deep sky blue")))
  "$B@07A:Q$_%F%-%9%H$N(B face ($B9TF,$N6uGr(B 1$B%P%$%H(B)"
  :group 'pukiwiki-face)

(defface pukiwiki-view-preformat-face-2
  '((((class color) (background light)) (:foreground "mediumpurple"))
    (((class color) (background dark)) (:foreground "blueviolet")))
  "$B@07A:Q$_%F%-%9%H$N(B face ($B9TF,$N6uGr(B 2$B%P%$%H(B)"
  :group 'pukiwiki-face)

(defface pukiwiki-view-preformat-face-3
  '((((class color) (background light)) (:foreground "mediumseagreen"))
    (((class color) (background dark)) (:foreground "seagreen")))
  "$B@07A:Q$_%F%-%9%H$N(B face ($B9TF,$N6uGr(B 3$B%P%$%H(B)"
  :group 'pukiwiki-face)

(defface pukiwiki-view-preformat-face-4
  '((((class color) (background light)) (:foreground "deeppink"))
    (((class color) (background dark)) (:foreground "hotpink")))
  "$B@07A:Q$_%F%-%9%H$N(B face ($B9TF,$N6uGr(B 4$B%P%$%H(B)"
  :group 'pukiwiki-face)

(defface pukiwiki-view-preformat-face-5
  '((((class color) (background light)) (:foreground "lightcoral"))
    (((class color) (background dark)) (:foreground "coral")))
  "$B@07A:Q$_%F%-%9%H$N(B face ($B9TF,$N6uGr(B 5$B%P%$%H(B)"
  :group 'pukiwiki-face)

(defface pukiwiki-view-preformat-face-6
  '((((class color) (background light)) (:foreground "royalblue"))
    (((class color) (background dark)) (:foreground "dodgerblue")))
  "$B@07A:Q$_%F%-%9%H$N(B face ($B9TF,$N6uGr(B 6$B%P%$%H(B)"
  :group 'pukiwiki-face)

(defface pukiwiki-view-strikethru-face
  '((((class color) (background light)) (:strikethru t))
    (((class color) (background dark)) (:strikethru t)))
  "$BBG$A>C$7@~$N(B face"
  :group 'pukiwiki-face)

(defface pukiwiki-view-list-1-face
  '((((class color) (background light)) (:foreground "darkmagenta"))
    (((class color) (background dark)) (:foreground "misty rose")))
  "$B%j%9%H9`L\$N(B face"
  :group 'pukiwiki-face)

(defface pukiwiki-view-button-face
  '((((class color) (background light)) (:foreground "darkgoldenrod"))
    (((class color) (background dark)) (:foreground "goldenrod")))
  "anchor button $B$N(B face"
  :group 'pukiwiki-face)

(defface pukiwiki-view-current-button-face
  '((((class color) (background light)) (:background "Paleturquoise"))
    (((class color) (background dark)) (:background "lightblue")))
  "$B%]%$%s%H$,>h$C$?$H$-$N(B anchor button $B$N(B face"
  :group 'pukiwiki-face)

(defface pukiwiki-view-url-face
  '((((class color) (background light)) (:foreground "Blue"))
    (((class color) (background dark)) (:foreground "cyan1")))
  "anchor url $B$N(B face"
  :group 'pukiwiki-face)

(defface pukiwiki-view-anchor-face
  '((((class color) (background light)) (:underline t))
    (((class color) (background dark)) (:underline t)))
  "wiki anchor $B$N(B face"
  :group 'pukiwiki-face)

(defface pukiwiki-view-current-url-face
  '((((class color) (background light)) (:background "Paleturquoise"))
    (((class color) (background dark)) (:background "lightblue")))
  "$B%]%$%s%H$,>h$C$?$H$-$N(B anchor url $B$N(B face"
  :group 'pukiwiki-face)

(defface pukiwiki-index-current-line-face
  '((((class color) (background light)) (:background "Yellow"))
    (((class color) (background dark)) (:foreground "Gold")))
  "$B%$%s%G%C%/%9>e$N%]%$%s%H$,>h$C$?9T$N(B face"
  :group 'pukiwiki-face)

;; index mode.
(defface pukiwiki-index-normal-face
  '((((class color) (background light)) (:foreground "green4"))
    (((class color) (background dark)) (:foreground "yellow")))
  "$B%$%s%G%C%/%9$NDL>o9T$N(B face"
  :group 'pukiwiki-face)

(defface pukiwiki-index-cache-face
  '((((class color) (background light)) (:foreground "BlueViolet"))
    (((class color) (background dark)) (:foreground "green3")))
  "$B%$%s%G%C%/%9$N%-%c%C%7%e:Q$_9T$N(B face"
  :group 'pukiwiki-face)

(setq pukiwiki-index-font-lock-keywords
      (list
       '("^\\s-*\\([0-9]+\\s-+V\\s-+.+[0-9/]+$\\)" 1 'pukiwiki-index-cache-face)
       '("^\\s-*\\([0-9]+\\s-+.+\\s-+[0-9/]+$\\)" 1 'pukiwiki-index-normal-face)
       ))

(defvar pukiwiki-diff-font-lock-keywords
  (list
   '("\\(^+[^\n\r]*$\\)" 1 'pukiwiki-added-face)
   '("\\(^-[^\n\r]*$\\)" 1 'pukiwiki-removed-face)
   '("\\(^ //[^\n\r]+$\\)" 1 'font-lock-comment-face)
   '("\\(^ [>]+[^\n\r]+$\\)" 1 'font-lock-reference-face)
   '("\\(^  [^\n\r]+$\\)" 1 'font-lock-constant-face)
   '("^ \\(-+[^\n\r]+$\\)" 1 'font-lock-keyword-face)
   (cons
    (concat "^ #\\("
            (mapconcat 'identity pukiwiki-keywords "\\|")
            "\\)")
    (list 0 'font-lock-keyword-face))
   (cons
    (concat "^ #\\("
            (mapconcat 'identity pukiwiki-keywords "\\|")
            "\\)"
            "(\\([^\n\r]+\\))")
    (list 2 'font-lock-doc-face))
   '("\\(^ [*]+[^\n\r]+\\)" 1 'font-lock-function-name-face)))

(defvar pukiwiki-site-name-history nil
  "History of Pukiwiki site name." )

(defvar pukiwiki-pagename-history nil
  "History of Pukiwiki page name." )

(defvar pukiwiki-diff-buffer-name "*Pukiwiki diff*")

(defvar pukiwiki-page-buffer-alist nil)

(defvar pukiwiki-init nil)

(defvar pukiwiki-search-word nil)
(defvar pukiwiki-search-list nil)
(make-variable-buffer-local 'pukiwiki-search-list)
(defvar font-lock-comment-start-regexp nil
  "Regexp to match the start of a comment.")

;;; $BHFMQ4X?t(B

(defun pukiwiki-mode-version ()
  (interactive)
  (message (format "pukiwiki-mode (Revision: %s)"
                   pukiwiki-mode-version)))

(defun pukiwiki-initialize ()
  (unless pukiwiki-init
    (pukiwiki-load-init-file)
    (setq pukiwiki-init t)))

;;; $BJT=8%b!<%I(B (pukiwiki-edit-*)
(defun pukiwiki-mode-set-variable ()
  (setq tab-width 4)
  (make-local-variable 'fill-prefix)
  (make-local-variable 'paragraph-start)
  (make-local-variable 'require-final-newline)
  (make-local-variable 'pukiwiki-site-info)
  (make-local-variable 'pukiwiki-newpage)
  (make-local-variable 'pukiwiki-pagename)
  (make-local-variable 'pukiwiki-prev-buffer)
  (make-local-variable 'pukiwiki-md5hex)
  (setq require-final-newline t
        indent-tabs-mode nil))

(defun pukiwiki-mode-set-font-lock (mode)
  (setq pukiwiki-anchor-regexp-alist
        (cdr (assoc (pukiwiki-site-style pukiwiki-site-info)
                    pukiwiki-style-anchor-regexp-alist)))
  (put mode 'font-lock-defaults
       '(text-font-lock-keywords nil t))
  (when (and (featurep 'font-lock)
             (fboundp 'font-lock-add-keywords))
    (let ((case-fold-search nil))
      (font-lock-add-keywords
       mode
       (mapcar (lambda (cell)
                 (list (car cell) (cdr cell)
                       'pukiwiki-anchor-face t))
               pukiwiki-anchor-regexp-alist)))
    (turn-on-font-lock)))

(define-derived-mode pukiwiki-edit-mode text-mode "Pukiwiki Edit"
  "Major mode for Pukiwiki editing.

\\{pukiwiki-edit-mode-map}"
  (pukiwiki-mode-set-variable)
  (pukiwiki-edit-setup-keys)
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults
        '(pukiwiki-font-lock-keywords
          nil nil ((?_ . "w")) nil
          (font-lock-comment-start-regexp . "//")))
  (pukiwiki-mode-set-font-lock 'pukiwiki-edit-mode)
  (run-hooks 'pukiwiki-edit-mode-hook))

(defun pukiwiki-edit-setup-keys ()
  "Set up keymap for pukiwiki-edit-mode.
If you want to set up your own key bindings, use `pukiwiki-edit-mode-hook'."
  (define-key pukiwiki-edit-mode-map "\C-c\C-i" 'pukiwiki-edit-next-anchor)
  (define-key pukiwiki-edit-mode-map "\C-c\C-r" 'pukiwiki-edit-reload)
  (define-key pukiwiki-edit-mode-map "\C-c\C-e" 'pukiwiki-edit)
  (define-key pukiwiki-edit-mode-map "\C-c\C-c" 'pukiwiki-edit-save-page)
  (define-key pukiwiki-edit-mode-map "\C-c\C-p" 'pukiwiki-edit-preview)
  (define-key pukiwiki-edit-mode-map "\C-c\C-q" 'pukiwiki-edit-quit)
  (define-key pukiwiki-edit-mode-map "\C-m" 'pukiwiki-edit-new-line)
  (define-key pukiwiki-edit-mode-map "\C-xv=" 'pukiwiki-index-show-diff)
  )

(defun pukiwiki-load-init-file ()
  "Load init file."
  (when pukiwiki-init-file
    (let ((init-file (expand-file-name pukiwiki-init-file)))
      (when (file-readable-p init-file)
        (load init-file t t))
      (pukiwiki-obsolete-check))))

(defun pukiwiki-obsolete-check ()
  (when pukiwiki-list
    (message "pukiwiki-list is OBSOLETE. Use pukiwiki-site-list.")
    (setq pukiwiki-site-list pukiwiki-list)))

(defun pukiwiki-read-site-name (&optional string)
  "$B%5%$%HL>$r%_%K%P%C%U%!$+$iFI$_!"%5%$%H>pJs$N%j%9%H$rJV$9!#(B

STRING $B$,(B non-nil $B$J$i!"$=$l$r%5%$%HL>$H$9$k!#(B"
  (let* ((selected (car pukiwiki-site-list))
         (default (or (pukiwiki-site-name) (car selected))))
    (assoc
     (or
      (completing-read
       (format "Select SITE (%s): " default) pukiwiki-site-list
       nil t nil 'pukiwiki-site-name-history default) default)
     pukiwiki-site-list)))

(defun pukiwiki-password-read (sitename pagename)
  (cdr (assoc (cons sitename pagename) pukiwiki-password-alist)))

(defun pukiwiki-password-store (sitename pagename password)
  (let (key unit)
    (setq key (cons sitename pagename)
          unit (assoc key pukiwiki-password-alist))
    (if unit
        (if password
            (setcdr unit password)
          (setq pukiwiki-password-alist
                (delete unit pukiwiki-password-alist)))
      (if password
          (setq pukiwiki-password-alist
                (cons (cons (cons sitename pagename)
                            password) pukiwiki-password-alist))))))

;; $B>e5-(B2$B$D$N%Q%9%o!<%IMQ4X?t$O(Bhiki$B$H$N8_49@-$N$?$a$@$1$K$"$k(B
(defun pukiwiki-save-passwd (server user pass &optional force)
  (when force
    (setq pukiwiki-password-alist
          (delete (assoc server pukiwiki-password-alist)
                  pukiwiki-password-alist))
    (pukiwiki-save-passwd server user pass))
  (if (assoc server pukiwiki-password-alist)
      ()
    (setq pukiwiki-password-alist
          (cons
           `(
             ,server
             ,user ,pass)
           pukiwiki-password-alist
           ))))

(defun pukiwiki-read-pagename (arg site-name)
  (completing-read (format "Page name for %s: " site-name)
                   (cdr (assoc site-name pukiwiki-pagename-history))
                   nil nil arg nil arg))

(defun pukiwiki-read-char (prompt)
  "PROMPT (non-nil $B$N>l9g(B) $B$rI=<($7$F(B `read-char' $B$r8F$S=P$9!#(B"
  ;;; navi2ch-read-char $B$r;29M$K$7$F$^$9!#(B
  (let ((cursor-in-echo-area t)
        c)
    (if prompt
        (message "%s" prompt))
    (setq c (read-char))
    (if prompt
        (message "%s%c" prompt c))
    c))

(defun pukiwiki-read-char-with-retry (prompt retry-prompt list)
  ;;; navi2ch-read-char-with-retry $B$r;29M$K$7$F$^$9!#(B
  (let ((retry t) c)
    (while retry
      (setq c (pukiwiki-read-char prompt))
      (cond ((memq c list) (setq retry nil))
            ((eq c 12) (recenter))
            (t
             (ding)
             (setq prompt (or retry-prompt prompt)))))
    c))

(defun pukiwiki-http-request (mode cmd pagename site-url coding-system &optional post-data)
  (let (url buf)
    (cond
     ((eq mode 'post)
      (if pukiwiki-1-3-p
          (setq url (concat
                     (format "%s?cmd=post&page=%s"
                             site-url
                             (http-url-hexify-string
                              pagename
                              coding-system))))
        (setq url (concat
                   (format "%s?cmd=%s&page=%s"
                           site-url "edit"
                           (http-url-hexify-string
                            pagename
                            coding-system))))))
      ((eq mode 'search)
      (setq url (concat
                 (format "%s?cmd=search"
                         site-url)))
      (setq mode 'post))
     ((eq mode 'raw)
      (setq mode 'get)
      (setq url site-url))
     (t
      (setq url (concat
                 (format "%s?cmd=%s" site-url cmd)
                 (if pagename
                     (format "&page=%s"
                             (http-url-hexify-string
                              pagename
                              coding-system)))
                 ""))))
    (setq buf (pukiwiki-http-fetch
               url mode nil nil
               (http-url-hexify-alist
                post-data coding-system)))
    (if (bufferp buf)
        (save-excursion
          (set-buffer buf)
          (decode-coding-region (point-min) (point-max)
                                coding-system)
          (goto-char (point-min))
          buf)
      (error (format "pukiwiki get: %s - %s"
                     (car buf) (cdr buf))))))

(defun pukiwiki-current-anchor-string ()
  "Return anchor string at current point."
  (let (str result pos (point (point)))
    (save-excursion
      (beginning-of-line)
      (setq pos (point))
      (while (and (setq result (pukiwiki-search-anchor
                                pos pukiwiki-anchor-regexp-alist))
                  (<= (cdr result) point))
        (setq pos (cdr result)))
      (when (and result (<= (car result) point))
        (setq str (buffer-substring-no-properties
                   (car result) (cdr result)))))
    str))

(defun pukiwiki-edit-next-anchor (&optional prev)
  "$B<!$N%"%s%+!<$X0\F0$9$k!#(B

PREV $B$,(B non-nil $B$J$i$P!"A0$N%"%s%+!<$X0\F0$9$k!#(B"
  (interactive "P")
  (goto-char (or (car (pukiwiki-search-anchor
                       (point) pukiwiki-anchor-regexp-alist prev))
                 (point))))

(defun pukiwiki-search-anchor (point list &optional prev)
  "POINT $B$+$i:G$b6a$$%"%s%+!<$rC5$9!#(B

$B8+$D$+$C$?$i(B (beginning . end) $B$r!"8+$D$+$i$J$+$C$?$i(B nil $B$r(B $BJV$9(B"
  (let ((case-fold-search nil)
        (alist list)
        result)
    (save-excursion
      (while alist
        (goto-char point)
        (if (if prev
                (re-search-backward (car (car alist)) nil t nil)
              (re-search-forward (car (car alist)) nil t nil))
            (when (or (null result)
                      (> (car result)
                         (match-beginning (cdr (car alist)))))
              (setq result
                    (cons (match-beginning (cdr (car alist)))
                          (match-end (cdr (car alist)))))))
        (setq alist (cdr alist))))
    result))

(defun pukiwiki-edit-rename-buffer (sitename pagename pagetitle frozenp)
  (let ((name
         (format "[%s%s] %s%s"
                 sitename
                 (if (string= pagename pagetitle)
                     "" (concat ":" pagename))
                 pagetitle (if frozenp " (frozen)" ""))))
    (or (string= name (buffer-name))
        (rename-buffer name t))))

(defun pukiwiki-edit-url (str &optional url-encoded)
  "URL $B$r;XDj$7$FJT=8$9$k!#(B"
  (interactive "sURL: ")
  (let (url pagename site-info buf)
    (or (string-match "^\\(http://[^?]+\\)\\?\\(.+\\)$" str)
        (error "Illegal URL. (%s)" str))
    (setq url (match-string 1 str))
    (setq pagename (match-string 2 str))
    (when (string-match "=" pagename)
      (if (string-match "\\(^\\|[?&;]\\)p=\\(.+\\)" pagename)
          (setq pagename (match-string 2 pagename))
        (error "Illegal URL. (%s)" str)))
    (setq site-info (list url url))
    (setq buf
          (pukiwiki-edit-page
           (http-url-unhexify-string pagename
                                     (pukiwiki-site-coding-system site-info))
           site-info))
    (switch-to-buffer buf)
    buf
    ))

(defun pukiwiki-edit-quit ()
  (interactive)
  (let ((site-info pukiwiki-site-info)
        (pagename pukiwiki-pagename)
        win cancelled)
    (setq buffer-read-only t)
    (when (buffer-modified-p)
      (if (y-or-n-p "Buffer is modified. Really quit?")
          (progn
            (kill-buffer (current-buffer))
            (setq pukiwiki-page-buffer-alist
                  (remassoc
                   (list (pukiwiki-site-name site-info) pagename)
                   pukiwiki-page-buffer-alist))
            (delete-other-windows))
        (setq cancelled t)))
    (when (not cancelled)
      (cond
       ((setq win (get-buffer-window
                   (pukiwiki-index-buffer-name site-info)))
        (select-window win))
       (t (delete-other-windows)))
      (pukiwiki-index site-info t pagename))))

(defun pukiwiki-edit-reload ()
  "$B8=:_JT=8Cf$N%Z!<%8$r%j%m!<%I$9$k!#(B"
  (interactive)
  (let ((selected-pagename pukiwiki-pagename))
    (pukiwiki-edit)))

(defun pukiwiki-edit (&optional select-site)
  "$B%Z!<%8L>$r;XDj$7$FJT=8$9$k!#(B

SELECT-SITE $B$,(B non-nil $B$N;~$O!"(BSITE$BL>$b;XDj$9$k!#(B"
  (interactive "P")
  (pukiwiki-initialize)
  (let ((point (point))
        (start (window-start))
        buf site-info pagename (same-site t) same-page)
    ;; site-name input (if required)
    (cond
     ((and (pukiwiki-site-name) (not select-site))
      (setq site-info pukiwiki-site-info))
     (t
      (setq site-info (pukiwiki-read-site-name))
      (when (not (string=
                  (pukiwiki-site-name site-info)
                  (pukiwiki-site-name)))
        (setq same-site nil))))
    ;; pagename input
    (setq pagename
          (if (boundp 'selected-pagename)
              selected-pagename
            (pukiwiki-read-pagename
             (or (pukiwiki-current-anchor-string)
                 pukiwiki-pagename "FrontPage")
             (pukiwiki-site-name site-info))))
    (if (string= pagename pukiwiki-pagename) (setq same-page t))
    ;; edit
    (setq buf (pukiwiki-edit-page pagename site-info))
    ;; restore point (if required)
    (when (and same-site same-page)
      (set-window-start (selected-window) start)
      (goto-char point))
    (switch-to-buffer buf)))

(defun pukiwiki-save-post-data (contents site-info pagename)
  (let ((filename
         (expand-file-name
         (format-time-string
          "%Y-%m-%d-%I-%M-%S.txt")
         pukiwiki-directory
         )))
    (if (file-exists-p pukiwiki-directory)
        ()
      (make-directory pukiwiki-directory))
    (with-temp-buffer
      (insert
       (concat
        "site: " (car site-info) "\n"
        "url: " (car (cdr site-info)) "\n"
        "pagename: " pagename "\n"
        "----\n"))
      (insert contents)
      (write-region (point-min) (point-max) filename))))

(defvar pukiwiki-post-data nil)
(defun pukiwiki-edit-save-page (&optional toggle)
  (interactive "P")
  (let (buf contents post-data pagetitle password freeze keywords result
            (site-info pukiwiki-site-info)
            (pbuf (current-buffer)))
    (message "Sending... ")

    ;; $BJ8;z%3!<%I$,JQ99$5$l$F$$$?;~$KLa$7$F$*$/(B
    (if (string=
         (if (featurep 'xemacs)
             (let ((coding-system-string
                    (format "%s" buffer-file-coding-system)))
               (string-match "#<coding_system \\([^>]*\\)>"
                             coding-system-string)
               (match-string 1 coding-system-string))
           buffer-file-coding-system)
         (pukiwiki-site-coding-system))
        ()
      (set-buffer-file-coding-system (pukiwiki-site-coding-system)))
    ;; $BH>3Q%+%?%+%J$OA43Q$KJQ49$7$FAw?.(B
    (pukiwiki-check-jisx0201)
    ;; $BJ8;z%3!<%I$N$*$+$7$$J8;z$,L5$$$+3NG'(B
    (pukiwiki-check-encode-able (point-min) (point-max))

    (setq password (pukiwiki-password-read
                    (car pukiwiki-site-info) pukiwiki-pagename)
          freeze (if toggle (not password) (if password t)))
    (if (or (eq t password) (and freeze (not password)))
        (setq password
              (read-passwd
               (format "Password for [%s] %s: "
                       (car pukiwiki-site-info) pukiwiki-pagename))))
    (setq pagetitle pukiwiki-pagename)
    (setq contents
          (buffer-substring-no-properties (point-min) (point-max)))
    (add-to-list 'post-data (cons "cmd" "edit"))
    (add-to-list 'post-data (cons "encode_hint" "$B$W(B"))
    (add-to-list 'post-data (cons "template_page" ""))
    (add-to-list 'post-data (cons "write" "$B%Z!<%8$N99?7(B"))
    (add-to-list 'post-data (cons "page" pagetitle))
    (add-to-list 'post-data (cons "digest" pukiwiki-md5hex))
    (add-to-list 'post-data (cons "password" password))
    (add-to-list 'post-data (cons "msg" contents))
    (setq buf
          (pukiwiki-http-request 'post nil pukiwiki-pagename
                                 (pukiwiki-site-url)
                                 (pukiwiki-site-coding-system)
                                 post-data))
    (setq pukiwiki-post-data post-data)
    (when (bufferp buf)
      (save-excursion
        (set-buffer buf)
        ;;(decode-coding-region (point-min) (point-max) pukiwiki-coding-system)
        (setq result
              (cond
               ((progn
                  (goto-char (point-min))
                  (re-search-forward
                   "textarea[^\n\r]*name=[^\n\r]*original[^\n\r]*" nil t))
                (let ((md5hex nil) (cbuf (current-buffer)))
                  (goto-char (point-min))
                  (re-search-forward
                   "name=\"digest\" value=\"\\([^ ]+\\)\" />" nil t nil)
                  (setq md5hex (match-string-no-properties 1))
                  (set-buffer pbuf)
                  (setq pukiwiki-md5hex md5hex)
                  (set-buffer cbuf))
                'conflict)
               (t 'success))))
      (cond
       ((equal result 'conflict)
        (pukiwiki-conflict-show-diff)
        (error "Conflict! (--- server, +++ yours)"))
       ((equal result 'wrong-pass)
        (error "Password is wrong!")))
      (message "Sending... done.")
      (when pukiwiki-save-post-data
        (pukiwiki-save-post-data contents site-info pagetitle))

      ;; $BI=<(2hLL$r@07A(B
      (pukiwiki-view-reformating)

      (set-buffer-modified-p nil)
      (setq buffer-read-only t)
      (pukiwiki-password-store
       (car pukiwiki-site-info) pukiwiki-pagename (if freeze password nil))
      (pukiwiki-edit-rename-buffer
       (car pukiwiki-site-info) pukiwiki-pagename
       (setq pukiwiki-pagetitle pagetitle) freeze)
      (and (functionp pukiwiki-browser-function)
           (funcall pukiwiki-browser-function
                    (format "%s?%s" (pukiwiki-site-url) pukiwiki-pagename)))
      (pukiwiki-edit-quit)
      (delete-other-windows)
      )))

;;;; $B%W%l%S%e!<(B
(defvar pukiwiki-preview-file-list nil)
(defun pukiwiki-edit-preview (&optional toggle)
  (interactive "P")
  (let ((site-url (pukiwiki-site-url))
        (coding-system (pukiwiki-site-coding-system))
        (filename (concat
                   (expand-file-name
                    (concat (make-temp-name "pw") ".html")
                    temporary-file-directory)))
        ;;(getenv "TEMP")
        buf contents post-data pagetitle password freeze keywords result
        (pbuf (current-buffer)))
    (message "Sending... ")
    (setq pagetitle pukiwiki-pagename)
    (setq contents (buffer-substring-no-properties (point-min) (point-max)))
    (add-to-list 'post-data (cons "cmd" "edit"))
    (add-to-list 'post-data (cons "encode_hint" "$B$W(B"))
    (add-to-list 'post-data (cons "template_page" ""))
    (add-to-list 'post-data (cons "preview" "$B%W%l%S%e!<(B"))
    (add-to-list 'post-data (cons "page" pagetitle))
    (add-to-list 'post-data (cons "digest" pukiwiki-md5hex))
    (add-to-list 'post-data (cons "password" password))
    (add-to-list 'post-data (cons "msg" contents))
    (setq buf
          (pukiwiki-http-request 'post nil pukiwiki-pagename
                                 site-url
                                 coding-system
                                 post-data))
    (setq pukiwiki-post-data post-data)
    (message "Sending... done.")
    (when (bufferp buf)
      (save-excursion
        (set-buffer buf)
        ;;(decode-coding-region (point-min) (point-max) pukiwiki-coding-system)
        (goto-char (point-min))
        (re-search-forward "^<" nil t)
        (beginning-of-line)
        (delete-region (point-min) (point))
        (re-search-forward "<head>" nil t)
        (insert (concat
                 "<base href=\"" site-url "\">"))
        (goto-char (point-max))
        (re-search-backward "</html>" nil t)
        (end-of-line)
        (delete-region (point) (point-max))
        (set-buffer-file-coding-system coding-system)
        (write-region (point-min) (point-max) filename)
        (setq pukiwiki-preview-file-list
              (cons
               filename
               pukiwiki-preview-file-list))
        (if (functionp pukiwiki-browser-function)
            (funcall pukiwiki-browser-function
                     filename)
          (browse-url filename))
        ))))

(defun pukiwiki-conflict-show-diff ()
  "$B8=:_$N%P%C%U%!$H%5!<%P$N%G!<%?$rHf3S$7!"I=<($9$k!#(B"
  (let
      ((file1 (expand-file-name (make-temp-name "pukiwiki")
                                temporary-file-directory))
       (file2 (expand-file-name (make-temp-name "pukiwiki")
                                temporary-file-directory))
       (str (buffer-substring-no-properties (point-min) (point-max)))
       (pagename pukiwiki-pagename)
       (site-url (pukiwiki-site-url))
       (coding-system (pukiwiki-site-coding-system))
       diff-process diff-switches lines)
    (if (get-buffer pukiwiki-diff-buffer-name)
        (kill-buffer pukiwiki-diff-buffer-name))
    (with-temp-file file1
      (insert (cdr (assoc 'body
                          (pukiwiki-fetch-source pagename site-url coding-system))))
      (pukiwiki-replace-entity-refs)
      (if (> (current-column) 0) (insert "\n"))
      (setq lines (count-lines (point-min) (point-max))))
    (with-temp-file file2
      (insert str)
      (if (> (current-column) 0) (insert "\n")))
    (setq diff-process
          (start-process
           "diff" pukiwiki-diff-buffer-name
           diff-command "-U" (format "%d" lines) file1 file2))
    (set-process-sentinel diff-process (lambda (process event)))
    (save-excursion
      (set-buffer pukiwiki-diff-buffer-name)
      (setq buffer-read-only nil)
      (erase-buffer)
      (pukiwiki-diff-mode)
      (while
          (progn
            (accept-process-output diff-process 1)
            (not (equal (process-status (current-buffer)) 'exit))))
      (setq buffer-read-only nil)
      ;; delete header
      (goto-char (point-min))
      (forward-line 3)
      (delete-region (point-min) (point))
      (pop-to-buffer (process-buffer diff-process))
      (setq buffer-read-only t))
    (delete-file file1)
    (delete-file file2)))

;;; $BI=<(%b!<%I(B (pukiwiki-view)
(define-derived-mode pukiwiki-view-mode text-mode "Pukiwiki View"
  "Major mode for Pukiwiki editing.

\\{pukiwiki-edit-mode-map}"
  (pukiwiki-mode-set-variable)
  (pukiwiki-view-setup-keys)
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults
        '(pukiwiki-font-lock-keywords
          nil nil ((?_ . "w")) nil
          (font-lock-comment-start-regexp . "//")))
  (pukiwiki-mode-set-font-lock 'pukiwiki-view-mode)
  ;; hooks
  (progn
    (make-local-hook 'post-command-hook)
    (add-hook 'post-command-hook 'pukiwiki-view-post-command-function nil t)
    (make-local-hook 'pukiwiki-view-post-command-hook)
    (add-hook 'pukiwiki-view-post-command-hook
              (function
               (lambda ()
                 (pukiwiki-view-echo-url-at-point)
                 (pukiwiki-view-highlight-current-anchor)))
              nil t))
  (run-hooks 'pukiwiki-view-mode-hook))

(add-hook 'pukiwiki-view-mode-hook
          (function
           (lambda ()
             (if (fboundp 'turn-off-font-lock)
                 (turn-off-font-lock))
             (if (fboundp 'turn-on-font-lock)
                 (turn-on-font-lock))
             (setq fill-column (- (window-width) 4)) ; window width $B$K9g$o$;$k!#(B
             )))

(defun pukiwiki-view-post-command-function ()
  (run-hooks 'pukiwiki-view-post-command-hook))

(defun pukiwiki-view-echo-url-at-point ()
  (progn
    (when (setq prop (get-text-property (point) 'url))
      (princ prop))))

(defun pukiwiki-view-highlight-current-anchor ()
  (progn
    (pukiwiki-view-highlight-off-current-anchor)
    (pukiwiki-view-highlight-on-current-anchor)))

(defun pukiwiki-view-highlight-on-current-anchor ()
  (let ((pos (point))
        (type (get-text-property (point) 'anchortype))
        star end orig)
    (when (and (get-text-property (point) 'anchor)
               (or (eq 'url type) (eq 'pagename type)))
      (save-excursion
        ;; highlighit $B$9$k(B region $B$rFCDj$9$k!#(B
        (setq end (next-single-property-change (point) type))
        (setq start (previous-single-property-change end type))
        (unless start (setq start (point-min)))

        ;; overlay set.
        (setq ovr-temp (make-overlay start end))
        (overlay-put ovr-temp 'face 'pukiwiki-view-current-url-face)
        (overlay-put ovr-temp 'pukiwiki-temp-overlay t)
        (overlay-put ovr-temp 'priority 1)))))

(defun pukiwiki-view-highlight-off-current-anchor ()
  (let ((overlays (overlays-in (point-min) (point-max))))
    (while
        (setq ovr (prog1 (car overlays) (setq overlays (cdr overlays))))
      (when (overlay-get ovr 'pukiwiki-temp-overlay)
        (delete-overlay ovr)))))

(defun pukiwiki-view-setup-keys ()
  "Set up keymap for pukiwiki-edit-mode.
If you want to set up your own key bindings, use `pukiwiki-edit-mode-hook'."
  (local-set-key "q" 'pukiwiki-view-exit)
  (local-set-key "b" 'scroll-down)
  (local-set-key " " 'scroll-up)
  (local-set-key "B" 'pukiwiki-view-backward-page)
  (local-set-key "g" 'pukiwiki-view-goto-page)
  (local-set-key "c" 'pukiwiki-view-return-contents)
  (local-set-key "e" 'pukiwiki-view-edit-current-page)
  (local-set-key "\C-m" 'pukiwiki-view-return-function)
  (local-set-key "\C-i" 'pukiwiki-jump-anchor)
  (local-set-key "\M-\C-i" 'pukiwiki-jump-anchor-prev)
  (local-set-key "\C-xv=" 'pukiwiki-index-show-diff)
  (local-set-key "n" 'pukiwiki-jump-anchor-window-top)
  (local-set-key "p" 'pukiwiki-jump-anchor-window-top-prev)
  (local-set-key "s" 'pukiwiki-view-local-style-set)
  )

(defun pukiwiki-view-exit ()
  "$B8=:_%Z!<%8$rGK4~$7$F%$%s%G%C%/%9$r99?7$9$k!#(B"
  (interactive)
  (pukiwiki-diff-exit)

  (let ((pos (point))
        (top (window-start)))
    (pukiwiki-index pukiwiki-site-info nil pukiwiki-pagename)
    (goto-char pos)
    (set-window-start (selected-window) top)))

(defun pukiwiki-view-edit-current-page ()
  "$B8=:_9T$N%Z!<%8$rJT=8$9$k!#(B"
  (interactive)
  (when (and
         pukiwiki-pagename
         pukiwiki-site-info)
    (let ((buf (pukiwiki-edit-page pukiwiki-pagename pukiwiki-site-info)))
      (when buf (switch-to-buffer buf)))))

;;; $B0lMw%b!<%I(B(pukiwiki-index-*)
(make-variable-buffer-local 'pukiwiki-site-info)
(make-variable-buffer-local 'pukiwiki-index-page-info-list)
(make-variable-buffer-local 'pukiwiki-index-attach-list)
(make-variable-buffer-local 'pukiwiki-index-sort-key)
(define-derived-mode pukiwiki-index-mode text-mode "Pukiwiki Index"
  "Major mode for Pukiwiki index.

\\{pukiwiki-index-mode-map}"
  (make-local-variable 'pukiwiki-site-info)
  (make-local-variable 'pukiwiki-index-page-info-list)
  ;; InterWikiName
  (make-local-variable 'pukiwiki-index-interwiki-info-list)

  (make-local-variable 'pukiwiki-index-attach-list)
  (make-local-variable 'pukiwiki-index-sort-key)
  (pukiwiki-index-setup-keys)
  ;; hooks
  (progn
    (make-local-hook 'post-command-hook)
    (add-hook 'post-command-hook 'pukiwiki-index-post-command-function nil t)
    (make-local-hook 'pukiwiki-index-post-command-hook)
    (add-hook 'pukiwiki-index-post-command-hook
              (function
               (lambda ()
                 (pukiwiki-index-highlight-current-line)))
              nil t))
  (run-hooks 'pukiwiki-index-mode-hook))

(add-hook 'pukiwiki-index-mode-hook
          (function
           (lambda ()
             (make-local-variable 'font-lock-defaults)
             (setq font-lock-defaults
                   '(pukiwiki-index-font-lock-keywords
                     nil nil ((?_ . "w")) nil))
             (pukiwiki-mode-set-font-lock 'pukiwiki-index-mode)
             (if (fboundp 'turn-off-font-lock)
                 (turn-off-font-lock))
             (if (fboundp 'turn-on-font-lock)
                 (turn-on-font-lock)))))

(defun pukiwiki-index-post-command-function ()
  (run-hooks 'pukiwiki-index-post-command-hook))

(defun pukiwiki-index-highlight-current-line ()
  (progn
    (pukiwiki-index-highlight-on-current-line)))

(defun pukiwiki-index-highlight-on-current-line ()
  (let ((pos (point))
        star end)
    (unless (get-text-property (point) 'pukiwiki-current-line)
      (save-excursion
        ;; $B$3$l$^$G$N(B overlays $B$r0lA]$9$k!#(B
        (pukiwiki-index-highlight-off-current-line)
        ;; highlighi $B$9$k(B region $B$rFCDj$9$k!#(B
        (setq start (line-beginning-position))
        (setq end (if (= (line-end-position) (point-max))
                      (line-end-position)
                    (1+ (line-end-position))))

        ;; overlay set.
        (setq ovr-temp (make-overlay start end))
        (overlay-put ovr-temp 'face 'pukiwiki-index-current-line-face)
        (overlay-put ovr-temp 'pukiwiki-current-line t)
        (overlay-put ovr-temp 'priority 1)))))

(defun pukiwiki-index-highlight-off-current-line ()
  (let ((overlays (overlays-in (point-min) (point-max))))
    (while
        (setq ovr (prog1 (car overlays) (setq overlays (cdr overlays))))
      (when (overlay-get ovr 'pukiwiki-current-line)
        (delete-overlay ovr)))))

(defun pukiwiki-index-setup-keys ()
  "Set up keymap for pukiwiki-index-mode.
If you want to set up your own key bindings, use `pukiwiki-index-mode-hook'."
  (define-key pukiwiki-index-mode-map "?" 'pukiwiki-index-help)
  (define-key pukiwiki-index-mode-map "\r" 'pukiwiki-index-edit-page-current-line)
  (define-key pukiwiki-index-mode-map "e" 'pukiwiki-index-edit-page)
  (define-key pukiwiki-index-mode-map "." 'pukiwiki-index-display-page)
  (define-key pukiwiki-index-mode-map " " 'pukiwiki-index-display-page-next)
  (define-key pukiwiki-index-mode-map "b" 'pukiwiki-index-display-page-prev)
  (define-key pukiwiki-index-mode-map "S" 'pukiwiki-index-sort)
  (define-key pukiwiki-index-mode-map "s" 'pukiwiki-index-sort)
  (define-key pukiwiki-index-mode-map "R" 'pukiwiki-index-refetch-index)
  (define-key pukiwiki-index-mode-map "q" 'pukiwiki-index-suspend)
  (define-key pukiwiki-index-mode-map "Q" 'pukiwiki-index-quit)
  (define-key pukiwiki-index-mode-map "B" 'pukiwiki-index-view-backward-page)
  (define-key pukiwiki-index-mode-map "n" 'pukiwiki-index-next-page)
  (define-key pukiwiki-index-mode-map "p" 'pukiwiki-index-prev-page)
  ;;(define-key pukiwiki-index-mode-map "j" 'pukiwiki-index-jump-chapter)
  (define-key pukiwiki-index-mode-map "j" 'pukiwiki-index-next-page)
  (define-key pukiwiki-index-mode-map "k" 'pukiwiki-index-prev-page)
  (define-key pukiwiki-index-mode-map "v" 'pukiwiki-index-view-page-by-browser)
  (define-key pukiwiki-index-mode-map "=" 'pukiwiki-index-show-diff)
  (define-key pukiwiki-index-mode-map ">" 'pukiwiki-index-end-of-buffer)
  (define-key pukiwiki-index-mode-map "<" 'pukiwiki-index-beginning-of-buffer)
  (define-key pukiwiki-index-mode-map "t=" 'pukiwiki-index-show-today-diff)
  (define-key pukiwiki-index-mode-map "/" 'pukiwiki-search)
  (define-key pukiwiki-index-mode-map "i" 'pukiwiki-index-isearch-article)
  (define-key pukiwiki-index-mode-map "ta" 'pukiwiki-index-show-today-changed))

(defun pukiwiki-index (&optional site-info refetch pagename)
  "$B0lMw%b!<%I$KF~$k!#(B

SITE-INFO $B$,;XDj$5$l$F$$$J$1$l$P!"%_%K%P%C%U%!$+$iFI$_9~$`!#(B
REFETCH $B$,(B nil $B$G$9$G$K%P%C%U%!$,B8:_$9$k$J$i!"(BHTTP GET $B$7$J$$!#(B"
  (interactive "P")
  (pukiwiki-initialize)
  (let (buf)
    ;; site-name input (if required)
    (when (null site-info)
      (setq site-info (pukiwiki-read-site-name)))
    (setq buf (pukiwiki-display-index site-info refetch pagename))
    (set-buffer buf)                    ; $B2hLL$,%A%iIU$/$N$GJQ99$7$^$7$?!#(B
    (pukiwiki-index-sort nil ?d)
    (unless pagename (delete-other-windows))))

(defun pukiwiki-index-url (str &optional refetch)
  "URL $B$r;XDj$7$F%$%s%G%C%/%9$rI=<($9$k!#(B"
  (interactive "sURL: ")
  (let (url pagename site-info)
    (or (string-match "^\\(http://.+\\)$" str)
        (error "Illegal URL. (%s)" str))
    (setq url (match-string 1 str))
    (setq site-info (list url url))
    (pukiwiki-initialize)
    (let (buf)
      ;; site-name input (if required)
      (setq buf (pukiwiki-display-index site-info refetch pagename))
      (switch-to-buffer buf)
      (pukiwiki-index-sort nil ?d)
      (unless pagename (delete-other-windows)))))

(defun pukiwiki-display-index (site-info &optional refetch pagename)
  "$B0lMw$rI=<($7!"%P%C%U%!$rJV$9!#(B

REFETCH $B$,(B nil $B$G4{$K%P%C%U%!$,B8:_$9$k$J$i!"(BHTTP GET $B$7$J$$!#(B
PAGENAME $B$KBP1~$7$?9T$,$"$l$P!"%+!<%=%k$r$=$3$K0\F0$9$k!#(B "
  (let ((old-buf (current-buffer))
        (buf (pukiwiki-index-get-buffer-create site-info)))
    (switch-to-buffer buf)
    (setq buffer-read-only nil)
    (erase-buffer)
    (when (or refetch (null pukiwiki-index-page-info-list))
      (setq pukiwiki-index-page-info-list nil)
      (message "Loading index list...")
      (setq pukiwiki-index-page-info-list
            (pukiwiki-fetch-index site-info))
      ;; InterWikiName
      (message "Loading InterWikiName list...")
      (setq pukiwiki-index-interwiki-info-list
            (pukiwiki-fetch-interwikiname site-info))

      (message "Loading attach list... (C-g for Cancel)")
      (condition-case err
          (setq pukiwiki-index-attach-list
                (pukiwiki-fetch-attach-index site-info))
        (quit
         (setq pukiwiki-index-attach-list nil))
        (error
         (setq pukiwiki-index-attach-list nil)))
      (message "Loading... done."))
    (mapcar (lambda (page-info)
              (insert (pukiwiki-index-page-info-string
                       page-info site-info)))
            pukiwiki-index-page-info-list)
    (set-buffer-modified-p nil)
    (pukiwiki-index-sort-by)
    (setq buffer-read-only t)
    (goto-char (point-min))
    (when pagename
      (dolist (elm pukiwiki-index-page-info-list)
        (when (string= (nth 1 elm) pagename)
          (re-search-forward (format "^%4d" (nth 0 elm)))
          (beginning-of-line)
          (recenter))))
    (set-buffer old-buf)                ; $B2hLL$,%A%iIU$/$N$GJQ99$7$^$7$?!#(B
    buf))

(defun pukiwiki-index-get-buffer-create (site-info)
  "$B0lMwI=<(MQ$N%P%C%U%!$rJV$9!#(B"
  (let ((buf-name (pukiwiki-index-buffer-name site-info)))
    (or (get-buffer buf-name)
        (progn
          (save-excursion
            (get-buffer-create buf-name)
            (set-buffer buf-name)
            (pukiwiki-index-mode)
            (setq pukiwiki-site-info site-info)
            (get-buffer buf-name))))))

(defun pukiwiki-index-page-info-string (page-info site-info)
  (let ((num (nth 0 page-info))
        (name (nth 1 page-info))
        (title (nth 2 page-info))
        (extra (nth 3 page-info)))
    (format "%4d %s %s %s\n" num
            (if (pukiwiki-page-buffer-name name site-info)
                "V" " ")
            (pukiwiki-prefix
             (concat title)
             pukiwiki-index-wiki-name)
            extra)))

(defun pukiwiki-index-display-page (&optional refetch)
  "$B8=:_9T$N%Z!<%8$rI=<($9$k!#(B

REFETCH $B$,(B nil $B$G$9$G$K%P%C%U%!$,B8:_$9$k$J$i!"(BHTTP GET $B$7$J$$!#(B"
  (interactive)
  (let ((point (point))
        (search-word pukiwiki-search-word)
        (page-info (pukiwiki-index-page-info-current-line))
        (site-info pukiwiki-site-info)
        (info-list pukiwiki-index-page-info-list)
        (attach-list pukiwiki-index-attach-list)
        (cbuf (current-buffer))
        pagename)
    (when page-info
      (setq pagename (nth 1 page-info))
      (delete-other-windows)
      (split-window nil 10)
      ;; $B2hLL$,%A%iIU$/$N$G30$7$F$_$^$7$?!#(B
      ;; (recenter t)
      (other-window 1)
      (pukiwiki-display-page pagename pukiwiki-site-info refetch)
      (pukiwiki-view-mode)
      (setq pukiwiki-prev-buffer nil)
      (setq pukiwiki-pagename pagename)
      (setq pukiwiki-site-info site-info)
      (setq pukiwiki-index-page-info-list info-list)
      (setq pukiwiki-index-attach-list attach-list)
      (condition-case err
          (if hi-lock-mode
              ()
            (hi-lock-mode 1))
        (error
         ()))
      (if (and
           search-word
           (functionp 'hi-lock-face-buffer))
          (hi-lock-face-buffer search-word 'region))

      ;; $BI=<(2hLL$r@07A(B
      (pukiwiki-view-reformating)

      (setq buffer-read-only t)
      (switch-to-buffer (current-buffer)) ; $B2hLL$,%A%iIU$/$N$GJQ99$7$^$7$?!#(B
      (other-window 1))
    (pukiwiki-index pukiwiki-site-info nil pagename)
    (switch-to-buffer cbuf)
    (goto-char point)
    (recenter)))

(defun pukiwiki-index-display-page-next (&optional refetch)
  "$B8=:_9T$N%Z!<%8$rI=<($9$k!#$9$G$KI=<($5$l$F$$$k;~$O%9%/%m!<%k$9$k!#(B

REFETCH $B$,(B nil $B$G$9$G$K%P%C%U%!$,B8:_$9$k$J$i!"(BHTTP GET $B$7$J$$!#(B"
  (interactive)
  (let ((page-info (pukiwiki-index-page-info-current-line))
        (old-win (selected-window))
        pagename buf win)
    (when page-info
      (setq pagename (nth 1 page-info))
      (setq buf (cdr (assoc
                      (list (pukiwiki-site-name pukiwiki-site-info)
                            pagename)
                      pukiwiki-page-buffer-alist)))
      (if (or (null buf) (null (setq win (get-buffer-window buf))))
          (pukiwiki-index-display-page refetch)
        (let ((other-window-scroll-buffer buf)
              (start (window-start win)))
          (scroll-other-window)
          ;; $B%9%/%m!<%k=PMh$J$$;~$O<!9T$K0\$k!#(B
          ;;   (when (= (window-start win) start)
          ;;     (forward-line)
          ;;     (pukiwiki-index-display-page refetch))
          )))))

(defun pukiwiki-index-display-page-prev (&optional refetch)
  "$B8=:_9T$N%Z!<%8$rI=<($9$k!#$9$G$KI=<($5$l$F$$$k;~$O%9%/%m!<%k$9$k!#(B

REFETCH $B$,(B nil $B$G$9$G$K%P%C%U%!$,B8:_$9$k$J$i!"(BHTTP GET $B$7$J$$!#(B"
  (interactive)
  (let ((page-info (pukiwiki-index-page-info-current-line))
        (old-win (selected-window))
        pagename buf win)
    (when page-info
      (setq pagename (nth 1 page-info))
      (setq buf (cdr (assoc (list (pukiwiki-site-name
                                   pukiwiki-site-info) pagename)
                            pukiwiki-page-buffer-alist)))
      (if (or (null buf) (null (setq win (get-buffer-window buf))))
          (pukiwiki-index-display-page refetch)
        (let ((other-window-scroll-buffer buf)
              (start (window-start win)))
          (scroll-other-window-down nil)
          ;; $B%9%/%m!<%k=PMh$J$$;~$O<!9T$K0\$k!#(B
          ;;   (when (= (window-start win) start)
          ;;     (forward-line)
          ;;     (pukiwiki-index-display-page refetch))
          )))))

(defun pukiwiki-index-edit-page-current-line ()
  "$B8=:_9T$N%Z!<%8$rJT=8$9$k!#(B"
  (interactive)
  (pukiwiki-index-edit-page
   (nth 1 (pukiwiki-index-page-info-current-line))))

(defun pukiwiki-index-edit-page (&optional pagename)
  "$B%Z!<%8$rJT=8$9$k!#(B"
  (interactive)
  (let ((index-buf (current-buffer))
        edit-buf start)
    (unless pagename
      (setq pagename
            (pukiwiki-read-pagename
             (nth 1 (pukiwiki-index-page-info-current-line))
             (pukiwiki-site-name))))
    (when (and pagename
               (setq edit-buf
                     (pukiwiki-edit-page pagename pukiwiki-site-info)))
      (switch-to-buffer index-buf)
      (delete-other-windows)
      (split-window nil 10)
      (setq start (window-start))
      (recenter)
      (pukiwiki-display-index pukiwiki-site-info nil pagename)
      (set-window-start (selected-window) start)
      (other-window 1)
      (switch-to-buffer edit-buf))))

(defun pukiwiki-index-page-info-current-line ()
  "$B8=:_9T$N%Z!<%8>pJs(B(list)$B$rJV$9!#(B"
  (let (num)
    (save-excursion
      (beginning-of-line)
      (re-search-forward "\\([0-9]+\\)" nil t nil)
      (setq num (match-string 1)))
    (cond
     (num (nth (1- (string-to-number num))
               pukiwiki-index-page-info-list))
     (t nil))))

(defun pukiwiki-index-page-info (pagename)
  "PAGENAME $B$N(B page-info $B$rJV$9!#CN$i$J$1$l$P(B nil$B!#(B"
  (let (result)
    (dolist (page-info pukiwiki-index-page-info-list)
      (when (string= (nth 1 page-info) pagename)
        (setq result page-info)))
    result))

(defun pukiwiki-index-refetch-index ()
  "$B0lMw$N:FFI$_9~$_$r9T$&!#(B"
  (interactive)
  (condition-case err
      (pukiwiki-index
       pukiwiki-site-info t
       (nth 1 (pukiwiki-index-page-info-current-line)))
    (error
     (pukiwiki-index pukiwiki-site-info t
                     ""))))

(defun pukiwiki-index-sort (&optional rev sortkey)
  "$B0lMw$N%=!<%H$r9T$&(B"
  (interactive "P")
  (message "Sorting...")
  (pukiwiki-index-sort-by
   (if sortkey
       sortkey
     (pukiwiki-read-char-with-retry
      "Sort by n)umber or d)ate? " nil '(?n ?d)))
   rev)
  (message "Sorting... done."))

(defun pukiwiki-index-suspend ()
  "pukiwiki-index $B$r0l;~CfCG$9$k!#(B"
  (interactive)
  (delete-other-windows)
  (dolist (elm pukiwiki-page-buffer-alist)
    (bury-buffer (cdr elm)))
  (replace-buffer-in-windows (current-buffer)))

(defun pukiwiki-index-quit ()
  "pukiwiki-index $B$r=*N;$9$k!#(B"
  (interactive)
  (let ((tmp pukiwiki-page-buffer-alist))
    (delete-other-windows)
    (dolist (elm pukiwiki-page-buffer-alist)
      (when (string= (nth 0 (car elm)) (pukiwiki-site-name))
        (kill-buffer (cdr elm))
        (setq tmp (remassoc (car elm) tmp))))
    (setq pukiwiki-page-buffer-alist tmp)
    (kill-buffer (current-buffer))))

(defun pukiwiki-index-next-page (arg)
  (interactive "P")
  (if arg
      (next-line arg)
    (next-line 1))
  (pukiwiki-index-display-page))

(defun pukiwiki-index-prev-page (arg)
  (interactive "P")
  (if arg
      (pukiwiki-index-next-page (* -1 arg))
    (pukiwiki-index-next-page -1)))

(defun pukiwiki-index-jump-chapter ()
  (interactive)
  (pukiwiki-index-display-page-next)
  (let ((page-info (pukiwiki-index-page-info-current-line))
        pagename buf chap)
    (when page-info
      (setq pagename (nth 1 page-info))
      (setq buf (cdr (assoc
                      (list (pukiwiki-site-name pukiwiki-site-info)
                            pagename)
                      pukiwiki-page-buffer-alist)))
      (set-buffer buf)
      (goto-char (point-min))
      (re-search-forward "^#contents" nil t)
      (setq chap
            (read-from-minibuffer
             "$B%8%c%s%W$9$k>OHV8e$rF~NO(B: "))
      (goto-char (point-min))
      (if (= 0 (length chap))
          (setq chap "1"))
      (if (re-search-forward
           (concat "^[*]+[ ]*" chap) nil t)
          ()
        (re-search-forward "^[*]+" nil t)))))

(defun pukiwiki-index-view-page-by-browser (arg)
  (interactive "P")
  (let ((pagename
         (nth 1 (pukiwiki-index-page-info-current-line))))
    (if (functionp pukiwiki-browser-function)
        (funcall pukiwiki-browser-function
                 (format "%s?%s" (pukiwiki-site-url)
                         (http-url-hexify-string pagename
                                                 (pukiwiki-site-coding-system))))
      (browse-url
       (format "%s?%s" (pukiwiki-site-url)
               (http-url-hexify-string pagename
                                       (pukiwiki-site-coding-system)))))))

(defun pukiwiki-replace-regexp (regexp replacement delimited start end)
  "pukiwiki-mode $BMQ$N(B replace-regexp.

start $B$G;XDj$5$l$?0LCV$+$i(B end $B$G;XDj$5$l$?0LCV$^$G$K=P8=$9$kA4$F$N(B regexp
$B$K%^%C%A$9$kJ8;zNs$r(B replacement $B$KCV49$7$^$9!#(B
delimited $B$O8_49$N$?$a$@$1$K0z?t$H$7$FB8:_$7!";XDj$5$l$?FbMF$OL5;k$5$l$^$9!#(B"

  (let ((top start) (bottom end))
    (goto-char top)
    (catch 'range-over
      (while (setq result (re-search-forward regexp bottom t))
        (replace-match replacement nil nil)
        (setq bottom (+ bottom (- (point) result)))
        (if (>= (point) bottom)         ; replace-match $B$G(B point $B$,(B bottom
            ; $B$h$j$b@h$K?J$s$@;~$b(B 'range-over.
            (throw 'range-over t)))
      (cond ((>= (point) bottom)        ; point $B$,(B bottom $B$r1[$($?!#(B
             (throw 'range-over t))
            ((eq result nil)            ; $B$b$&(B match $B$7$J$+$C$?!#(B
             (throw 'range-over t))))))

(defun pukiwiki-replace-string (regexp replacement delimited start end)
  "pukiwiki-mode $BMQ$N(B replace-string.

start $B$G;XDj$5$l$?0LCV$+$i(B (point-max) $B$^$G$K=P8=$9$kA4$F$N(B regexp $B$K%^%C%A(B
$B$9$kJ8;zNs$r(B replacement $B$KCV49$7$^$9!#(B
delimited, end $B$O8_49$N$?$a$@$1$K0z?t$H$7$FB8:_$7!";XDj$5$l$?FbMF$OL5;k(B
$B$5$l$^$9!#(B"

  (let ((top start) (bottom end))
    (goto-char top)
    (if (and (featurep 'xemacs) (region-active-p))
        (zmacs-deactivate-region))
    (perform-replace regexp replacement nil nil nil)))

(defun pukiwiki-index-show-diff-ediff (url pagename site-info &optional day)
  (message "Ediff session...")

  ;; $B:G?7%P%C%/%"%C%W$N%=!<%9$r<hF@$7!"%P%C%U%!$r@8@.!#(B
  (setq backup-buffername (concat " *pukiwiki backup tmp*"))
  (let* ((backup t)
         (url (progn (string-match "nowdiff" url)
                     (replace-match "source" nil nil url))))
    (pukiwiki-diff-ediff-create-buffer
     url pagename site-info backup-buffername backup))

  ;; $B8=:_$N%=!<%9$r<hF@$7!"%P%C%U%!$r@8@.!#(B
  (setq current-buffername (concat " *pukiwiki current tmp*"))
  (let* ((url (progn
                (string-match
                 "cmd=backup\\(.*\\)&age=[0-9]*&action=nowdiff" url)
                (replace-match "cmd=edit\\1" nil nil url))))
    (pukiwiki-diff-ediff-create-buffer
     url pagename site-info current-buffername))

  (ediff-buffers backup-buffername current-buffername)
  (message "Ediff session... done."))

(defun pukiwiki-diff-ediff-create-buffer (url pagename site-info
                                              buffername
                                              &optional backup day)
  (let ((raw backup))
    (setq contents (pukiwiki-fetch-source pagename url
                                          (pukiwiki-site-coding-system site-info) raw))
    (setq buf (get-buffer-create buffername))
    (switch-to-buffer buf)
    (setq buffer-read-only nil)
    (erase-buffer)
    (insert (cdr (assoc 'body contents)))

    (pukiwiki-view-delete-html-tag)
    (pukiwiki-replace-entity-refs)
    (pukiwiki-view-mode)

    (setq pukiwiki-pagename pagename)
    (setq pukiwiki-site-info site-info)

    ;; $B@07A=hM}(B
    (pukiwiki-view-reformating t)

    (setq buffer-read-only t)))

(defun pukiwiki-index-show-diff (arg &optional day use-ediff apagename)
  "$B8=:_$N%P%C%U%!$H%5!<%P$N%G!<%?$rHf3S$7!"I=<($9$k!#(B"
  (interactive "P")
  (let* ((cbuf (current-buffer))
         (pagename
          (if apagename
              apagename
            (if (string= major-mode 'pukiwiki-index-mode)
                (nth 1 (pukiwiki-index-page-info-current-line))
              pukiwiki-pagename)))
         (url nil)
         (age-last "1")
         (age "1")
         (site-info pukiwiki-site-info)
         (diff-index
          (format "%s?cmd=backup&page=%s"
                  (pukiwiki-site-url)
                  (http-url-hexify-string
                   pagename
                   (pukiwiki-site-coding-system site-info))))
         (site-url (pukiwiki-site-url))
         (diff-contents nil)
         (site-name (car pukiwiki-site-info))
         buf)
    (message "Checking backup...")
    (setq buf (pukiwiki-http-request
               'raw "edit" pagename diff-index
               (pukiwiki-site-coding-system site-info)))
    (when buf
      (set-buffer buf)
      (goto-char (point-max))
      (cond
       (day
        (let ((time
               (format-time-string "20%y-%02m-%02d"
                                   (pukiwiki-date-convert day))))
          (goto-char (point-min))
          (if (re-search-forward
               (concat
                "age=[^(\n\r>]+>\\([0-9]+\\)[ ]*("
                time) nil t)
              (setq age-last
                    (buffer-substring-no-properties
                     (match-beginning 1) (match-end 1)))
            (goto-char (point-max))
            (if (re-search-backward
                 "http://[^\n\r]+age=\\([0-9]+\\)\"" nil t)
                (setq age-last
                      (number-to-string
                       (+ (string-to-number
                           (buffer-substring-no-properties
                            (match-beginning 1) (match-end 1)))
                          1)))))
          (if (< (string-to-number age-last) 2)
              (setq age-last "1")
            (setq age-last
                  (number-to-string (- (string-to-number age-last) 1))))))
       (t
        (if (re-search-backward
             "http://[^\n\r]+age=\\([0-9]+\\)\"" nil t)
            (setq age-last
                  (buffer-substring-no-properties
                   (match-beginning 1) (match-end 1)))))))
    (if arg
        (setq age (read-from-minibuffer
                   (format "Diff to (Default %s) : " age-last)
                   nil nil nil nil age-last t))
      (setq age age-last))
    (if (= (string-to-number age) 0)
        (setq age age-last))
    (setq url
          (format "%s?cmd=backup&page=%s&age=%s&action=nowdiff"
                  site-url
                  (http-url-hexify-string pagename
                                          (pukiwiki-site-coding-system site-info))
                  age))

    (if (and (or (eq day nil)
                 use-ediff)
             pukiwiki-diff-using-ediff
             (condition-case nil (require 'ediff) (error nil)))
        ;; Ediff $B$,$"$l$P!#(B
        (pukiwiki-index-show-diff-ediff url pagename site-info)

      (message "Creating diff...")
      (setq diff-contents (pukiwiki-fetch-source
                           pagename url
                           (pukiwiki-site-coding-system site-info) t))
      (setq buf (generate-new-buffer "*pukiwiki tmp*"))
      (switch-to-buffer buf)
      (pukiwiki-edit-rename-buffer
       site-name pagename (format "diff-to-%s" age) nil)
      (insert (cdr (assoc 'body diff-contents)))
      (pukiwiki-replace-regexp
       "^ $" "" nil (point-min) (point-max))
      (pukiwiki-replace-string
       "<span class=\"diff_added\">" "+" nil (point-min) (point-max))
      (pukiwiki-replace-string
       "<span class=\"diff_removed\">" "-" nil (point-min) (point-max))
      (pukiwiki-replace-string
       "</span>" "" nil (point-min) (point-max))
      (goto-char (point-min))
      (pukiwiki-replace-entity-refs)
      (setq pukiwiki-prev-buffer cbuf)
      (pukiwiki-diff-mode)
      (set-buffer-modified-p nil)
      ;;(view-mode)
      (delete-other-windows)
      (goto-char (point-min))
      (message "Creating diff... done!"))))

(defun pukiwiki-index-end-of-buffer ()
  (interactive)
  (pukiwiki-index-display-page)
  (end-of-buffer-other-window nil))

(defun pukiwiki-index-beginning-of-buffer ()
  (interactive)
  (pukiwiki-index-display-page)
  (beginning-of-buffer-other-window nil))

(defun pukiwiki-index-isearch-article (&optional regexp-p)
  "Do incremental search forward on the current article.
If REGEXP-P (the prefix) is non-nil, do regexp isearch."
  (interactive "P")
  (let ((page-info (pukiwiki-index-page-info-current-line))
        (old-win (selected-window))
        pagename buf win)
    (when page-info
      (setq pagename (nth 1 page-info))
      (setq buf (cdr (assoc
                      (list (pukiwiki-site-name pukiwiki-site-info)
                            pagename)
                      pukiwiki-page-buffer-alist)))
      (when (or (null buf) (null (setq win (get-buffer-window buf))))
        (pukiwiki-index-display-page nil)
        (setq buf (cdr (assoc
                        (list (pukiwiki-site-name pukiwiki-site-info)
                              pagename)
                        pukiwiki-page-buffer-alist))))
      (pukiwiki-eval-in-buffer-window
       buf
       (save-restriction
         (widen)
         (goto-char (point-min))
         (isearch-forward regexp-p))))))

(defun pukiwiki-index-help ()
  (interactive)
  (with-output-to-temp-buffer "*Pukiwiki help*"
    (set-buffer standard-output)
    (princ
     (concat
      "* $BI,MW$J$b$N$H4pK\E*$J@_Dj(B\n"
      "\n"
      "$B%Y!<%9$H$J$C$?(B hiki-mode $BF1MM!$(Btdiary-mode $BIUB0$N(B http.el $B$,I,MW$G$9!%(B\n"
      "$B$^$?!$>WFM;~$K(B diff $B$r;HMQ$7$F$$$^$9$N$G!$(BCygwin $B$,I,MW$G$9!%(B\n"
      "\n"
      "- hiki-mode\n"
      "  http://yowaken.dip.jp/hiki/hiki.cgi?hiki-mode.el\n"
      "- http.el\n"
      "  http://cvs.sourceforge.net/viewcvs.py/tdiary/contrib/util/tdiary-mode/http.el\n"
      "\n"
      "$B@_Dj$O(B\n"
      "\n"
      " (load-library \"pukiwiki-mode\")\n"
      "\n"
      "$B$G;H$&$3$H$,$G$-$^$9!%(B\n"
      "\n"
      "$B%5%$%H$rDI2C$9$k>l9g$K$O(B\n"
      "\n"
      " (setq pukiwiki-site-list\n"
      "        '((\"Meadow\" \"http://www.bookshelf.jp/pukiwiki/pukiwiki.php\" nil euc-jp-dos)\n"
      "          (\"macemacs\" \"http://macemacsjp.sourceforge.jp/index.php\" nil euc-jp-dos)\n"
      "          (\"Xyzzy\" \"http://xyzzy.s53.xrea.com/wiki/wiki.php\" nil euc-jp-dos)\n"
      "          (\"Pukiwiki\" \"http://pukiwiki.org/index.php\" nil utf-8-dos)\n"
      "          ))\n"
      "\n"
      "$B$N$h$&$K@_Dj$7$^$9!%(B\n"
      "\n"
      "* $B;H$$J}(B\n"
      "\n"
      "** $B4pK\E*$J;H$$J}(B\n"
      "\n"
      "$B4pK\E*$K$O(B hiki-mode $B$HF1$8$G$9(B\n"
      "\n"
      "M-x pukiwiki-edit\n"
      "\n"
      " $B@_Dj$7$F$*$$$?%5%$%H$rJT=8$9$k(B\n"
      "\n"
      "M-x pukiwiki-edit-url\n"
      "\n"
      " $B;XDj$7$?(B URL $B$rJT=8$9$k(B\n"
      "\n"
      "M-x pukiwiki-index\n"
      "\n"
      " $B@_Dj$7$F$*$$$?%5%$%H$N%Z!<%80lMw$rI=<($9$k(B\n"
      "\n"
      "*** $BJT=8%b!<%I(B\n"
      "\n"
      "M-x pukiwiki-edit$B$d(BM-x pukiwiki-edit-url$B$G%Z!<%8$NJT=8$K$J$j$^$9!%IaDL$KJT=8$7$F(B\n"
      "$B$$$-$^$9!%(B\n"
      "\n"
      "$B%-!<%P%$%s%I$O0J2<$NDL$j$G$9!%(B\n"
      "\n"
      "C-cC-q\n"
      "\n"
      " $B%-%c%s%;%k(B\n"
      "\n"
      "C-cC-c\n"
      "\n"
      " $B%Z!<%8$N99?7(B\n"
      "\n"
      "$B99?7$,>WFM$9$k$H%(%i!<$K$J$j$^$9!%$I$3$,>WFM$7$F$$$k$N$+$,JL%P%C%U%!$KI=<($5$l$^(B\n"
      "$B$9$N$G!$$=$l$r3NG'$7$F:FJT=8$r9T$$$^$9!%LdBj$J$1$l$PJT=8Cf$N%P%C%U%!$G:FEY(B \n"
      "C-cC-c $B$H$9$k$H!$$=$N$^$^%"%C%W$G$-$^$9!%(B\n"
      "\n"
      "C-cC-p\n"
      "\n"
      " $B%W%l%S%e!<(B\n"
      "\n"
      "C-cC-e\n"
      "\n"
      " M-x pukiwiki-edit $B$N<B9T(B\n"
      "\n"
      "C-cC-r\n"
      "\n"
      " $B%Z!<%8$NJQ99$rGK4~$7$F:FJT=8$r9T$&(B\n"
      "\n"
      "C-xv=\n"
      "\n"
      " $B:G6a$NJQ992U=j$rI=<((B\n"
      "\n"
      "\n"
      "$B$^$?!$JT=8%b!<%I$G2<@~$,0z$+$l$?J8;z$N>e$G(BRET$B$H$9$k$H!$$=$N%Z!<%8$rJT=8$G$-$^$9!%(B\n"
      "\n"
      "*** $B%$%s%G%C%/%9%b!<%I(B\n"
      "\n"
      "M-x pukiwiki-edit$B$G99?7$d%-%c%s%;%k$r9T$C$?$j!$(BM-x pukiwiki-index $B$r9T$&$H%Z!<%8(B\n"
      "$B$N0lMw$,I=<($5$l$^$9!%(B\n"
      "\n"
      "$BNc$($P(B\n"
      "\n"
      "  107   Meadow memo Wiki/2004-02-26                        04/02/26\n"
      "  118   Sand2                                              04/02/26\n"
      "  179 V $B%"%$%G%"=8(B/pukiwiki-mode                           04/02/26\n"
      "  196 V $B%3%a%s%H(B/flash$B$N:n$jJ}(B                             04/02/26\n"
      "  247   $B5/F0B.EY$rBgI}$K%"%C%W(B! -- idledo.el               04/02/26\n"
      "\n"
      "$B$N$h$&$KI=<($5$l$^$9!%(B\n"
      "\n"
      "$B%$%s%G%C%/%9$G$O0J2<$N$h$&$J%-!<%P%$%s%I$rMxMQ$G$-$^$9!%(B\n"
      "\n"
      "i\n"
      "\n"
      " $B8=:_%Z!<%8$r(Bisearch$B$9$k(B\n"
      "\n"
      "/\n"
      "\n"
      " $BA4%Z!<%8$r8!:w$9$k(B\n"
      "\n"
      ".\n"
      "\n"
      " $B%Z!<%8$rI=<($9$k(B\n"
      "\n"
      "SPC\n"
      "\n"
      " $B%Z!<%8$rI=<($9$k!%$9$G$KI=<($5$l$F$$$?$i%9%/%m!<%k$9$k(B\n"
      "\n"
      "b\n"
      "\n"
      " $B%Z!<%8$rI=<($9$k!%$9$G$KI=<($5$l$F$$$?$i5UJ}8~$K%9%/%m!<%k$9$k(B\n"
      "\n"
      "<\n"
      "\n"
      " $BI=<($7$F$$$k%Z!<%8$N@hF,$rI=<($9$k(B\n"
      "\n"
      "\n"
      "  \n"
      "\n"
      " $BI=<($7$F$$$k%Z!<%8$N:G8e$rI=<($9$k(B\n"
      "\n"
      "n\n"
      "\n"
      " $B<!$N%Z!<%8$rI=<($9$k(B\n"
      "\n"
      "j\n"
      "\n"
      " $B<!$N%Z!<%8$rI=<($9$k(B\n"
      "\n"
      "p\n"
      "\n"
      " $BA0$N%Z!<%8$rI=<($9$k(B\n"
      "\n"
      "k\n"
      "\n"
      " $BA0$N%Z!<%8$rI=<($9$k(B\n"
      "\n"
      "v\n"
      "\n"
      " $B%Z!<%8$r%V%i%&%6$GI=<($9$k(B\n"
      "\n"
      "Q\n"
      "\n"
      " $B%$%s%G%C%/%9$r=*N;$9$k(B\n"
      "\n"
      "q\n"
      "\n"
      " $B%$%s%G%C%/%9$r8e$m$X1#$9(B\n"
      "\n"
      "s\n"
      "\n"
      " $B;~4V$dL>A0$G%=!<%H$9$k(B\n"
      "\n"
      "S\n"
      "\n"
      " $B;~4V$dL>A0$G%=!<%H$9$k(B\n"
      "\n"
      "R\n"
      "\n"
      " $B%$%s%G%C%/%9$r99?7$9$k(B\n"
      "\n"
      "e\n"
      "\n"
      " M-x pukiwiki-edit $B$HF1$8$@$,!$=i4|CM$O8=:_%+!<%=%k$,$"$k9T$N%Z!<%8$K$J$k(B\n"
      "\n"
      "RET\n"
      "\n"
      " $B%Z!<%8$rJT=8$9$k(B\n"
      "\n"
      "=\n"
      "\n"
      " $B:G6aJQ99$5$l$?2U=j$rI=<($9$k(B\n"
      "\n"
      "$B$?$@$7!$%P%C%/%"%C%W$H$N:9J,$J$N$G!$%V%i%&%6$G:9J,$rI=<($5$;$?;~$N$b$N$H$O0[$J$j(B\n"
      "$B$^$9(B($BO"B3$7$FJQ99$5$l$?;~$J$I$N>l9g!$:9J,$r8+$k$h$j$b%P%C%/%"%C%W$H$N:9J,$NJ}$r(B\n"
      "$B8+$?J}$,$$$$$?$a(B)$B!%(B\n"
      "\n"
      "t a\n"
      "\n"
      " $BJQ992U=j$rA4%Z!<%8$^$H$a$FI=<($9$k(B\n"
      "\n"
      "\n"
      "$B%+!<%=%k$N$"$k9T$HF1$8F|$KJQ99$5$l$?%Z!<%8$NJQ992U=j$r$^$H$a$FI=<($7$^$9!%(B\n"
      "\n"
      "t =\n"
      "\n"
      " $B:#F|JQ99$5$l$?2U=j$rI=<((B($B8=:_%+!<%=%k$,$"$k>l=j$N%Z!<%8$N$_$,BP>]!%%j!<%8%g(B\n"
      " $B%s$,M-8z$J$i%j!<%8%g%s4V$N%Z!<%8$,BP>]!%(B)\n"
      "\n"
      "\n"
      "*** $BI=<(%b!<%I(B\n"
      "\n"
      "$B%$%s%G%C%/%9$+$i%9%Z!<%9%-!<$J$I$GI=<($9$k$HI=<(%b!<%I$K$J$k!%$H$$$C$F(B\n"
      "$B$bFCJL$J5!G=$OA4$/$J$$!%E:IU%U%!%$%k$N%U%!%$%kL>$N$"$k9T$G%j%?!<%s%-!<(B\n"
      "$B$rF~NO$9$k$H!$E:IU%U%!%$%k$rI=<($G$-$k!%$?$@$7!$E:IU%U%!%$%k$r%@%&%s%m!<(B\n"
      "$B%I$7$F!$(Bfind-file $B$G3+$$$F$$$k$@$1$J$N$G!$%P%$%J%j%U%!%$%k$O3+$$$F$b0U(B\n"
      "$BL#$,$J$$!%(B\n"
      "\n"
      "$B$D$$$G$K!$(B\n"
      "\n"
      " (setq pukiwiki-auto-insert t)\n"
      "\n"
      "$B$H$J$C$F$$$k$H!$$h$_$d$9$$$h$&$K3F<o$N@07A$r9T$$$^$9!%(B\n"
      "\n"
      "$B%G%U%)%k%H$G$O(B\n"
      "\n"
      "- $BE:IU%U%!%$%k$N0lMw$rI=<((B\n"
      "- $BL\<!$rF~NO(B\n"
      "\n"
      "$B$N$_$r9T$$$^$9!%(B\n"
      "\n"
      "*** $B:9J,%b!<%I(B\n"
      "\n"
      "$B%$%s%G%C%/%9$+$i(B=$B$J$I$G:9J,$rI=<($9$k$H:9J,%b!<%I$K$J$j$^$9!%BP$7$?5!G=$OL5$$$G(B\n"
      "$B$9$,!$0J2<$N%-!<$,MxMQ$G$-$^$9!%(B\n"
      "\n"
      "SPC\n"
      "\n"
      " $B%9%/%m!<%k(B\n"
      "\n"
      "b\n"
      "\n"
      " $B5UJ}8~$K%9%/%m!<%k(B\n"
      "\n"
      "q\n"
      "\n"
      " $B=*N;(B\n"
      "\n"
      "M-n\n"
      "\n"
      " $B<!$NJQ992U=j$X%8%c%s%W(B\n"
      "\n"
      "M-p\n"
      "\n"
      " $BA0$NJQ992U=j$X%8%c%s%W(B\n"
      "\n"
      "view-mode $B$J$N$G!$(Bview-mode $B$N5!G=$bMxMQ$G$-$^$9!%(B\n"
      "\n"
      "*** $B$3$s$J;~$O$I$&$9$k!)(B\n"
      "\n"
      "$B%Z!<%8$N:o=|(B\n"
      "\n"
      " $BFbMF$r6u$K$7$^$9(B\n"
      "\n"
      "$B%Z!<%8$N?75,:n@.(B\n"
      "\n"
      " M-x pukiwiki-edit$B$GB8:_$7$J$$%Z!<%8$r;XDj$9$k!%8G$^$k;~$b$"$k!%(B\n"
      "\n"))))

(defmacro pukiwiki-eval-in-buffer-window (buffer &rest forms)
  (let ((tempvar (make-symbol "PWStartBufferWindow"))
        (w (make-symbol "w"))
        (buf (make-symbol "buf"))
        (frame (make-symbol "frame")))
    `(let* ((,tempvar (selected-window))
            (,buf ,buffer)
            (,w (get-buffer-window ,buf 'visible))
            ,frame)
       (unwind-protect
           (progn
             (if ,w
                 (progn
                   (select-window ,w)
                   (set-buffer (window-buffer ,w)))
               (pop-to-buffer ,buf))
             ,@forms)
         (setq ,frame (selected-frame))
         (select-window ,tempvar)
         (select-frame ,frame)))))

;;; $B8!:wMQ4X?t(B ($B$^$@L$40(B)
(define-derived-mode pukiwiki-search-mode text-mode "Pukiwiki Search"
  "Major mode for Pukiwiki index.

\\{pukiwiki-index-mode-map}"
  (make-local-variable 'pukiwiki-site-info)
  (make-local-variable 'pukiwiki-index-page-info-list)
  (make-local-variable 'pukiwiki-index-attach-list)
  (make-local-variable 'pukiwiki-index-sort-key)
  (pukiwiki-search-setup-keys)
  (run-hooks 'pukiwiki-search-mode-hook))

(defun pukiwiki-search-setup-keys ()
  "Set up keymap for pukiwiki-index-mode.
If you want to set up your own key bindings, use `pukiwiki-search-mode-hook'."
  (define-key pukiwiki-search-mode-map "\r" 'pukiwiki-index-edit-page-current-line)
  (define-key pukiwiki-search-mode-map "e" 'pukiwiki-index-edit-page)
  (define-key pukiwiki-search-mode-map "." 'pukiwiki-index-display-page)
  (define-key pukiwiki-search-mode-map " " 'pukiwiki-index-display-page-next)
  (define-key pukiwiki-search-mode-map "b" 'pukiwiki-index-display-page-prev)
  (define-key pukiwiki-search-mode-map "S" 'pukiwiki-index-sort)
  (define-key pukiwiki-search-mode-map "s" 'pukiwiki-index-sort)
  (define-key pukiwiki-search-mode-map "R" 'pukiwiki-index-refetch-index)
  (define-key pukiwiki-search-mode-map "q" 'pukiwiki-search-quit)
  (define-key pukiwiki-search-mode-map "Q" 'pukiwiki-search-quit)
  (define-key pukiwiki-search-mode-map "n" 'pukiwiki-index-next-page)
  (define-key pukiwiki-search-mode-map "p" 'pukiwiki-index-prev-page)
  ;;(define-key pukiwiki-search-mode-map "j" 'pukiwiki-index-jump-chapter)
  (define-key pukiwiki-search-mode-map "j" 'pukiwiki-index-next-page)
  (define-key pukiwiki-search-mode-map "k" 'pukiwiki-index-prev-page)
  (define-key pukiwiki-search-mode-map "v" 'pukiwiki-index-view-page-by-browser)
  (define-key pukiwiki-search-mode-map "=" 'pukiwiki-index-show-diff)
  (define-key pukiwiki-search-mode-map ">" 'pukiwiki-index-end-of-buffer)
  (define-key pukiwiki-search-mode-map "<" 'pukiwiki-index-beginning-of-buffer)
  (define-key pukiwiki-search-mode-map "t=" 'pukiwiki-index-show-today-diff)
  (define-key pukiwiki-search-mode-map "/" 'pukiwiki-search)
  (define-key pukiwiki-index-mode-map "i" 'pukiwiki-index-isearch-article)
  (define-key pukiwiki-search-mode-map "ta" 'pukiwiki-index-show-today-changed))

(defun pukiwiki-search-quit ()
  (interactive)
  (delete-other-windows)
  (kill-buffer (current-buffer))
  (switch-to-buffer (pukiwiki-index-buffer-name pukiwiki-site-info)))

(defun pukiwiki-fetch-search (&optional site-info)
  (interactive "P")
  (let (buf contents post-data pagetitle password freeze keywords result
            (pbuf (current-buffer)) (indexes nil)
            (search-word nil) (i 1) (lst nil))
    (message "Sending... ")
    (setq search-word
          (read-from-minibuffer
           "$B8!:w8l$rF~NO(B: "))
    (setq pagetitle pukiwiki-pagename)

    (add-to-list 'post-data (cons "encode_hint" "$B$W(B"))
    (add-to-list 'post-data (cons "word" search-word))
    (add-to-list 'post-data (cons "type" "AND"))
    (setq buf
          (pukiwiki-http-request 'search nil ""
                                 (pukiwiki-site-url site-info)
                                 (pukiwiki-site-coding-system site-info)
                                 post-data))

    (setq lst (split-string search-word " "))
    (setq search-word (concat
                       "\\(" (car lst)))
    (setq lst (cdr lst))
    (while lst
      (setq search-word
            (concat search-word
                    "\\|"
                    (car lst)))
      (setq lst (cdr lst)))
    (setq search-word (concat
                       search-word "\\)"))

    (setq pukiwiki-post-data post-data)
    (when (bufferp buf)
      (save-excursion
        (set-buffer buf)
        (goto-char (point-min))
        (while (re-search-forward
                "<li><a[^?]*\\?cmd=read&amp;page=\\([^\"]*\\)&amp;word=[^\"]*\"[^>]*>\\([^\n\r]*\\)</a>[ ]*\\([^<\n\r]*\\)" nil t)
          (setq indexes
                (cons
                 (list i (http-url-unhexify-string
                          (match-string 1)
                          (pukiwiki-site-coding-system site-info))
                       ;;(pukiwiki-replace-entity-refs (match-string 2))
                       (http-url-unhexify-string
                        (match-string 1)
                        (pukiwiki-site-coding-system site-info))
                       (pukiwiki-replace-entity-refs
                        (format-time-string
                         "%y/%m/%d"
                         (pukiwiki-index-date (match-string 3)))))
                 indexes))
          (setq i (1+ i)))))
    (cons search-word (reverse indexes))))

(defun pukiwiki-search-buffer-name (&optional site-info)
  (format "Pukiwiki search <%s>" (pukiwiki-site-name site-info)))

(defun pukiwiki-search-get-buffer-create (site-info)
  "$B0lMwI=<(MQ$N%P%C%U%!$rJV$9!#(B"
  (let ((buf-name (pukiwiki-search-buffer-name site-info)))
    (or (get-buffer buf-name)
        (progn
          (save-excursion
            (get-buffer-create buf-name)
            (set-buffer buf-name)
            (pukiwiki-search-mode)
            (setq pukiwiki-site-info site-info)
            (get-buffer buf-name))))))

(defun pukiwiki-search-index (site-info)
  "$B0lMw$rI=<($7!"%P%C%U%!$rJV$9!#(B

REFETCH $B$,(B nil $B$G4{$K%P%C%U%!$,B8:_$9$k$J$i!"(BHTTP GET $B$7$J$$!#(B
PAGENAME $B$KBP1~$7$?9T$,$"$l$P!"%+!<%=%k$r$=$3$K0\F0$9$k!#(B "
  (let ((old-buf (current-buffer))
        (buf (pukiwiki-search-get-buffer-create site-info))
        (site-info pukiwiki-site-info)
        (info-list pukiwiki-index-page-info-list)
        (attach-list pukiwiki-index-attach-list)
        lst)
    (switch-to-buffer buf)
    (setq buffer-read-only nil)
    (erase-buffer)
    (message "Loading...")
    (make-local-variable 'pukiwiki-search-word)
    (condition-case err
        (setq lst (pukiwiki-fetch-search site-info))
      (error
       (setq lst 'error)))
    (when (or
           (and (not (listp lst))
                (string= lst 'error)))
      (pukiwiki-search-quit)
      (error "$B%?%$%`%"%&%H$7$^$7$?!%(B"))
    (setq pukiwiki-search-word (car lst))
    (setq lst (cdr lst))
    (when (not lst)
      (pukiwiki-search-quit)
      (error "$B8+$D$+$j$^$;$s$G$7$?!%(B"))
    (setq pukiwiki-site-info site-info)
    (setq pukiwiki-index-page-info-list lst)
    (setq pukiwiki-index-attach-list attach-list)
    (make-local-variable 'pukiwiki-index-sort-key)
    (message "Loading... done.")
    (setq pukiwiki-search-list lst)
    (mapcar (lambda (page-info)
              (insert (pukiwiki-index-page-info-string
                       page-info site-info)))
            lst)
    (set-buffer-modified-p nil)
    (pukiwiki-index-sort-by)
    (setq buffer-read-only t)
    (goto-char (point-min))
    (switch-to-buffer old-buf)
    buf))

(defun pukiwiki-search ()
  "$B0lMw%b!<%I$KF~$k!#(B

SITE-INFO $B$,;XDj$5$l$F$$$J$1$l$P!"%_%K%P%C%U%!$+$iFI$_9~$`!#(B
REFETCH $B$,(B nil $B$G$9$G$K%P%C%U%!$,B8:_$9$k$J$i!"(BHTTP GET $B$7$J$$!#(B"
  (interactive)
  (pukiwiki-initialize)
  (let (buf (site-info pukiwiki-site-info))
    ;; site-name input (if required)
    (when (null site-info)
      (setq site-info (pukiwiki-read-site-name)))
    (setq buf (pukiwiki-search-index site-info))
    (switch-to-buffer buf)
    (pukiwiki-index-sort nil ?d)))

;;; $BJQ992U=j$rI=<($5$;$k4X?t(B
(defun pukiwiki-mode-today-changed-diff ()
  (interactive)
  (let ((pagename
         (save-excursion
           (end-of-line)
           (if (re-search-backward "^\\*+ \\([^\r\n]+\\) \\*+$" nil t)
               (buffer-substring-no-properties
                (match-beginning 1)
                (match-end 1))
             (error "$B%Z!<%8L>$,8+$D$+$j$^$;$s(B")))))
    (setq test pagename)
    (pukiwiki-index-show-diff nil nil nil pagename)))

(defun pukiwiki-index-show-today-diff (&optional arg)
  "$B:#F|JQ99$5$l$?2U=j$r8+$k!%%j!<%8%g%s$,$"$l$P$=$NHO0O$N(B
$BJ8=q$NJQ992U=j$r0lMwI=<($9$k!%(B"
  (interactive "P")
  (let ((wikilist nil)
        (cbuf (current-buffer))
        (site-info pukiwiki-site-info)
        (today-changed-text nil) buf pt end-pt
        (site-name (car pukiwiki-site-info)))
    (if (listp arg)
        (setq arg (car arg)))
    (if (not arg)
        (setq arg 0))
    (cond
     ((or (and (boundp 'mark-active) mark-active)
          (and (fboundp 'region-exists-p) (region-exists-p)))
      (setq pt (region-beginning))
      (setq end-pt (region-end))
      (save-excursion
        (goto-char pt)
        (while (< (point) end-pt)
          (setq wikilist
                (cons (pukiwiki-index-page-info-current-line)
                      wikilist))
          (forward-line 1))
        (setq wikilist (reverse wikilist))
        (setq today-changed-text
              (pukiwiki-index-make-changed-text wikilist arg site-info))
        (setq buf (generate-new-buffer "*pukiwiki tmp*"))
        (switch-to-buffer buf)
        (pukiwiki-edit-rename-buffer
         site-name "" "region-changed" nil)
        (insert today-changed-text)
        (goto-char (point-min))
        (pukiwiki-replace-entity-refs)
        (setq pukiwiki-prev-buffer cbuf)
        (pukiwiki-diff-mode)
        (local-set-key "\C-m" 'pukiwiki-mode-today-changed-diff)
        (setq pukiwiki-site-info site-info)
        (set-buffer-modified-p nil)
        (delete-other-windows)
        (goto-char (point-min))
        (message "Creating ... done!")))
     (t
      (pukiwiki-index-show-diff nil arg t)))))

(defun pukiwiki-index-make-changed-text (wikilist day site-info)
  (with-temp-buffer
    (while wikilist
      (let* ((pukiwiki-site-info site-info)
             (contents nil)
             (pukiwiki-pagename (nth 1 (car wikilist)))
             (stringwidth (string-width (nth 1 (car wikilist))))
             (str
              (if (> (/ (- fill-column (+ 2 stringwidth)) 2) 0)
                  (make-string
                   (floor (/ (- fill-column (+ 2 stringwidth)) 2))
                   ?*)
                "")))
        (insert
         (concat
          str " " (nth 1 (car wikilist)) " " str
          "\n"))
        (save-current-buffer
          (pukiwiki-index-show-diff nil day)
          (goto-char (point-min))
          (while (re-search-forward "^[+-]" nil t)
            (setq contents
                  (cons
                   (buffer-substring-no-properties
                    (line-beginning-position)
                    (line-end-position))
                   contents)))
          (kill-buffer (current-buffer)))
        (setq contents (reverse contents))
        (while contents
          (insert
           (concat
            (car contents)
            "\n"))
          (setq contents (cdr contents)))
        (insert "\n")
        (setq wikilist (cdr wikilist))))
    (buffer-substring-no-properties
     (point-min) (point-max))))

(defun pukiwiki-index-show-today-changed (&optional arg)
  "$B:#F|JQ99$5$l$?2U=j$r0lMwI=<((B"
  (interactive "P")
  (let ((wikilist nil)
        (cbuf (current-buffer))
        (site-info pukiwiki-site-info)
        (today-changed-text nil) buf
        days
        (site-name (car pukiwiki-site-info)))
    (if (listp arg)
        (setq arg (car arg)))
    (if (not arg)
        (setq arg 0))
    (save-excursion
      ;;       (while (re-search-forward
      ;;               (format-time-string
      ;;                "%y/%m/%d" (pukiwiki-date-convert arg)) nil t)
      (save-excursion
        (beginning-of-line)
        (if (re-search-forward "[0-9]+/[0-9]+/[0-9]+" nil t)
            (setq days
                  (buffer-substring-no-properties
                   (match-beginning 0) (match-end 0)))
          (setq days
                (format-time-string
                 "%y/%m/%d" (pukiwiki-date-convert arg)) nil t)))
      (goto-char (point-min))
      (while (re-search-forward days nil t)
        (setq wikilist
              (cons (pukiwiki-index-page-info-current-line)
                    wikilist))))
    (setq wikilist (reverse wikilist))
    (setq today-changed-text
          (pukiwiki-index-make-changed-text wikilist arg site-info))
    (setq buf (generate-new-buffer "*pukiwiki tmp*"))
    (switch-to-buffer buf)
    (pukiwiki-edit-rename-buffer
     site-name "" "today-changed" nil)
    (insert today-changed-text)
    (goto-char (point-min))
    (pukiwiki-replace-entity-refs)
    (setq pukiwiki-prev-buffer cbuf)
    (pukiwiki-diff-mode)
    (local-set-key "\C-m" 'pukiwiki-mode-today-changed-diff)
    (setq pukiwiki-site-info site-info)
    (set-buffer-modified-p nil)
    (delete-other-windows)
    (goto-char (point-min))
    (message "Creating ... done!")
    ))

;;; pukiwiki-diff-mode
(define-derived-mode pukiwiki-diff-mode text-mode "Pukiwiki Diff"
  "Major mode for Pukiwiki editing.

\\{pukiwiki-edit-mode-map}"
  (pukiwiki-mode-set-variable)
  (pukiwiki-edit-setup-keys)
  (view-mode)
  (local-set-key " " 'scroll-up)
  (local-set-key "q" 'pukiwiki-diff-exit)
  (local-set-key "\M-n" 'pukiwiki-diff-next-change)
  (local-set-key "\M-p" 'pukiwiki-diff-prev-change)
  (local-set-key "b" 'scroll-down)
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults
        '(pukiwiki-diff-font-lock-keywords
          nil nil ((?_ . "w")) nil
          (font-lock-comment-start-regexp . "//")))
  (pukiwiki-mode-set-font-lock 'pukiwiki-diff-mode)
  (run-hooks 'pukiwiki-edit-mode-hook))

(defun pukiwiki-diff-exit ()
  (interactive)
  (let ((site-info pukiwiki-site-info)
        (prev-buffer pukiwiki-prev-buffer))
    (kill-buffer (current-buffer))
    (delete-other-windows)
    (if (and prev-buffer
             (buffer-live-p prev-buffer))
        (switch-to-buffer prev-buffer)
      (if (and
           site-info
           (pukiwiki-index-buffer-name site-info)
           (buffer-live-p
            (get-buffer
             (pukiwiki-index-buffer-name site-info))))
          (switch-to-buffer
           (get-buffer
            (pukiwiki-index-buffer-name site-info)))))))

(defun pukiwiki-diff-next-change ()
  (interactive)
  (end-of-line)
  (if (re-search-forward
       "^[+-]" nil t)
      (forward-char -1)
    (goto-char (point-max))))

(defun pukiwiki-diff-prev-change ()
  (interactive)
  (beginning-of-line)
  (if (re-search-backward
       "^[+-]" nil t)
      ()
    (goto-char (point-min))))


;;; func

(defun pukiwiki-display-page (pagename site-info &optional refetch)
  "$B%Z!<%8$rI=<($9$k(B

REFETCH $B$,(B nil $B$G$9$G$K%P%C%U%!$,B8:_$9$k$J$i!"(BHTTP GET $B$7$J$$!#(B"
  (let ((not-cancelled t)
        result body keyword pagetitle
        password history point buf new-page)
    (setq buf (cdr (assoc
                    (list (pukiwiki-site-name site-info) pagename)
                    pukiwiki-page-buffer-alist)))
    (if (and buf (buffer-name buf) (not refetch))
        (progn
          (switch-to-buffer buf)
          (goto-char (point-min)))
      (and buf (kill-buffer buf))
      (message "Loading...")
      (setq result
            (pukiwiki-fetch-source-in-order pagename site-info 'browse-extra))

      (setq body (cdr (assoc 'body result)))
      (setq pagetitle (cdr (assoc 'pagetitle result)))
      (setq password (cdr (assq 'password result)))
      (when
          (and body
               (or (> (length body) 0)
                   (progn
                     (setq not-cancelled
                           (y-or-n-p
                            (format
                             "Page %s is not exist. Create new page?"
                             pagename)))
                     (if not-cancelled
                         (setq new-page t)
                       (setq result nil))
                     not-cancelled)))
        (setq buf (generate-new-buffer "*pukiwiki tmp*"))
        (set-buffer buf)                ; $B2hLL$,%A%iIU$/$N$GJQ99$7$^$7$?!#(B
        (pukiwiki-edit-rename-buffer
         (pukiwiki-site-name site-info) pagename pagetitle password)
        (save-excursion
          (setq point (point))
          (insert body)
          (goto-char (point-min))
          (pukiwiki-replace-entity-refs)
          (pukiwiki-edit-mode)
          (setq pukiwiki-edit-newpage new-page)
          (set-buffer-modified-p nil)
          (add-to-list
           'pukiwiki-page-buffer-alist
           (cons (list (pukiwiki-site-name site-info) pagename)
                 (current-buffer)))
          (message "Loading... done."))
        (goto-char point))
      result)))

(defun pukiwiki-edit-page (pagename site-info)
  "PAGENAME $B$NJT=8%b!<%I$KF~$k!#%P%C%U%!$rJV$9!#(B"
  (let ((result (pukiwiki-display-page pagename site-info t))
        password history)
    (when result
      (if (setq password (cdr (assq 'password result)))
          (or (pukiwiki-password-read (car site-info) pagename)
              (pukiwiki-password-store  (car site-info) pagename t))
        (pukiwiki-password-store (car site-info) pagename nil))
      (when (cdr (assq 'password result))
        (kill-buffer (current-buffer))
        (error "$B$3$N%Z!<%8$OJT=8$G$-$^$;$s(B"))
      ;;       (if (setq password (cdr (assq 'password result)))
      ;;           (or (pukiwiki-password-read (car site-info) pagename)
      ;;               (pukiwiki-password-store  (car site-info) pagename t))
      ;;         (pukiwiki-password-store (car site-info) pagename nil))
      (setq pukiwiki-md5hex (cdr (assq 'md5hex result)))
      (setq pukiwiki-pagename pagename)
      (setq pukiwiki-pagetitle (or (cdr (assq 'pagetitle result)) pagename))
      (setq pukiwiki-site-info site-info)
      (or (setq history (assoc (pukiwiki-site-name) pukiwiki-pagename-history))
          (setq pukiwiki-pagename-history
                (cons (setq history (cons (pukiwiki-site-name) nil))
                      pukiwiki-pagename-history)))
      (or (member pukiwiki-pagename (cdr history))
          (setcdr history (cons (cons pukiwiki-pagename nil) (cdr history))))
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward
                "^*[^\r\n]+\\( \[#[0-9a-zA-Z]+\]\\)$" nil t)
          (delete-region
           (match-beginning 1)
           (match-end 1))))
      (set-buffer-modified-p nil)
      (current-buffer))))

;; Pukiwiki 1.3 $B7O$KBP=h!#(B
(defvar pukiwiki-pukiwiki-version-check-string
  "^\\s-*<strong>\"PukiWiki\"\\s-+\\([.0-9]+\\)"
  "Pukiwiki $B$N%P!<%8%g%sH=JL$N$?$a$N@55,I=8=!#(B")
(defvar pukiwiki-1-3-p nil
  "Pukiwiki $B$N%P!<%8%g%s$,(B 1.3 $B7O$J$i(B t, $B$=$&$G$J$1$l$P(B nil$B!#(B")

(defvar pukiwiki-fetch-index-regexp nil
  "index $B$H$7$FCj=P$9$k(B anchor $B$N@55,I=8=!#(B")
(defvar pukiwiki-fetch-index-regexp-1.3
  "<li><a[^?]*php\\?\\([^\"]*\\)\"[^>]*>\\([^<]*\\)</a><small>\\([^<]*\\)</small>*</li>"
  "index $B$H$7$FCj=P$9$k(B anchor $B$N@55,I=8=$N(B Pukiwiki 1.3$B7OMQ!#(B")

(defvar pukiwiki-fetch-index-regexp-1.4-later
  "<li><a[^?]*\\?cmd=read&amp;page=\\([^\"]*\\)\"[^>]*>\\([^<]*\\)</a>[<small>]*\\([^<]*\\)[</small>]*</li>"
  "index $B$H$7$FCj=P$9$k(B anchor $B$N@55,I=8=$N(B Pukiwiki 1.4$B0J9_MQ!#(B")

(defun pukiwiki-pukiwiki-version-check ()
  "Pukiwiki $B$N%P!<%8%g%s$rH=JL$7!"3:Ev$9$k(B regexp $B$r@_Dj$9$k!#(B"
  (let ()
    (save-match-data
      (re-search-forward pukiwiki-pukiwiki-version-check-string nil t nil)
      (if (string-match "1.3[.0-9]*" (match-string 1))
          (progn
            (setq pukiwiki-1-3-p t)
            (setq pukiwiki-fetch-index-regexp pukiwiki-fetch-index-regexp-1.3))
        (setq pukiwiki-1-3-p nil)
        (setq pukiwiki-fetch-index-regexp
              pukiwiki-fetch-index-regexp-1.4-later))
      (beginning-of-buffer))))

(defun pukiwiki-fetch-index (site-info)
  "$B%Z!<%80lMw$r<hF@$9$k!#(B"
  (let (indexes history (i 1)
                (buf (pukiwiki-http-request
                      'get "list" nil (pukiwiki-site-url site-info)
                      (pukiwiki-site-coding-system site-info))))
    (when (bufferp buf)
      (save-excursion
        (set-buffer buf)
        (pukiwiki-pukiwiki-version-check)
        (re-search-forward "<ul>" nil t nil)
        (while (re-search-forward
                pukiwiki-fetch-index-regexp
                nil t nil)
          (setq indexes
                (cons
                 (list i (http-url-unhexify-string
                          (match-string 1) (pukiwiki-site-coding-system site-info))

                       (pukiwiki-replace-entity-refs (match-string 2))
                       (pukiwiki-replace-entity-refs
                        (format-time-string
                         "%y/%m/%d"
                         (pukiwiki-index-date (match-string 3)))))
                 indexes))
          (setq i (1+ i))))
      (or (setq history
                (assoc
                 (pukiwiki-site-name site-info) pukiwiki-pagename-history))
          (setq pukiwiki-pagename-history
                (cons (setq history (cons (pukiwiki-site-name site-info) nil))
                      pukiwiki-pagename-history)))
      (setcdr history (mapcar (lambda (elm) (cons (nth 1 elm) nil)) indexes))
      (reverse indexes))))

;; InterWikiName
(defun pukiwiki-fetch-interwikiname (site-info)
  "InterWikiName $B$N0lMw$r<hF@$9$k!#(B"

  (save-excursion
    ;; InterWikiName $B%Z!<%8$N%=!<%9$r<hF@$7!"%P%C%U%!$r@8@.!#(B
    (setq interwiki-buffername (concat " *pukiwiki interwiki tmp*"))
    (let* ((url (concat (pukiwiki-site-url site-info)
                        "?cmd=edit&page=InterWikiName"))
           (buf (pukiwiki-interwiki-create-buffer
                 url "InterWikiName" site-info interwiki-buffername)))

      ;; list $B$r@8@.!#(B
      (set-buffer buf)
      (goto-char (point-min))
      (setq interwikiname-list nil)
      (while (re-search-forward
              "\\[\\(https*://[^ ]+\\) \\([^]]+\\)\\][ \t]*\\([^ \n\r]*\\).*$"
              nil t)
        (save-match-data
          (setq match-url (match-string 1))
          (setq start 0 pos 0)
          (while (setq pos (string-match "&amp;" match-url start))
            (setq match-url (replace-match "&" nil nil match-url))
            (setq start pos)))
        (setq interwikiname-list
              (cons
               (list (match-string 2)
                     match-url
                     nil
                     (cond
                      ((string= "euc" (match-string 3)) 'euc-jp-dos)
                      ((string= "sjis" (match-string 3)) 'shift_jis-dos)
                      ((string= "utf8" (match-string 3)) 'utf-8-dos)
                      ((string= "" (match-string 3)) 'utf-8-dos)
                      ((string= "raw" (match-string 3)) nil)
                      (t
                       (intern (match-string 3)))))
               interwikiname-list)))

      (kill-buffer buf)
      interwikiname-list)))

(defun pukiwiki-interwiki-create-buffer (url pagename site-info
                                             buffername
                                             &optional opt)
  (let* ((raw opt)
         (contents (pukiwiki-fetch-source pagename url
                                          (pukiwiki-site-coding-system site-info) raw))
         (buf (get-buffer-create buffername)))

    (set-buffer buf)
    (setq buffer-read-only nil)
    (erase-buffer)
    (insert (cdr (assoc 'body contents)))
    buf))

(defun pukiwiki-fetch-attach-index (site-info)
  "$BE:IU%U%!%$%k$N0lMw$rI=<($9$k!#(B"
  (let (indexes
        history (i 1)
        (list-regexp
         "^<li><a[^?]*\\?\\([- .%0-9a-zA-Z]*\\)\"[^>]*>\\([^<]*\\)</a>")
        beg end pagename
        attach-list
        (buf (pukiwiki-http-request
              'raw "list" nil
              (concat
               (pukiwiki-site-url site-info)
               "?plugin=attach&pcmd=list")
              (pukiwiki-site-coding-system site-info))))
    (when (bufferp buf)
      (save-excursion
        (set-buffer buf)
        (re-search-forward "<ul>" nil t nil)
        (while (re-search-forward
                list-regexp nil t)
          (setq pagename (match-string 2))
          (setq beg (point))
          (if (re-search-forward
               list-regexp nil t nil)
              (setq end (point))
            (setq end (point-max)))
          (goto-char beg)
          (setq attach-list nil)
          (while (re-search-forward
                  "<li><a[^?]*\\?plugin=attach\\([^\"]*\\)\"[^>]*>\\([^()<]*\\)</a>"
                  end t)
            (setq attach-list
                  (cons
                   (match-string 2)
                   attach-list)))
          (setq indexes
                (cons
                 (cons
                  pagename
                  attach-list)
                 indexes)))))
    indexes))

(defun pukiwiki-fetch-source-in-order (page info &optional browser)
  "$BM?$($i$l$?(B page $B$N%G!<%?$rFI$_9~$`!#(B
$B@h$:JT=8%b!<%I$GFI$_9~$_!"@5Ev$J%G!<%?$,F@$i$l$J$+$C$?$i!":9J,%b!<%I$GFI$`!#(B
$B:9J,$b<hF@$G$-$J$1$l$P(B error $B=*N;$9$k!#(B
BROWSER $B$,Hs(B nil $B$J$i!":9J,$b<hF@$G$-$J$+$C$?$H$-$K(B `browse-url' $B$K$h$j!"(B
$B30It%V%i%&%6$G$NFI$_9~$_$r9T$J$&!#(B"

  (let ((pagename page)
        (site-info info)
        (browse-extra browser)
        result)

    (condition-case err
        (setq result (pukiwiki-fetch-source
                      pagename (pukiwiki-site-url site-info)
                      (pukiwiki-site-coding-system site-info)))
      (error
       (condition-case err
           (setq result (pukiwiki-fetch-source
                         pagename
                         (format "%s?cmd=%s&page=%s"
                                 (pukiwiki-site-url site-info)
                                 "diff"
                                 (http-url-hexify-string
                                  pagename
                                  (pukiwiki-site-coding-system site-info)))
                         (pukiwiki-site-coding-system site-info)
                         'diff))
         (error
          ;; 'diff $B$G(B request $B$7$F$b(B Pukiwiki $B$N%F%-%9%H$,8+IU$+$i$J$+$C$?(B
          ;; $B>l9g$O!"30It%V%i%&%6$K$b0MMj$9$k!#(B
          (when (and browse-extra pukiwiki-interwiki-browse-not-match-pukiwiki)
            (let ((url (pukiwiki-site-url site-info t)))
              (if (string-match "$1" url)
                  (progn
                    (setq url (replace-match
                               (http-url-hexify-string
                                page
                                (pukiwiki-site-coding-system site-info))
                               nil nil url))
                    (browse-url url))
                (browse-url (concat url page)))))
          (error "PukiWiki $B$N%F%-%9%H$,8+$D$+$j$^$;$s(B")))

       (setq result (delete (list 'password) result))
       (setq result
             (cons
              (cons 'password t)
              result))))))

(defun pukiwiki-fetch-source (pagename site-url coding-system &optional raw)
  "Pukiwiki $B$N(B $B%=!<%9$r<hF@$9$k!#(B

'((md5hex . \"...\")
  (body . \"...\")
  (pagetitle . (...))
  (password . t/nil)) $B$rJV$9!#(B"
  (let (buf start end pt result
            (win (current-window-configuration)))
    (if raw
        (setq buf (pukiwiki-http-request 'raw "edit" pagename site-url coding-system))
      (setq buf (pukiwiki-http-request 'get "edit" pagename site-url coding-system)))
    (save-current-buffer
      (when (bufferp buf)
        (set-buffer buf)
        (save-excursion
          (goto-char (point-min))
          (if (or
               (re-search-forward "<pre>" nil t nil)
               (re-search-forward
                "<textarea [^>]*name=\"msg\"[^>]+>[\n\r]*" nil t nil))
              ()
            (set-window-configuration win)
            (error "PukiWiki $B$N%F%-%9%H$,8+$D$+$j$^$;$s(B")))
        ;; md5hex
        (goto-char (point-min))
        (re-search-forward
         "name=\"digest\" value=\"\\([^ ]+\\)\" />" nil t nil)
        (setq result
              (cons (cons
                     'md5hex (match-string-no-properties 1)) result))
        (setq pt (point))
        ;; textarea
        (when (string= raw 'diff)
          (goto-char (point-min))
          (re-search-forward "<pre>" nil t nil)
          (while (re-search-forward "^ " nil t)
            (delete-region
             (match-beginning 0)
             (match-end 0)))
          (goto-char (point-min))
          (re-search-forward "<pre>" nil t nil)
          (while (re-search-forward ">\\( \\)" nil t)
            (delete-region
             (match-beginning 1)
             (match-end 1))))
        (goto-char (point-min))
        (cond
         (raw
          (re-search-forward "<pre>" nil t nil)
          (setq start (match-end 0))
          (re-search-forward "</pre>" nil t nil)
          (setq end (match-beginning 0))
          (setq result
                (cons (cons
                       'body
                       (buffer-substring-no-properties start end)) result)))
         ((re-search-forward
           "<textarea [^>]*name=\"msg\"[^>]+>[\n\r]*" nil t nil)
          (setq start (match-end 0))
          (re-search-forward
           "</textarea>" nil t nil)
          (setq end (match-beginning 0))
          (setq result
                (cons (cons
                       'body
                       (buffer-substring-no-properties start end)) result))))
        ;; page_title
        (goto-char (point-min))
        (re-search-forward
         "<h1[^>]+class[^>]+\"title\"><a[^>]+href[^>]+>\\([^<>\"]*\\)</a>" nil t nil)
        (setq result
              (cons (cons 'pagetitle
                          (pukiwiki-replace-entity-refs
                           (match-string-no-properties 1))) result))
        (setq result (cons (cons 'password nil) result))))
    result))

(defun pukiwiki-check-encode-able (beg end)
  (interactive "r")
  (save-excursion
    (let* (
           (mycodingsystem buffer-file-coding-system)
           mychar
           mycharname mycharsetname
           (mycount 0)
           ;;;encoding $B$KBP1~$9$k(B charset $B$N%j%9%H$r<hF@$9$k!#(B
           ;;;Meadow2 (Emacs21) $B$G$bF0$/$+$I$&$+L$3NG'(B
           ;;;$B$&$^$/$$$+$J$1$l$P!"<+J,$GBP1~$rDj5A$9$l$PNI$$(B
           (mycharsetlist
            (if (featurep 'xemacs)
                (find-charset-region (point-min) (point-max))
              (coding-system-get mycodingsystem 'safe-charsets)))
           )
      (goto-char beg) ;;;$B%j!<%8%g%s$N@hF,$K0\F0(B
      (while (< (point) end) ;;;$B%j!<%8%g%sFb$r=g$KD4$Y$k(B
        (setq mychar (following-char))
        (setq mycharsetname (char-charset mychar))
        ;;$B9g@.J8;z$KBP$9$k=hM}!#(B Meadow2 (Emacs21) $B$G$OITMW$+$b(B????
        (if (equal 'composition mycharsetname)
            (setq mycharsetname
                  (char-charset (string-to-char
                                 (decompose-string (char-to-string mychar))))))
        ;;encode $B$G$-$J$$J8;z$@$C$?$i?'$r$D$1$k(B
        (if (or (equal mycharsetlist t) (member mycharsetname mycharsetlist))
            nil ;;;encode $B$G$-$k;~$O2?$b$7$J$$!#(B encode $B$G$-$J$$;~"-(B
          (overlay-put (make-overlay (point) (1+ (point))) 'face 'region)
          (setq mycount (1+ mycount)))
        (forward-char) ;;;$B<!$NJ8;z$X(B
        )
      ;;$B7k2L$NI=<((B
      (if (< 0 mycount)
          (error "$BJ8;z%3!<%I$N0[$J$kJ8;z$,4^$^$l$F$$$^$9(B"))
      (if (boundp 'transient-mark-mode)
          (if transient-mark-mode
              (setq deactivate-mark t)) ;;;region $B$r?'$D$1$7$F$$$k;~!"?'$r2r=|(B
        )
      )))

(defun pukiwiki-check-jisx0201 ()
  (interactive)
  (let ((beg (point-min))
        (end (point-max))
        debug-on-quit)
    (if (memq 'katakana-jisx0201 (find-charset-region beg end))
        (let ((buffer-read-only nil)
              (inhibit-read-only t))
          (japanese-zenkaku-region beg end t)
          t)
      t)))

;;; Util

(defun pukiwiki-site-name (&optional site-info)
  (nth 0 (or site-info pukiwiki-site-info)))

;; 2004.09.27 InterWikiName $B$G!"KvHx$,(B `?' $B$J(B url $B$bM?$($i$l$F$7$^$&$N$G!#(B
;; (defun pukiwiki-site-url (&optional site-info)
;;   (nth 1 (or site-info pukiwiki-site-info)))
(defun pukiwiki-site-url (&optional site-info no-strip)
  (let ((url (nth 1 (or site-info pukiwiki-site-info))))
    (if (and (not no-strip) (string-match "\\?$" url))
        (replace-match "" nil nil url) url)))

(defun pukiwiki-site-style (&optional site-info)
  (or (nth 2 (or site-info pukiwiki-site-info))
      'default))

(defun pukiwiki-site-coding-system (&optional site-info)
  (or (nth 3 (or site-info pukiwiki-site-info))
      'euc-jp-dos))

(defun pukiwiki-page-buffer-name (pagename site-info)
  (let ((buf (cdr (assoc (list (pukiwiki-site-name site-info) pagename)
                         pukiwiki-page-buffer-alist))))
    (and buf (buffer-name buf))))

(defun pukiwiki-index-buffer-name (&optional site-info)
  (format "Pukiwiki index <%s>" (pukiwiki-site-name site-info)))

(defun pukiwiki-index-sort-by (&optional key arg)
  (unless key
    (unless pukiwiki-index-sort-key
      (setq pukiwiki-index-sort-key '(?n nil)))
    (setq key (nth 0 pukiwiki-index-sort-key))
    (setq arg (nth 1 pukiwiki-index-sort-key)))
  (setq pukiwiki-index-sort-key (list key arg))
  (setq buffer-read-only nil)
  (save-excursion
    (goto-char (point-min))
    (cond
     ((eq key ?n) (pukiwiki-index-sort-subr arg 0))
     ((eq key ?d) (pukiwiki-index-sort-subr (not arg) 3))))
  (set-buffer-modified-p nil)
  (setq buffer-read-only t))

(defun pukiwiki-index-sort-subr (rev num)
  (sort-subr rev
             'forward-line 'end-of-line
             (lambda () (nth num (pukiwiki-index-page-info-current-line)))))

(defun pukiwiki-replace-entity-refs (&optional str)
  "Replace entity references.

If STR is a string, replace entity references within the string.
Otherwise replace all entity references within current buffer."
  (pukiwiki-do-replace-entity-ref
   "&nbsp;" " "
   (pukiwiki-do-replace-entity-ref
    "&lt;" "<"
    (pukiwiki-do-replace-entity-ref
     "&gt;" ">"
     (pukiwiki-do-replace-entity-ref
      "&quot;" "\""
      (pukiwiki-do-replace-entity-ref
       "&#39;" "'"
       (pukiwiki-do-replace-entity-ref
        "&#60;" "<"
        (pukiwiki-do-replace-entity-ref
         "&#62;" ">"
         (pukiwiki-do-replace-entity-ref
          "&amp;" "&"
          (pukiwiki-do-replace-entity-ref
           "&#38;" "&" str
           ))))))))))

(defun pukiwiki-do-replace-entity-ref (from to &optional str)
  (save-match-data
    (save-excursion
      (goto-char (point-min))
      (if (stringp str)
          (progn
            (while (string-match from str)
              (setq str (replace-match to nil nil str)))
            str)
        (while (search-forward from nil t)
          (replace-match to nil nil))))))

(defun pukiwiki-propertize (string &rest properties)
  "Return a copy of STRING with text PROPERTIES added."
  (prog1
      (setq string (copy-sequence string))
    (add-text-properties 0 (length string) properties string)))

(defun pukiwiki-prefix (str width)
  "STR $B$N@hF,$r(B WIDTH$BJ8;z$r<h$j=P$9!#(B

WIDTH $B$KK~$?$J$$>l9g$O!"KvHx$K6uGr$,%Q%G%#%s%0$5$l$k!#(B"

  (let (l (result "")
          (w (string-width str)))
    (if (< w width)
        (setq str (concat str (make-string (1- width) ? ))
              w (string-width str)))
    (setq l (string-to-list str))
    (while (< (char-width (car l)) width)
      (setq result (concat result (char-to-string (car l))))
      (setq width (- width (char-width (car l))))
      (setq l (cdr l)))
    (concat result (make-string width ? ))))

;;; Util (http-*)

(defun http-url-unhexify-string (str coding)
  "Unescape characters in a string."
  (save-match-data
    (let ((result (string-as-unibyte str)) (pos -1))
      (while (setq pos (string-match "+" result (1+ pos)))
        (setq result (replace-match " " nil nil result)))
      (setq pos -1)
      (while (setq pos
                   (string-match
                    "%\\([0-9a-fA-F][0-9a-fA-F]\\)" result (1+ pos)))
        (setq result
              (replace-match
               (format "%c"
                       (eval (read (concat "?\\x"
                                           (match-string 1 result)))))
               t t result)))
      (decode-coding-string result coding))))

(defun http-url-hexify-alist (alist coding)
  (mapcar
   (lambda (c)
     (cons (car c) (and (cdr c) (http-url-hexify-string (cdr c) coding))))
   alist))


;;; for pukiwiki

;;;; $B%Z!<%8I=<($N@07A4XO"(B
(defun pukiwiki-insert-comment-str (str &optional region-start region-end)
  (let ((beg (or region-start (point)))
        (end (or region-end (1+ (point))))
        (end-marker (make-marker)))

    (if (and (not (null str))
             (not (string= "" str)))
        (progn
          (set-marker end-marker end)
          (insert str)
          (pukiwiki-insert-comment-str-subr beg end-marker)
          (insert "\n"))
      (pukiwiki-insert-comment-str-subr beg end))))

(defun pukiwiki-insert-comment-str-subr (beg end)
  (narrow-to-region beg end)

  (let ((contents nil) (lth nil) (end nil))
    ;; $B2~9T$5$l$F$$$k%3%a%s%H$r!"%3%a%s%H$4$H$K0l9T$K5M$a9~$`!#(B
    (pukiwiki-insert-comment-str-fill-line)
    (goto-char (point-min))
    (keep-lines "^-")
    (goto-char (point-min))

    ;; $B<BBN;2>H$dFC<lJ8;z$r2r7h!#(B
    (pukiwiki-replace-entity-refs)
    (pukiwiki-replace-string "&new{" "" nil (point-min) (point-max))
    (pukiwiki-replace-regexp "SIZE([0-9]+){" "" nil (point-min) (point-max))
    (pukiwiki-replace-regexp "}[;]*" "" nil (point-min) (point-max))

    ;; $B%3%a%s%H$N7A<0$r8+0W$$MM$KJQ49!#(B
    ;; overlay $B$,:o$i$l$F$7$^$&$N$GJQ99$7$F$_$^$7$?!#(B
    (pukiwiki-replace-comment
     "^\\([-]+\\)\\([^\n\r]+\\)\\([ ]*--[ ]*\\)\\(\\[\\[[^]\n\r]+\\]\\]\\) \\([^\n\r]+\\)[ ]*$"
     (point-min) (point-max))
    (pukiwiki-replace-comment
     "^\\([-]+\\)\\([^\n\r]+\\)\\([ ]*--[ ]*\\)\\([^[\n\r]+\\)[ ]*$"
     (point-min) (point-max))

    (pukiwiki-replace-regexp "[ ]+$"
                             ""
                             nil (point-min) (point-max))
    (pukiwiki-replace-regexp "\n"
                             "\n\n"
                             nil (point-min) (point-max))
    (goto-char (point-min))
    (while (re-search-forward
            "^[-]+" nil t nil)
      (setq lth (length (match-string 0)))
      (delete-region (match-beginning 0) (match-end 0))
      (insert
       (concat
        (if (not (= lth 1))
            (make-string (* 2 lth) ? ))
        "_"))
      (when (not (= lth 1))
        (save-excursion
          (if (re-search-forward "^[-]+" nil t nil)
              (setq end (point))
            (setq end (progn (goto-char (point-max))
                             (line-beginning-position)))))
        (save-excursion
          (forward-line 1)
          (beginning-of-line)
          (while (> end (point))
            (insert
             (format "%s" (make-string (* 2 lth) ? )))
            (forward-line 1)
            (beginning-of-line)))))

    ;; anchor $B$rM-8z$K!#(B
    (let ((beg (point-min-marker))
          (end (point-max-marker)))
      (unwind-protect
          (pukiwiki-insert-comment-with-anchor (point-min) (point-max))
        (save-excursion
          (set-buffer (marker-buffer beg))
          (narrow-to-region beg end))))

    (fill-region (point-min) (point-max))
    (pukiwiki-replace-regexp "\n[ ]*\n"
                             "\n"
                             nil (point-min) (point-max)))
  (widen))

(defun pukiwiki-insert-comment-str-pull-out-line (str &optional below)
  (let ((count (if below
                   (1+ pukiwiki-view-comment-expansion-count)
                 pukiwiki-view-comment-expansion-count))
        delete-point)
    (with-temp-buffer
      (insert str)
      (if below
          (goto-char (point-min))
        (goto-char (point-max)))

      ;; $BCj=P$9$k%]%$%s%H$r!":G>e0L$N%3%a%s%H%"%&%H$r?t$(>e$2$F8!:w!#(B
      (catch 'count-finish
        (while (if below
                   (re-search-forward "^-[^-]" nil t)
                 (re-search-backward "^-[^-]" nil t))
          (setq count (1- count))
          (when (< count 1)
            (throw 'count-finish t))))
      (setq delete-point (line-beginning-position))

      ;; $B8~$-$K9g$o$;$FITMW$J%3%a%s%H$r:o=|!#(B
      (if below
          (when (not (= (point-max) delete-point))
            (delete-region delete-point (point-max)))
        (when (not (= (point-min) delete-point))
          (delete-region (point-min) delete-point)))
      (buffer-substring (point-min) (point-max)))))

(defun pukiwiki-replace-comment (regexp start end)
  "$B%3%a%s%H$N=q<0$rJQ49$9$k!#(B"

  (let ((top start) (bottom end) (next (make-marker)) (prev start) header)
    (goto-char top)
    (catch 'range-over
      (while (setq result (re-search-forward regexp bottom t))
        (set-marker next result)
        (setq header (concat (match-string 1) " "
                             (or (match-string 5) "") " "
                             (match-string 4) "\n"))
        (when (match-string 5)
          (delete-region (match-beginning 5) (match-end 5)))
        (delete-region (match-beginning 4) (match-end 4))
        (delete-region (match-beginning 3) (match-end 3))
        (delete-region (match-beginning 1) (match-end 1))

        (save-excursion
          (goto-char (match-beginning 1))
          (insert " ")
          (forward-char -1)
          ;; delete overlay from invalid point.
          (let ((overlays (overlays-in (point) (1+ (point)))))
            (while
                (setq ovr (prog1 (car overlays) (setq overlays (cdr overlays))))
              (when (overlay-get ovr 'overlay)
                (move-overlay ovr
                              (1+ (overlay-start ovr)) (overlay-end ovr)))))
          ;; delete properties from invalid point.
          (set-text-properties (point) (1+ (point)) nil)
          (insert (concat header "   ")))

        (setq bottom (+ bottom (- next result)))
        (if (>= (point) bottom)         ; insert $B$G(B next $B$,(B bottom $B$h$j$b(B
            ; $B@h$K?J$s$@;~$b(B 'range-over.
            (throw 'range-over t))
        (setq prev next))
      (cond ((eq result nil)            ; $B$b$&(B match $B$7$J$+$C$?!#(B
             (throw 'range-over t))
            ((>= next bottom)           ; next $B$,(B bottom $B$r1[$($?!#(B
             (throw 'range-over t))))))

(defun pukiwiki-insert-comment-str-fill-line ()
  "$B2~9T$5$l$F$$$k%3%a%s%H$r0l9T$K5M$a9~$`!#(B"

  (save-excursion
    (let (beg end next)
      (goto-char (point-min))
      (catch 'not-match
        (while (re-search-forward "^-" nil t)
          (setq beg (line-beginning-position)
                next (point))
          (if (re-search-forward "^-" nil t)
              (progn
                (forward-line -1)
                (setq end (line-end-position)))
            (throw 'not-match t))
          (pukiwiki-replace-regexp "\n" "" nil beg end)
          (goto-char next))))))

(defun pukiwiki-insert-comment-with-anchor (start end)
  (narrow-to-region start end)
  ;; with delete url description.
  (pukiwiki-insert-anchor
   (cdr (assoc 'delete-url-description pukiwiki-style-anchor-regexp-alist)))
  ;; to leave url description.
  (pukiwiki-insert-anchor
   (cdr (assoc 'leave-url-description pukiwiki-style-anchor-regexp-alist)))
  (widen)
  (point))

(defvar pukiwiki-view-comment-expansion-count-default 10
  "`#pcomment' plugin $B$GE83+$9$k%3%a%s%H?t$N%G%U%)%k%HCM!#(B")

(defvar pukiwiki-view-comment-expansion-count 10
  "`#pcomment' plugin $B$GE83+$9$k%3%a%s%H?t!#(B")

(defun pukiwiki-insert-comment ()
  "pcomment $B$K$h$k%3%a%s%H$rA^F~$9$k(B"
  (let ((comment nil) reply-option)
    (setq pukiwiki-view-comment-expansion-count
          pukiwiki-view-comment-expansion-count-default)
    (save-excursion
      (save-current-buffer
        (goto-char (point-min))
        (setq pname nil)
        (while (re-search-forward
                "^#pcomment\\((\\([^)]*\\))\\)*$" nil t)
          (let ((options (match-string 2))
                option pname below reply pname-invalid match-flag)
            (while (or (and (setq match-flag options)
                            (setq match-flag
                                  (string-match "\\([^,]*\\) *, *\\(.*\\)" options)))
                       (not (string= "" options)))
              (if match-flag
                  (progn
                    (setq option (match-string 1 options))
                    (setq options (match-string 2 options)))
                (setq option (or options ""))
                (setq options ""))
              (when (and (not (string= "" option))
                         ;; $B:#$N$H$3$m(B noname, nodate, above $B$OL5;k!#(B
                         (not (string= "noname" option))
                         (not (string= "nodate" option))
                         (not (string= "above" option)))
                (cond
                 ((string= "reply" option) ; $B%j%W%i%$2DG=(B
                  (setq reply t))
                 ((string= "below" option) ; $B>e$K8~$+$C$F?7$7$$=g$KJB$Y$k!#(B
                  (setq below t))
                 ((string-match "^[0-9]+$" option)
                  (setq pukiwiki-view-comment-expansion-count
                        (string-to-number option)))
                 (t                     ; $B2?$l$G$bL5$1$l$P%Z!<%8L>$HH=CG!#(B
                  (if (or pname (string-match "\"#&<>" option))
                      ;; $B;XDj$G$-$J$$J8;z$,$"$C$?!#(B
                      (setq pname-invalid t)
                    (setq pname option))))))

            (unless pname-invalid
              (unless pname
                (setq pname
                      (if (string-match "\\[\\[\\(.+\\)\\]\\]"
                                        pukiwiki-pagename)
                          ;; 1.3 $B7O$N(B BracketName
                          (concat "[[" "$B%3%a%s%H(B/"
                                  (match-string 1 pukiwiki-pagename) "]]")
                        (concat "$B%3%a%s%H(B/" pukiwiki-pagename))))

              (message "Inserting comment...")
              (setq comment
                    (pukiwiki-fetch-source-in-order
                     pname
                     pukiwiki-site-info nil))
              (forward-line 1)

              ;; $B%3%a%s%H$NA^F~!#(B
              (let ((pos (point)) exist)
                ;; $B%3%a%s%H$r@07A$7$FA^F~!#(B
                (if (cdr (assoc 'body comment))
                    (pukiwiki-insert-comment-str
                     ;; $BE83+$9$k%3%a%s%H$r!";XDj$5$l$??t$K9J$C$FA^F~$9$k!#(B
                     (pukiwiki-insert-comment-str-pull-out-line
                      (cdr (assoc 'body comment)) below)))

                ;; point $B$,F0$$$F$$$?$i!"%3%a%s%H$,B8:_$9$k!#(B
                (setq exist (not (= pos (point))))
                ;; $BA^F~%3%a%s%H$N%"%J%&%s%9$rI=<(!#(B
                (save-excursion
                  (goto-char pos)
                  (pukiwiki-insert-comment-announce
                   pname pukiwiki-view-comment-expansion-count exist)))

              ;; reply $BBP>]$N%3%a%s%H$rA*Br2DG=$K$9$k!#(B
              (when reply (pukiwiki-view-comment-form-pcomment-reformat))

              (pukiwiki-replace-entity-refs)))))))
  (message "Inserting comment...done!"))

(defun pukiwiki-insert-comment-announce (page-name
                                         display-count-str comment-exist)
  (let ((name page-name)
        (count-str display-count-str)
        (exist comment-exist))

    ;; $BI=<(7o?t$N%"%J%&%s%9A^F~!#(B
    (insert
     (if exist
         (concat "$B:G?7$N(B" (number-to-string count-str) "$B7o$rI=<($7$F$$$^$9!#(B")
       (concat "$B%3%a%s%H$O$"$j$^$;$s!#(B")))

    ;; $B%3%a%s%H%Z!<%8$X$N%j%s%/$rA^F~!#(B
    (let ((start (point)) end)
      (if exist
          (insert "$B%3%a%s%H%Z!<%8$r;2>H(B")
        (insert name))
      (setq end (point))
      (insert "\n\n")

      ;; set property and overlay.
      (pukiwiki-insert-anchor-subr 'pagename name
                                   'pukiwiki-view-anchor-face start end))))

;; comment form $B$KBP1~!#(B
(defcustom pukiwiki-view-form-text-input-style 'form
  "*comment form $B$N%F%-%9%HF~NO9`L\$NI=<(!"F~NO7A<0!#(B"
  :group 'pukiwiki
  :type '(radio (const :tag "Not specified" nil)
                (const :format "Ask name and comment: %v\n" ask)
                (const :format "Display input text form: %v\n" form)
                (const :format "Display input text form by large area: %v\n" large)))

(defcustom pukiwiki-view-form-textarea-buffer-height 10
  "*Hieght of the MESSAGE input buffer."
  :group 'pukiwiki
  :type '(integer :size 0))

(defvar pukiwiki-view-form-elem-text-list
  '("name" "msg")
  "comment form $B$N%F%-%9%HF~NO9`L\$NMWAG%j%9%H(B")

(defvar pukiwiki-view-form-elem-list
  '("encode_hint" "refer" "plugin" "nodate" "digest" "comment")
  "comment form $B$N6&DL$JMWAG%j%9%H(B")

(defvar pukiwiki-view-form-elem-comment-list
  '("comment_no" "above")
  "comment form $B$N$_$KI,MW$JMWAG%j%9%H(B")

(defvar pukiwiki-view-form-elem-pcomment-list
  '("reply" "page" "dir" "count")
  "pcomment form $B$N$_$KI,MW$JMWAG%j%9%H(B")

(defvar pukiwiki-view-form-elem-article-list
  '("article_no")
  "article form $B$N$_$KI,MW$JMWAG%j%9%H(B")

(defun pukiwiki-view-form-textarea-setup-keys ()
  "Set up keymap for pukiwiki-view-form-textarea-mode.
If you want to set up your own key bindings,
use `pukiwiki-view-form-textarea-mode-hook'."
  (define-key pukiwiki-view-form-textarea-mode-map
    "\C-c\C-c" 'pukiwiki-view-form-textarea-set)
  (define-key pukiwiki-view-form-textarea-mode-map
    "\C-c\C-k" 'pukiwiki-view-form-textarea-exit)
  (define-key pukiwiki-view-form-textarea-mode-map
    "\C-c\C-q" 'pukiwiki-view-form-textarea-exit)
  (define-key pukiwiki-view-form-textarea-mode-map
    "\C-c\C-y" 'pukiwiki-view-form-textarea-buffer-history-yank))

(defun pukiwiki-view-form-textarea-set (&optional no-hist)
  "$BF~NO$5$l$?%G!<%?$rJ]B8$7$F%P%C%U%!$rGK4~$7!"85$N>uBV$KI|5"$7$^$9!#(B
$BA0CV0z?t$,;XDj$5$l$k$H!"%P%C%U%!F~NOMzNr$X$NJ]B8$r9T$J$$$^$;$s!#(B"

  (interactive "P")

  ;; $B%P%C%U%!$NGK4~$H85$N>uBV$X$NI|5"!#(B
  (let* ((ret (pukiwiki-view-form-textarea-exit no-hist))
         (input (car ret))
         (type (cdr ret)))
    ;; $BF~NO%G!<%?$NH?1G!#(B
    (pukiwiki-view-comment-form-input 'already input type)))

(defun pukiwiki-view-form-textarea-exit (&optional no-hist)
  "$BF~NO$5$l$?%G!<%?$H%P%C%U%!$rGK4~$7!"85$N>uBV$KI|5"$7$^$9!#(B
$BA0CV0z?t$,;XDj$5$l$k$H!"%P%C%U%!F~NOMzNr$X$NJ]B8$r9T$J$$$^$;$s!#(B"

  (interactive "P")

  (let ((input (buffer-string))
        (kbuf (current-buffer))
        (buf pukiwiki-view-form-textarea-orig-buf)
        (pos pukiwiki-view-form-textarea-orig-pos)
        (type pukiwiki-view-form-textarea-orig-type)
        (wincfg pukiwiki-view-form-textarea-orig-wincfg))
    ;; $BMzNr$KJ];}!#(B
    (unless no-hist
      (pukiwiki-view-form-textarea-buffer-history-push input))
    ;; $B%P%C%U%!$rGK4~$7!"85$N>uBV$X$NI|5"!#(B
    (pukiwiki-view-form-textarea-kill-and-restore kbuf buf pos wincfg)
    (cons input type)))

(defun pukiwiki-view-form-textarea-kill-and-restore (kbuf buf pos config)
  "$B%P%C%U%!$rGK4~$7!"85$N>uBV$X$NI|5"$7$^$9!#(B"

  ;; textarea buffer $B$rH4$1$k!#(B
  (kill-buffer kbuf)
  ;; buffer, point, window $B$NI|85!#(B
  (set-buffer buf)
  (goto-char pos)
  (set-window-configuration config))

(defun pukiwiki-view-form-textarea-buffer-history-push (str)
  "Textarea $B%P%C%U%!$X$NF~NOMzNr$rJ]B8$7$^$9!#(B
STR $B$K;XDj$5$l$?J8;zNs$r!"MzNr$H$7$FJ]B8$7$^$9!#(B"

  (when (and (> (length str) 0)
             (not
              (string= str (car pukiwiki-view-form-textarea-buffer-history))))
    (let ((history (cons str pukiwiki-view-form-textarea-buffer-history)))
      (when (and str history)
        (setq pukiwiki-view-form-textarea-buffer-history history)
        ;; $BMzNrJ];}$N:GBg?t$rD6$($?$i!":G8E$N$b$N$+$i:o=|$9$k!#(B
        (when (> (length pukiwiki-view-form-textarea-buffer-history)
                 pukiwiki-view-form-textarea-buffer-history-keep-count)
          (setq pukiwiki-view-form-textarea-buffer-history
                (nreverse
                 (cdr
                  (nreverse pukiwiki-view-form-textarea-buffer-history)))))))))

(defun pukiwiki-view-form-textarea-buffer-history-get (&optional num)
  "Textarea $B%P%C%U%!$X$NF~NOMzNr$r<h$j=P$7$^$9!#(B
NUM $B$K?tCM$,;XDj$5$l$k$H!":G?7$+$i(B NUM $BHVL\$NMzNr$r<h$j=P$7$^$9!#(B
NUM $B$,(B nil $B$+(B 0 $B$@$H!":G?7$NMzNr$r<h$j=P$7$^$9!#(B"

  (let ((newest (car pukiwiki-view-form-textarea-buffer-history))
        (specified
         (and num (nth num pukiwiki-view-form-textarea-buffer-history))))
    (if specified specified newest)))

(defvar pukiwiki-view-form-textarea-buffer-history nil
  "Textarea $B$X$NF~NOFbMF$NMzNr%j%9%H(B")
(defvar pukiwiki-view-form-textarea-buffer-history-count 0
  "Textarea $BF~NO%P%C%U%!$G$NO"B3$7$?(B yank command $B$N<B9T2s?t(B")
(defvar pukiwiki-view-form-textarea-buffer-history-prepos 0
  "Textarea $BF~NO%P%C%U%!$G!"O"B3(B yank $B$9$k:]$K!"0JA0$N(B yank $BFbMF$r:o=|$9$k(B
$B3+;O0LCV!#(B")

(defun pukiwiki-view-form-textarea-buffer-history-yank (&optional num)
  "Textarea $B%P%C%U%!$X$NF~NOMzNr$r(B yank $B$7$^$9!#(B
$B$3$N%3%^%s%I$rO"B3$7$F<B9T$9$k$H!"C`<!!"MzNr$rAL$C$F(B yank $B$7$^$9!#(B
$BMzNr$N:G8E$KE~C#$9$k$H!"<!$O:G?7$NMzNr$r(B yank $B$7$^$9!#(B"

  (interactive "P")
  (let* ((same-command (eq this-command last-command))
         (num
          (if same-command
              (setq pukiwiki-view-form-textarea-buffer-history-count
                    (if (= (1+ pukiwiki-view-form-textarea-buffer-history-count)
                           (length pukiwiki-view-form-textarea-buffer-history))
                        0
                      (1+ pukiwiki-view-form-textarea-buffer-history-count)))
            (setq pukiwiki-view-form-textarea-buffer-history-prepos (point))
            (setq pukiwiki-view-form-textarea-buffer-history-count 0)))
         (pos pukiwiki-view-form-textarea-buffer-history-prepos)
         (result (pukiwiki-view-form-textarea-buffer-history-get num)))
    (when same-command
      (delete-region pos (point)))
    (insert result)))

(define-derived-mode pukiwiki-view-form-textarea-mode text-mode
  "Pukiwiki Textarea"
  "Major mode for input buffer of textarea.

\\{pukiwiki-view-form-textarea-mode-map}"

  (pukiwiki-view-form-textarea-setup-keys)

  (make-local-variable 'pukiwiki-view-form-textarea-orig-buf)
  (make-local-variable 'pukiwiki-view-form-textarea-orig-pos)
  (make-local-variable 'pukiwiki-view-form-textarea-orig-type)
  (make-local-variable 'pukiwiki-view-form-textarea-orig-wincfg)

  (setq mode-name "pukiwiki view form textarea"
        major-mode 'pukiwiki-view-form-textarea-mode)
  (run-hooks 'pukiwiki-view-form-textarea-mode-hook))

(defun pukiwiki-view-form-input (input-type property)
  (let ((prop property)
        (type input-type))
    (pukiwiki-view-comment-form-input type)))

(defun pukiwiki-view-form-select-radio-button (select)
  (let ((pos (point))
        (status select)
        star end)
    (when (and (get-text-property (point) 'anchor)
               (numberp (get-text-property (point) 'radio)))
      ;; radio button $B$NA*Br$O!"(B`*' $B$rI=<($9$k$3$H$GI=8=$9$k!#(B
      (save-excursion
        ;; $BBP>](B extent $B$NJ];}!#(B
        (goto-char (next-single-property-change (point) 'anchor))
        (setq end (point))
        (setq start (previous-single-property-change (point) 'anchor))

        ;; all clear.
        (pukiwiki-view-form-unselect-all-radio-button)

        ;; toggle select status. (on or off)
        (setq buffer-read-only nil)
        (if (eq 'yes status)
            (add-text-properties start end (list 'select 'no))
          (add-text-properties start end (list 'select 'yes))))

      ;; mark update.
      (pukiwiki-view-form-select-radio-button-refresh start end))
    (goto-char pos)))

(defun pukiwiki-view-form-select-radio-button-refresh (start end)
  (let ((status (get-text-property start 'select))
        (prop (text-properties-at start)))
    (setq buffer-read-only nil)
    (goto-char start)
    (re-search-forward "[ *]" nil t)
    (if (eq 'yes status)
        (replace-match "*")
      (replace-match " "))
    (add-text-properties start end prop)
    (setq buffer-read-only t)))

(defun pukiwiki-view-form-unselect-all-radio-button ()
  (save-excursion
    (let ((start (previous-single-property-change (point) 'pcomment-start))
          (end (next-single-property-change (point) 'pcomment-end))
          next)
      (goto-char start)
      (while (< (setq next
                      (next-single-property-change (point) 'anchorhead nil end))
                end)
        (progn
          (goto-char next)
          (when (get-text-property (point) 'radio)
            (setq next-end (next-single-property-change (point) 'anchor))
            (setq buffer-read-only nil)
            (add-text-properties next next-end (list 'select 'no))
            (pukiwiki-view-form-select-radio-button-refresh next next-end)
            ))))))

(defun pukiwiki-view-comment-form-input (input-type &optional input original)
  (let ((pos (point))
        (type input-type)
        (orig-type original)
        (data input))
    (save-excursion
      ;; minibuffer $B$+!"(BTextarea $BF~NOMQ%P%C%U%!$+$i$NF~NO$r<u$1IU$1$F!"(B
      (cond
       ((eq type 'name)
        (setq data (cdr (pukiwiki-view-comment-form-text-input-get-name))))
       ((eq type 'comment)
        (if (eq pukiwiki-view-form-text-input-style 'large)
            (pukiwiki-view-comment-form-text-input-get-str-from-buffer
             (current-buffer) pos type)
          (setq data
                (cdr (pukiwiki-view-comment-form-text-input-get-comment)))))
       ((eq type 'subject)
        (setq data (cdr (pukiwiki-view-comment-form-text-input-get-subject))))
       ((eq type 'message)
        (if (eq pukiwiki-view-form-text-input-style 'large)
            (pukiwiki-view-comment-form-text-input-get-str-from-buffer
             (current-buffer) pos type)
          (setq data
                (cdr (pukiwiki-view-comment-form-text-input-get-message)))))
       (t nil))
      (unless (null data)
        (when (= (length data) 0) (setq data nil)))

      (when (or (eq type 'name)
                (and (eq type 'comment)
                     (not (eq pukiwiki-view-form-text-input-style 'large)))
                (eq type 'subject)
                (and (eq type 'message)
                     (not (eq pukiwiki-view-form-text-input-style 'large)))
                (eq type 'already))

        (when (eq type 'already)        ; 'already $B$N>l9g$O85$N(B type $B$KLa$9!#(B
          (setq type original))

        ;; $BHO0O$rFCDj$7!"(B
        (setq start
              (next-single-property-change (line-beginning-position) type))
        (setq end (next-single-property-change start type))

        ;; property $B$K@_Dj$9$k$H6&$K!"(Bbuffer $B$r=q$-49$($k!#(B
        (setq buffer-read-only nil)
        (delete-region (line-beginning-position) end)
        (pukiwiki-view-comment-form-insert-input type data)
        (setq buffer-read-only t)))
    (goto-char pos)))

(defun pukiwiki-view-form-submit (property)
  (let ((prop property))
    (when (pukiwiki-view-comment-form-request prop)
      (pukiwiki-view-display-page pukiwiki-pagename 1 nil t))))

(defun pukiwiki-view-comment-form-request (property)
  (interactive)

  ;; element $B$N<}=8!#(B
  (let* ((prop property)
         (plugin (cdr (assoc "plugin" prop)))
         (list (append pukiwiki-view-form-elem-list
                       (cond ((string= "comment" plugin)
                              pukiwiki-view-form-elem-comment-list)
                             ((string= "pcomment" plugin)
                              pukiwiki-view-form-elem-pcomment-list))))
         post-data)

    ;; $BF~NO9`L\0J30!#$3$N;~E@$G$O(B reply $B$O(B list $B$N$^$^!#(B
    (mapcar (lambda (key) (add-to-list 'post-data (assoc key prop))) list)
    ;; $BF~NO9`L\!#(B
    (setq post-data
          (pukiwiki-view-comment-form-text-input-get post-data plugin))

    (if (string= "" (cdr (assoc "msg" post-data)))
        (progn (message "Comment text missing!!") nil)
      ;; request $B$r(B post $B$9$k!#(B
      (message "Putting Text...")
      (setq buf
            (pukiwiki-http-request 'post nil pukiwiki-pagename
                                   (pukiwiki-site-url)
                                   (pukiwiki-site-coding-system)
                                   post-data))
      t)))

(defun pukiwiki-view-comment-form-text-input-get (post plugin)
  (let (flag)
    ;; post $B$9$k(B form $B$KF~NO$5$l$?%G!<%?$r<hF@!#(B
    (cond
     ;; $BF~NO:Q$_$N9`L\FbMF$r(B properties $B$+$iF@$k!#(B
     ((or (eq pukiwiki-view-form-text-input-style 'form)
          (eq pukiwiki-view-form-text-input-style 'large))
      (setq result-list
            (pukiwiki-view-comment-form-text-input-get-data plugin))
      (add-to-list 'post (assoc "name" result-list))

      (cond
       ((string-match "p*comment" plugin)
        (add-to-list 'post (assoc "msg" result-list))
        (if (assoc "reply" result-list)
            (setq order (cdr (assoc "reply" result-list)))
          (setq order (car (rassoc "0" (car (cdr (assoc "reply" post)))))))
        (when (string= plugin "pcomment")
          (when (assoc "reply" post)
            (setcdr (assoc "reply" post)
                    (cdr (assoc order (car (cdr (assoc "reply" post)))))))))

       ((string= plugin "article")
        (add-to-list 'post (assoc "subject" result-list))
        (add-to-list 'post (assoc "msg" result-list)))))

     ((eq pukiwiki-view-form-text-input-style 'ask)
      ;; $B%_%K%P%C%U%!$+$i!#(B
      (add-to-list 'post
                   (pukiwiki-view-comment-form-text-input-get-name))
      (cond
       ((string-match "p*comment" plugin)
        (add-to-list 'post
                     (pukiwiki-view-comment-form-text-input-get-comment))
        (when (string= plugin "pcomment")
          ;; $BA*Br$5$l$?=g=xHV9f$r;}$D(B `reply' $B$K9J$k$?$a!"(Blist $B$NCf?H$r(B
          ;; $B=q$-49$($k!#(B
          (when (assoc "reply" post)
            (setcdr
             (assoc "reply" post)
             (cdr (assoc (1-
                          (string-to-number
                           (pukiwiki-view-comment-form-text-input-get-replyno)))
                         (car (cdr (assoc "reply" post)))))))))
       ((string= plugin "article")
        (add-to-list 'post
                     (pukiwiki-view-comment-form-text-input-get-subject))
        (add-to-list 'post
                     (pukiwiki-view-comment-form-text-input-get-message))))))
    post))

(defun pukiwiki-view-comment-form-text-input-get-data (plugin)
  (let (reply-no name-value msg-value subject-value name subject msg)
    ;; plugin $B$K1~$8$F!"0J2<$N(B property $B$rC5$9!#(B
    ;;   p*comment $B$N$H$-(B: name, msg (comment) $B$rC5$9!#(B
    ;;   article $B$N$H$-(B  : name, subject, message $B$rC5$9!#(B
    (save-excursion
      (catch 'found
        (while (setq next (previous-single-property-change (point) 'anchorhead))
          (goto-char next)
          (cond
           ;; name
           ((and (eq 'form (get-text-property (point) 'anchortype))
                 (setq name (get-text-property (point) 'name)))
            (setq name-value name))
           ;; msg (comment)
           ((and (eq 'form (get-text-property (point) 'anchortype))
                 (setq msg (get-text-property (point) 'comment)))
            (setq msg-value msg))
           ;; subject
           ((and (eq 'form (get-text-property (point) 'anchortype))
                 (setq subject (get-text-property (point) 'subject)))
            (setq subject-value subject))
           ;; msg (message)
           ((and (eq 'form (get-text-property (point) 'anchortype))
                 (setq msg (get-text-property (point) 'message)))
            (setq msg-value msg)))
          (when (or (and name-value msg-value)
                    (and name-value subject-value msg-value))
            (throw 'found t)))))

    (setq ret (list (cons "name" name-value)
                    (cons "msg" msg-value)))
    (when subject-value (setq ret (cons (cons "subject" subject-value) ret)))

    ;; reply-no $B$rC5$9!#(B
    (when (string= plugin "pcomment")
      (save-excursion
        (let ((start (previous-single-property-change (point) 'pcomment-start))
              (end (previous-single-property-change (point) 'pcomment-end))
              next no)
          (goto-char start)
          (while (< (setq next (next-single-property-change
                                (point) 'anchorhead nil end)) end)
            (progn
              (goto-char next)
              (cond
               ;; reply-no
               ((and (eq 'radio (get-text-property (point) 'anchortype))
                     (setq no (get-text-property (point) 'radio))
                     (eq 'yes (get-text-property (point) 'select)))
                (setq reply-no no))))))

        (when reply-no
          (add-to-list 'ret (cons "reply" reply-no)))))
    ret))

(defvar pukiwiki-view-form-name-history nil)
(defvar pukiwiki-view-form-comment-history nil)
(defvar pukiwiki-view-form-subject-history nil)
(defvar pukiwiki-view-form-message-history nil)
(defun pukiwiki-view-comment-form-text-input-get-name ()
  (let* ((name-default pukiwiki-view-comment-form-name-default)
         (ret (cons "name"
                    (read-string
                     (if name-default
                         (format "Name (%s): " name-default)
                       (format "Name : "))
                     nil 'pukiwiki-view-form-name-history name-default))))
    (message nil)
    ret))

(defun pukiwiki-view-comment-form-text-input-get-comment ()
  (let ((ret (cons "msg" (read-string "Comment: " nil
                                      'pukiwiki-view-form-comment-history
                                      nil))))
    (message nil)
    ret))

(defun pukiwiki-view-comment-form-text-input-get-subject ()
  (let ((ret
         (cons "subject" (read-string "Subject: " nil
                                      'pukiwiki-view-form-subject-history
                                      nil))))
    (message nil)
    ret))

(defun pukiwiki-view-comment-form-text-input-get-message ()
  (let ((ret
         (cons "msg" (read-string "Message: " nil
                                  'pukiwiki-view-form-message-history
                                  nil))))
    (message nil)
    ret))

(defun pukiwiki-view-comment-form-text-input-get-str-from-buffer
  (buf pos type)
  (let ((ibuf (generate-new-buffer "*pukiwiki view form textarea*"))
        (obuf buf) (opos pos)
        (current-window (selected-window)))
    ;; create buffer of text area.
    (set-buffer ibuf)
    (pukiwiki-view-form-textarea-mode)

    ;; set up local variables.
    (setq pukiwiki-view-form-textarea-orig-buf obuf)
    (setq pukiwiki-view-form-textarea-orig-pos opos)
    (setq pukiwiki-view-form-textarea-orig-type type)
    (setq
     pukiwiki-view-form-textarea-orig-wincfg (current-window-configuration))

    ;; split window.
    (let ((height (- (window-height current-window)
                     pukiwiki-view-form-textarea-buffer-height)))
      (split-window current-window (max window-min-height height))
      (select-window (next-window))
      (switch-to-buffer ibuf))))

(defun pukiwiki-view-comment-form-text-input-get-replyno ()
  (let ((ret (read-string "Reply No: " nil t nil))) (message nil) ret))

(defun pukiwiki-view-comment-form-insert (form-type)
  (let* ((type form-type)
         (add (cond
               ((eq type 'comment) pukiwiki-view-form-elem-comment-list)
               ((eq type 'pcomment) pukiwiki-view-form-elem-pcomment-list)
               ((eq type 'article) pukiwiki-view-form-elem-article-list)
               ((eq type 'all) (apply 'append
                                      pukiwiki-view-form-elem-comment-list
                                      pukiwiki-view-form-elem-pcomment-list
                                      pukiwiki-view-form-elem-article-list))))
         (list (append pukiwiki-view-form-elem-list add))
         reply-list)
    ;; form data $B$r<h$C$FMh$k!#(B
    (setq result-list nil)
    (let ((form-list (pukiwiki-view-form-data-get))
          ret-list)
      (setq result-list
            (mapcar
             (lambda (form)
               (let (pos key val ret (reply-count 0))
                 (while
                     ;; key . value $B$N(B pair $B$r8!:w!#(B
                     (string-match
                      "\\s-+\\([a-zA-Z0-9_]+\\)=\"\\([^\"]+\\)\""
                      form pos)
                   (setq pos (match-end 0))
                   ;; pair $B$,B7$C$?$+%A%'%C%/!#(B
                   (cond
                    ((string= (match-string 1 form) "name")
                     (setq key (match-string 2 form)))
                    ((string= (match-string 1 form) "value")
                     (setq val (match-string 2 form))))
                   (when (and key val)
                     ;; pair $B$,B7$C$?$i(B cons $B$K$7$FJV$9!#(B
                     ;; `reply' $B$O(B nest $B$5$;$k!#(B
                     (if (string= key "reply")
                         ;; $BL>A0F~NO$N(B input $B%?%0$K$"$k(B `reply' $B$OL5;k$9$k!#(B
                         (when (not (string= val "0"))
                           (progn
                             (setq reply-list
                                   (cons (cons
                                          (setq reply-count (1+ reply-count))
                                          val) reply-list))))
                       (setq ret (cons (cons key val) ret)))
                     (setq key nil
                           val nil)))
                 ;; reply $B$NJ,$r(B ret $B$K!#(B
                 (when reply-list
                   (setq ret (cons (cons "reply" (list reply-list)) ret))
                   (setq reply-list nil))
                 ret)) form-list))

      ;; comment, pcomment $B0J30$N(B form $B$r=|30$9$k!#(B
      (setq result-tmp-list result-list)
      (setq result-list nil)
      (while (setq form-elems (car result-tmp-list))
        (when (string-match "\\(p*comment\\|article\\)"
                            (cdr (assoc "plugin" form-elems)))
          (setq result-list (cons form-elems result-list)))
        (setq result-tmp-list (cdr result-tmp-list)))
      ;; (setq result-list (nreverse result-list))
      (ignore))

    ;; $B%P%C%U%!$X$N@_Dj!#(B
    (pukiwiki-view-comment-form-insert-subr result-list)
    ))

(defun pukiwiki-view-comment-form-insert-subr (list)
  (let ((elements-list list) plugin-type)
    (save-excursion
      (goto-char (point-min))
      ;;;;;; (switch-to-buffer (current-buffer)) ;;;;; for degug.
      (while (re-search-forward
              "^#\\(p*comment\\|article\\)\\(([^)]*)\\)*$"
              nil t)
        (setq plugin-type (match-string 1))
        (forward-line 1)
        (when pukiwiki-view-form-text-input-style
          (cond
           ((or (eq pukiwiki-view-form-text-input-style 'form)
                (eq pukiwiki-view-form-text-input-style 'large))
            ;; name input.
            (insert "\n\n")
            (forward-line -1)
            (pukiwiki-view-comment-form-insert-input 'name "")
            (cond
             ((string-match "p*comment" plugin-type)
              ;; comment input.
              (insert "\n")
              (forward-line -1)
              (pukiwiki-view-comment-form-insert-input 'comment ""))
             ((string= plugin-type "article")
              ;; subject input.
              (insert "\n")
              (forward-line -1)
              (pukiwiki-view-comment-form-insert-input 'subject "")
              ;; message (comment-extra) input.
              (insert "\n")
              (forward-line -1)
              (pukiwiki-view-comment-form-insert-input 'message ""))
             (t nil)))
           (t nil))
          ;; submit button.
          (insert (concat "  ["
                          (let ((elem (car elements-list)))
                            (or (cdr (assoc (cdr (assoc "plugin" elem)) elem))
                                "$B%3%a%s%H$NA^F~(B")) ; pcomment $B$N;~$@$1JQ$@!#(B
                          "]\n\n"))
          (forward-line -2)
          (pukiwiki-view-comment-form-insert-property-set
           (car elements-list) 'button 2)
          (setq elements-list (cdr elements-list)))
        ))))

(defun pukiwiki-view-comment-form-insert-input (type data)
  (let* ((prefix "  ")                  ; $BCJMn@07A$5$l$F$7$^$C$F%U%)!<%^%C%H$,(B
         ; $BJx$l$F$7$^$&$?$a!"@07A:Q$_%F%-%9%H$H(B
         ; $BG'<1$5$;$k$?$a$KI,MW!#(B
         (prompt (cond ((eq type 'name) "$BL>A0(B ")
                       ((eq type 'comment) "$B%3%a%s%H(B ")
                       ((eq type 'subject) "$BBjL>(B ")
                       ((eq type 'message) "$B5-;v(B ")))
         (len (cond ((eq type 'name)
                     pukiwiki-view-comment-form-name-field-width)
                    ((eq type 'comment)
                     pukiwiki-view-comment-form-comment-field-width)
                    ((eq type 'subject)
                     pukiwiki-view-comment-form-subject-field-width)
                    ((eq type 'message)
                     pukiwiki-view-comment-form-message-field-width)))
         (str (if data
                  (format (concat "%-" (number-to-string len) "s") data)
                (make-string len ? )))
         (offset (length (concat prefix prompt))))

    ;; $B%P%C%U%!$X$NI=<(%G!<%?$K2~9T$,4^$^$l$F$$$l$PL58z$K!#(B
    (while (string-match "\n+" str)
      (setq str (replace-match "" nil nil str)))
    ;; $B%3%a%s%H$N>l9g$O!"J];}$9$k%G!<%?$K4^$^$l$k2~9T$bL58z$K!#(B
    (when (eq type 'comment)
      (while (string-match "\n+" data)
        (setq data (replace-match "" nil nil data))))

    (when (> (string-width str) len)
      (setq str (pukiwiki-truncate-string str len)))
    (insert (concat prefix prompt "[" str "]"))
    (pukiwiki-view-comment-form-insert-property-set data type offset)))

(defun pukiwiki-truncate-string (str width)
  "pukiwiki-mode $BMQ$N(B truncate-string.

STR $B$G;XDj$5$l$?J8;zNs$N@hF,$+$i!"(BWIDTH $B$G;XDj$5$l$?N.$5J,$NJ8;zNs$r(B
$B<h$j=P$7$FJV$7$^$9!#C<?t$,H/@8$7$?>l9g$O!"6uGr$r%Q%G%#%s%0$7$^$9!#(B"

  (let ((start 0) (end 1) (index 0) (len 0) ret-str rest)
    (catch 'length-over
      (while (setq c (substring str start end))
        (if (<= (setq len (+ (char-width (aref c index)) len)) width)
            (progn
              (if ret-str
                  (setq ret-str (format "%s%s" ret-str c))
                (setq ret-str (format "%s" c)))
              (setq rest (- width len))
              (setq start (1+ start))
              (setq end (1+ start)))
          (throw 'length-over t))))
    (if rest
        (setq ret-str (format "%s%s" ret-str (make-string rest ? ))))
    ret-str))

(defun pukiwiki-view-comment-form-insert-property-set (str type offset)
  (let ((start (+ (line-beginning-position) offset))
        (end (line-end-position))
        (prop (or str "")))
    ;; text property set.
    (add-text-properties start end
                         (list 'anchor t 'anchortype 'form
                               type prop) nil)
    (add-text-properties (1+ start) (+ start 2) (list 'anchorhead t) nil)
    ;; overlay set.
    (setq ovr (make-overlay start end))
    (overlay-put ovr 'face 'pukiwiki-view-button-face)
    (overlay-put ovr 'priority 1)
    (goto-char end))
  (forward-line 1))

(defvar pukiwiki-view-comment-form-reply-level 2
  "The level of comment to enable reply.")

(defun pukiwiki-view-comment-form-pcomment-reformat ()
  (save-excursion
    (let* ((reg-end (point))
           (reg-start (progn
                        (re-search-backward "^#pcomment" nil t)
                        (point)))
           (reply-no 0)
           mark)
      (narrow-to-region reg-start reg-end)

      ;; pcomment $BA^F~ItJ,$N3+;O0LCV@_Dj!#(B
      (goto-char (point-min))
      (add-text-properties (point) (1+ (point))
                           (list 'pcomment-start t) nil)

      (while (re-search-forward "^\\(\\s-*\\)\\(_\\)" nil t nil)
        ;; level 2 $B$^$G$@$1JQ49!#(B
        (when (< (length (match-string 1))
                 (1+ (* pukiwiki-view-comment-form-reply-level 2)))
          (setq reply-no (1+ reply-no))
          (let* ((start (match-beginning 2))
                 (end (match-end 2)))
            ;; $B9TF,ItJ,$N5-9f$rCV49!#(B
            (cond
             ((or (eq pukiwiki-view-form-text-input-style 'form)
                  (eq pukiwiki-view-form-text-input-style 'large))
              (setq mark " "))
             ((eq pukiwiki-view-form-text-input-style 'ask)
              (setq mark (number-to-string reply-no)))
             (t nil))
            (replace-match (concat "[" mark "]") t nil nil 2)
            ;; property, overlay $B$r@_Dj!#(B
            (cond
             ((or (eq pukiwiki-view-form-text-input-style 'form)
                  (eq pukiwiki-view-form-text-input-style 'large))
              ;; $B@h$KCV49$7$F$7$^$&$N$G!"(Bpoint $B$rD4@0!#(B
              (let ((start (1+ start))
                    (end (1+ end)))
                ;; property set.
                (pukiwiki-set-content-anchor-property
                 start end 'radio reply-no nil 0 'select 'no)
                ;; overlay set.
                (setq ovr (make-overlay start end))
                (overlay-put ovr 'face 'pukiwiki-view-button-face)
                (overlay-put ovr 'priority 1)))))))

      ;; pcomment $BA^F~ItJ,$N=*N;0LCV@_Dj!#(B
      (goto-char (point-max))
      (add-text-properties (1- (point)) (point)
                           (list 'pcomment-end t) nil)
      (widen))))

(defun pukiwiki-view-form-data-get ()
  "form data $B$r<h$C$FMh$k!#(B"

  (let* ((pagename
          (if (string= major-mode 'pukiwiki-index-mode)
              (nth 1 (pukiwiki-index-page-info-current-line))
            pukiwiki-pagename))
         (url nil)
         (site-info pukiwiki-site-info)
         (site-url (pukiwiki-site-url))
         (site-name (car pukiwiki-site-info))
         buf)
    (message "Getting form data...")

    ;; $BI=<(7A<0$N%=!<%9$r<hF@$7!"%P%C%U%!$r@8@.!#(B
    (setq current-buffername (concat " *pukiwiki form tmp*"))
    (let* ((url site-url)
           (pukiwiki-auto-insert nil))

      (setq form-list nil)

      ;; form data $B$NCj=P!#(B
      (save-current-buffer
        (setq buf (pukiwiki-view-comment-form-create-buffer
                   url pagename site-info current-buffername))
        (set-buffer buf)
        (goto-char (point-min))
        (if (catch 'end-tag-nothing
              (while (re-search-forward "<form action=" nil t)
                (setq start (match-beginning 0))
                (unless (re-search-forward "</form>" nil t)
                  (throw 'end-tag-nothing t))
                (setq end (match-end 0))
                (setq form-list
                      (cons (buffer-substring-no-properties start end)
                            form-list))))
            (progn (setq error-flag t)
                   (message "form tag no match!"))))
      (kill-buffer buf)

      (message "Getting form data... done.")
      form-list)))

(defun pukiwiki-view-comment-form-create-buffer (url pagename site-info
                                                     buffername
                                                     &optional backup day)
  (let ((raw backup)
        get-buf content)
    (setq get-buf
          (pukiwiki-http-request
           'get "read" pagename url (pukiwiki-site-coding-system site-info)))
    (set-buffer get-buf)
    (setq content (buffer-substring-no-properties (point-min) (point-max)))
    (setq temp-buf (generate-new-buffer buffername))
    (set-buffer temp-buf)
    (insert content)
    temp-buf))

(defun pukiwiki-insert-contents ()
  "$BL\<!$rA^F~$9$k(B"
  (let ((chapter nil) (lst nil) (list-cons nil) (number 0) (start nil))
    (save-excursion
      (save-current-buffer
        (goto-char (point-min))
        (while (re-search-forward "^[*]+[^\n\r]+" nil t)
          (setq number (1+ number))
          (pukiwiki-set-content-anchor-property
           (match-beginning 0) (match-end 0) 'header number)
          (setq chapter
                (cons
                 (cons
                  (buffer-substring-no-properties
                   (match-beginning 0)
                   (match-end 0))
                  number)
                 chapter)))
        (setq chapter (reverse chapter))
        (goto-char (point-min))
        (while (re-search-forward
                "^#contents" nil t)
          (forward-line 1)
          (setq lst chapter)
          (while lst
            (setq lst-cons (car lst))
            (setq start (point))
            (insert
             (concat
              " "
              (car lst-cons)
              "\n"))
            (pukiwiki-set-content-anchor-property
             start (1- (point)) 'content (cdr lst-cons))
            (setq lst (cdr lst))))))))

(defun pukiwiki-set-content-anchor-property (start end type value
                                                   &optional object headoffset
                                                   &rest list)
  (unless (get-text-property start 'anchortype)
    (let (pos)
      (when (> end
               (setq pos (or (next-single-property-change start 'anchortype)
                             end)))
        (setq end pos)))
    (add-text-properties start end
                         (list 'anchor t 'anchortype type type value)
                         object)
    (when list
      (let ((arg list))
        (while (setq type (car arg))
          (setq arg (cdr arg))
          (setq value (car arg))
          (setq arg (cdr arg))
          (add-text-properties start end (list type value) object))))

    (if headoffset
        (setq headstart (+ start headoffset))
      (setq headstart start))
    (add-text-properties headstart (1+ headstart) (list 'anchorhead t) object)))

(defun pukiwiki-set-content-chip-away-property-at ()
  (let ((pos (goto-char (point-min))) prop type)
    (save-excursion
      (while (setq pos (next-single-property-change pos 'anchorhead nil nil))
        (when (or (and (= (char-after pos) ?\n)
                       (get-text-property pos 'anchorhead))
                  (and (= (char-after pos) ? )
                       (get-text-property pos 'anchorhead)
                       (get-text-property (1+ pos) 'anchorhead)
                       (eq (setq type (get-text-property pos 'anchortype))
                           (get-text-property (1+ pos) 'anchortype))
                       (eq (get-text-property pos type)
                           (get-text-property (1+ pos) type))))
          ;; delete overlay from invalid point.
          (let ((overlays (overlays-in pos (1+ pos))))
            (while
                (setq ovr (prog1 (car overlays) (setq overlays (cdr overlays))))
              (when (overlay-get ovr 'overlay)
                (move-overlay ovr
                              (1+ (overlay-start ovr)) (overlay-end ovr)))))
          ;; delete properties from invalid point.
          (set-text-properties pos (1+ pos) nil))))))

;; $B@_Dj$N@Z$jBX$($K;HMQ$9$k!#(B
(defvar pukiwiki-view-local-variables
  (list '(pukiwiki-jump-display-window-top . 0)
        '(pukiwiki-jump-display-window-top-without-content . 1)
        '(pukiwiki-jump-display-window-top-only-header . 2)
        '(pukiwiki-jump-display-window-upper-margin . 3)
        '(pukiwiki-jump-display-window-top-skip-visible-url . 4)))

(defun pukiwiki-view-local-style-set (&optional arg)
  (interactive "P")
  (message
   "Select Style: D)efault L)Page feed by Link H)Page feed by Header Q)uit")
  (let ((c (downcase (read-char)))
        quit)
    (cond
     ((= c ?d) (setq list nil))            ; $B=i4|@_Dj$KLa$9!#(B
     ((= c ?l) (setq list '(t t nil 2 t))) ; $B%j%s%/%"%s%+!<$G%Z!<%8Aw$j%b!<%I!#(B
     ((= c ?h) (setq list '(t t t 1 nil))) ; $B8+=P$7%"%s%+!<$G%Z!<%8Aw$j%b!<%I!#(B
     ((= c ?q) (progn (setq list nil) (setq quit t))) ; $B=*N;!#(B
     (t (setq quit t)))

    (if quit
        (message "quit.")
      (unless (local-variable-p
               (car (car pukiwiki-view-local-variables)) (current-buffer))
        (mapcar (lambda (cell) (make-local-variable (car cell)))
                pukiwiki-view-local-variables))

      ;; $B%P%C%U%!%m!<%+%kJQ?t$KB+G{!#(B
      (if (null list)
          ;; $B=i4|CM$KLa$9$?$a$K!"%P%C%U%!%m!<%+%kJQ?t$r:o=|!#(B
          (mapcar 'kill-local-variable
                  (mapcar 'car pukiwiki-view-local-variables))
        (mapcar (lambda (cell) (set (car cell) (nth (cdr cell) list)))
                pukiwiki-view-local-variables))

      (message (concat
                "view style to <"
                (cond
                 ((= c ?l) "Page feed by Link")
                 ((= c ?h) "Page feed by Header")
                 ((= c ?n) "Nomal"))
                "> style.")))))

;; page history of pukiwiki-view-mode.
(defvar pukiwiki-view-jump-page-history nil
  "$B4J0WMzNr$N%j%9%H!#(B")
(defvar pukiwiki-view-jump-page-history-push-inhibit nil
  "$BMzNr$X$N(B push $B$rM^@)$9$kJQ?t!#(B
$BMzNr$rLa$kF0:n$N$H$-(B t $B$KB+G{$9$k!#$=$l0J30$O(B nil $B$N$^$^!#(B")

(defun pukiwiki-view-jump-page-history-push (name pos inf)
  (when (and (not (and
                   (string= name (car (car pukiwiki-view-jump-page-history)))
                   (= pos (cadr (car pukiwiki-view-jump-page-history)))))
             (not (string= name pagename)))
    (let ((history (cons (list name pos inf) pukiwiki-view-jump-page-history))
          (inhibit pukiwiki-view-jump-page-history-push-inhibit))
      (when (and (not inhibit) name pos)
        (setq pukiwiki-view-jump-page-history history)
        ;; $BMzNrJ];}$N:GBg?t$rD6$($?$i!":G8E$N$b$N$+$i:o=|$9$k!#(B
        (when (> (length pukiwiki-view-jump-page-history)
                 pukiwiki-view-jump-page-history-keep-count)
          (setq pukiwiki-view-jump-page-history
                (nreverse
                 (cdr (nreverse pukiwiki-view-jump-page-history)))))))))

(defun pukiwiki-view-jump-page-history-pop ()
  (let ((history (car pukiwiki-view-jump-page-history)))
    (setq pukiwiki-view-jump-page-history
          (cdr pukiwiki-view-jump-page-history))
    history))

(defvar pukiwiki-command-at-index nil
  "displary page $B4XO"%3%^%s%I$,(B index buffer $B$G<B9T$5$l$?>l9g$@$1(B t $B$K$J$k!#(B")

(defun pukiwiki-index-view-backward-page ()
  (interactive)
  (let ((pukiwiki-command-at-index t))
    (other-window 1)
    (pukiwiki-view-backward-page)))

(defun pukiwiki-view-backward-page ()
  (interactive)
  (let* ((history-info (pukiwiki-view-jump-page-history-pop))
         (page-info (cons (car history-info) (car (cdr history-info))))
         (site-info (car (cddr history-info)))
         (name (car page-info))
         (pos (cdr page-info))
         (pukiwiki-view-jump-page-history-push-inhibit t))
    (if history-info
        (pukiwiki-view-display-page name pos site-info)
      (message "history is empty."))))

(defadvice pukiwiki-display-page (around
                                  pukiwiki-view-jump-page-advice-around
                                  activate)
  (let ((blist (buffer-list))
        prev buf name pos inf)
    (if (catch 'found
          (while (setq buf (car blist))
            (save-excursion
              (set-buffer buf)
              (if (string-match "Pukiwiki View" mode-name)
                  (throw 'found t)
                (setq blist (cdr blist))))))
        (setq prev buf))
    (when prev
      (save-excursion
        (set-buffer prev)
        ;; $B4X?tK\BN$N<B9T8e$K(B push $B$9$k>pJs$rJ];}!#(B
        (setq name pukiwiki-pagename)
        (setq pos (point))
        (setq inf pukiwiki-site-info)))

    ;; pukiwiki-display-page
    ad-do-it

    (let ((ret ad-return-value))
      (if (and ret name pos inf)
          (unless pukiwiki-view-jump-page-history-push-inhibit
            ;; $B@5>o$KI=<($G$-!"(Binhibit $B$G$J$1$l$P!"MzNr$r(B push $B$9$k!#(B
            ;; $B:#$N$H$3$m!"(Binhibit $B$J$N$O(B backward $B$N$H$-$N$_!#(B
            (pukiwiki-view-jump-page-history-push name pos inf))))))

(defun pukiwiki-view-goto-page (&optional pagename)
  "$B%Z!<%8$rI=<($9$k!#(B"
  (interactive)
  (let ((page pagename))
    (unless page
      (setq page
            (pukiwiki-read-pagename
             (or (get-text-property (point) 'pagename)
                 (pukiwiki-word-at-point)
                 "")
             (pukiwiki-site-name))))

    (pukiwiki-view-display-page-wrap page)))

(defun pukiwiki-view-display-page-wrap (pagename)

  (let ((page pagename)
        (replacement pukiwiki-pagename))
    ;; $BAjBP;XDj$J$i40A4;XDj$K!#(B
    (when (string-match "^\\.[./]*" pagename)
      (setq len (- (match-end 0) (match-beginning 0)))
      (save-match-data
        (if (< len 3)
            (setq replacement
                  (concat (pukiwiki-view-chip-path replacement 0) "/"))
          (setq replacement
                (pukiwiki-view-chip-path replacement (/ len 3)))))
      (when replacement
        (setq page (replace-match replacement nil nil pagename)))
      (when (string-match "/+$" page)
        (setq page (replace-match "" nil nil page))))

    ;; 2004.09.26 InterWikiName
    (setq iwn-site-info nil)
    (when (string-match "^\\([^:]+\\):\\(.+\\)$" page)
      (setq interwikiname (match-string 1 page))
      (setq page (match-string 2 page))
      (setq iwn-site-info
            (assoc interwikiname
                   (pukiwiki-view-get-localvarialbe-from-index-buffer
                    pukiwiki-site-info
                    'pukiwiki-index-interwiki-info-list))))

    (if (string-match "^\\([^#]+\\)#\\(.+\\)$" page)
        (progn (setq pname (match-string 1 page))
               (setq aname (match-string 2 page))
               (unless (string= pname pukiwiki-pagename)
                 (pukiwiki-view-display-page pname 1 iwn-site-info))
               (pukiwiki-view-jump-to-aname aname))
      (pukiwiki-view-display-page page 1 iwn-site-info))))

(defun pukiwiki-view-chip-path (path count)
  "$B3,AX9=B$$N%Z!<%8L>$+$i!":G2<0L$N;XDj$5$l$??t$N(B page name $B$r:o$.Mn$7(B
$B$?(B path $B$rJV$7$^$9!#(B"

  (let ((start 0) idx-list)
    (while (string-match "/" path start)
      (setq idx-list (cons (match-end 0) idx-list))
      (setq start (match-end 0)))
    (setq idx-list (cons (length path) idx-list))

    (if (> (length idx-list) count)
        (substring path 0 (nth count idx-list))
      "")))

(defun pukiwiki-word-at-point ()
  "$B%]%$%s%H0LCV$NC18l$rJV$9!#(B"
  (save-excursion
    (progn (forward-word 1)             ; $BJd@5!#(B
           (forward-word -1))
    (buffer-substring-no-properties (point) (progn (forward-word 1) (point)))))

(defun pukiwiki-view-get-localvarialbe-from-index-buffer (site-info val)
  "$BEv3:(B view buffer $B$,B0$9$k(B site $B$N>pJs$r!"(Bindex buffer $B$+$i<hF@$9$k!#(B"

  (let ((info site-info)
        (buf (pukiwiki-index-get-buffer-create site-info)))
    (save-current-buffer
      (save-excursion
        (set-buffer buf)
        (eval val)))))

(defun pukiwiki-view-display-page (page-name &optional
                                             position goto-site-info refetch)
  "$B;XDj$5$l$?%Z!<%8L>$N%Z!<%8$rI=<($9$k!#(B

REFETCH $B$,(B nil $B$G$9$G$K%P%C%U%!$,B8:_$9$k$J$i!"(BHTTP GET $B$7$J$$!#(B"
  (let ((site-info (or goto-site-info pukiwiki-site-info))
        (info-list pukiwiki-index-page-info-list)
        (attach-list pukiwiki-index-attach-list)
        (pagename page-name)
        ;;;;;;;;;; (prev-page pukiwiki-pagename)
        (pos position)
        search-word)
    (catch 'faild-get
      (progn
        (when site-info
          (unless (pukiwiki-display-page pagename site-info refetch)
            (message nil)
            (throw 'faild-get t))
          (unless (string-match "Pukiwiki View" mode-name)
            ;; $B4{$K(B pukiwiki-view-mode $B$J$i!"4{B8%P%C%U%!$X$N0\F0$J$N$G!"(B
            ;; $B@07A=hM}$O9T$J$o$J$$$GNI$$!#(B
            (pukiwiki-view-mode)

            (setq pukiwiki-prev-buffer nil)
            (setq pukiwiki-pagename pagename)
            (setq pukiwiki-site-info site-info)
            (setq pukiwiki-index-page-info-list info-list)
            (setq pukiwiki-index-attach-list attach-list)
            (condition-case err
                (if hi-lock-mode
                    ()
                  (hi-lock-mode 1))
              (error
               ()))
            (if (and
                 search-word
                 (functionp 'hi-lock-face-buffer))
                (hi-lock-face-buffer search-word 'region))

            ;; $BI=<(2hLL$r@07A(B
            (pukiwiki-view-reformating)
            )

          (set-buffer-modified-p nil)
          (setq buffer-read-only t)
          (if pos (goto-char pos)
            (goto-char (point-min))
            ;;;;;;;;;; 2004.09.14 $B$3$l$O$I$&$+$J(B??
            ;;;;;;;;;; $B$I$&$7$F$b(B current-face $B$,>C$($J$$$s$@$,!#(B
            (run-hooks 'pukiwiki-index-post-command-hook)))

        (when (not pukiwiki-command-at-index) (setq view-buf (current-buffer)))
        (other-window 1)

        (pukiwiki-index site-info nil pagename)
        (pukiwiki-view-set-index-current-line pagename)

        (when (not pukiwiki-command-at-index)
          (run-hooks 'pukiwiki-index-post-command-hook)
          (pop-to-buffer view-buf))
        ))
    ))

(defun pukiwiki-view-set-index-current-line (pagename)
  (let ((site-info pukiwiki-site-info)
        (page pagename)
        (buf (pukiwiki-index-get-buffer-create site-info)))
    (set-buffer buf)
    (goto-char (point-min))
    (when pagename
      (catch 'point-set
        (dolist (elm pukiwiki-index-page-info-list)
          (when (string= (nth 1 elm) pagename)
            (re-search-forward (format "^%4d" (nth 0 elm)))
            (beginning-of-line)
            (recenter)
            (throw 'point-set t)))))))

(defun pukiwiki-view-return-function (&optional opt)
  (interactive)
  ;; anchor property $B$,L5$1$l$P=>Mh$NF0:n$r!#(B
  (if (pukiwiki-point-anchor-p)
      (cond
       ;; url.
       ((pukiwiki-point-anchor-url-p)
        (browse-url (get-text-property (point) 'url)))
       ;; link of wiki.
       ((pukiwiki-point-anchor-pagename-p)
        (setq page (get-text-property (point) 'pagename))
        (pukiwiki-view-display-page-wrap page))
       ;; form button.
       ((pukiwiki-point-anchor-form-buttom-p)
        (pukiwiki-view-form-submit (get-text-property (point) 'button)))
       ;; select radio button.
       ((pukiwiki-point-anchor-form-radio-buttom-p)
        (pukiwiki-view-form-select-radio-button
         (get-text-property (point) 'select)))
       ;; form input.
       ((pukiwiki-point-anchor-form-input-name-p) ; name
        (pukiwiki-view-form-input 'name (get-text-property (point) 'name)))
       ((pukiwiki-point-anchor-form-input-comment-p) ; comment
        (pukiwiki-view-form-input 'comment
                                  (get-text-property (point) 'comment)))
       ((pukiwiki-point-anchor-form-input-subject-p) ; subject
        (pukiwiki-view-form-input 'subject
                                  (get-text-property (point) 'subject)))
       ((pukiwiki-point-anchor-form-input-message-p) ; message
        (pukiwiki-view-form-input 'message
                                  (get-text-property (point) 'message)))

       (t
        (pukiwiki-jump-content-anchor)))
    (pukiwiki-edit-new-line)))

(defun pukiwiki-view-return-contents (&optional opt)
  (interactive)
  (end-of-line)
  (if (re-search-backward "^*" nil t)
      (if (pukiwiki-point-anchor-p)
          (pukiwiki-jump-content-anchor)
        (goto-char (point-min))
        (re-search-forward "^#contents" nil t))
    (goto-char (point-min))
    (re-search-forward "^#contents" nil t)))

(defun pukiwiki-point-anchor-url-p ()
  (let* ((atype (get-text-property (point) 'anchortype))
         (type (get-text-property (point) 'anchor)))
    (when (and type (eq atype 'url)) t)))

(defun pukiwiki-point-anchor-pagename-p ()
  (let* ((atype (get-text-property (point) 'anchortype))
         (type (get-text-property (point) 'anchor)))
    (when (and type (eq atype 'pagename)) t)))

(defun pukiwiki-point-anchor-form-buttom-p ()
  (let* ((atype (get-text-property (point) 'anchortype))
         (type (get-text-property (point) 'anchor))
         (button (get-text-property (point) 'button)))
    (when (and type (eq atype 'form)) t) button))

(defun pukiwiki-point-anchor-form-radio-buttom-p ()
  (let* ((atype (get-text-property (point) 'anchortype))
         (type (get-text-property (point) 'anchor))
         (radio (get-text-property (point) 'radio)))
    (when (and type (eq atype 'form)) t) radio))

(defun pukiwiki-point-anchor-form-input-name-p ()
  (let* ((atype (get-text-property (point) 'anchortype))
         (type (get-text-property (point) 'anchor))
         (name (get-text-property (point) 'name)))
    (when (and type (eq atype 'form)) t) name))

(defun pukiwiki-point-anchor-form-input-comment-p ()
  (let* ((atype (get-text-property (point) 'anchortype))
         (type (get-text-property (point) 'anchor))
         (comment (get-text-property (point) 'comment)))
    (when (and type (eq atype 'form)) t) comment))

(defun pukiwiki-point-anchor-form-input-subject-p ()
  (let* ((atype (get-text-property (point) 'anchortype))
         (type (get-text-property (point) 'anchor))
         (subject (get-text-property (point) 'subject)))
    (when (and type (eq atype 'form)) t) subject))

(defun pukiwiki-point-anchor-form-input-message-p ()
  (let* ((atype (get-text-property (point) 'anchortype))
         (type (get-text-property (point) 'anchor))
         (message (get-text-property (point) 'message)))
    (when (and type (eq atype 'form)) t) message))

(defun pukiwiki-jump-content-anchor-1 (type value &optional object)
  (let ((prev (point)) (type type) (value value) dest)
    (goto-char (point-min))
    (setq jump-function 'next-single-property-change))
  (if (setq dest
            (pukiwiki-search-point-of-destination jump-function type value))
      (let ((dest dest))
        (goto-char dest)
        (if (and pukiwiki-jump-display-window-top
                 (if pukiwiki-jump-display-window-top-without-content
                     (not (pukiwiki-point-anchor-content-p)) t))
            (let ((current dest) start)
              (save-excursion
                (forward-line (- 0 pukiwiki-jump-display-window-upper-margin))
                (setq start (point)))
              (set-window-start (selected-window) start))))))

(defun pukiwiki-jump-content-anchor (&optional object)
  (interactive)
  (let* ((atype (get-text-property (point) 'anchortype))
         (value (get-text-property (point) atype))
         type)
    (cond
     ((eq atype 'content) (setq type 'header))
     ((eq atype 'header) (setq type 'content)))
    (pukiwiki-jump-content-anchor-1 type value)))

(defun pukiwiki-point-anchor-p ()
  (get-text-property (point) 'anchor))

(defun pukiwiki-point-anchor-content-p ()
  (eq 'content (get-text-property (point) 'anchortype)))

(defun pukiwiki-point-anchor-header-p ()
  (eq 'header (get-text-property (point) 'anchortype)))

(defun pukiwiki-jump-anchor-window-top-prev (&optional opt)
  (interactive "P")
  (pukiwiki-jump-anchor-window-top t))

(defun pukiwiki-jump-anchor-window-top (&optional opt)
  (interactive "P")
  (let ((ignore pukiwiki-jump-display-window-top-skip-visible-url)
        start)
    (catch 'found
      (while (pukiwiki-jump-anchor opt)
        (if ignore
            (unless (string-match "h*ttps*" (pukiwiki-word-at-point))
              (throw 'found t))
          (throw 'found t))))
    (when (or (null pukiwiki-jump-display-window-top-only-header)
              (pukiwiki-point-anchor-header-p))
      (save-excursion
        (forward-line (- 0 pukiwiki-jump-display-window-upper-margin))
        (setq start (point)))
      (set-window-start (selected-window) start))))

(defun pukiwiki-jump-anchor (&optional opt)
  (interactive "P")
  (let* ((way opt) dest)
    (if way (setq jump-function 'previous-single-property-change)
      (setq jump-function 'next-single-property-change))
    (if (setq dest
              (pukiwiki-search-point-of-destination jump-function 'anchorhead))
        (goto-char dest)
      (if (and way (get-text-property (point-min) 'anchorhead))
          (goto-char (point-min))))))

(defun pukiwiki-jump-anchor-prev (&optional opt)
  (interactive "P")
  (pukiwiki-jump-anchor t))

(defun pukiwiki-search-point-of-destination (func type &optional value)
  (save-excursion
    (let ((function func)
          (prop type)
          (value value) dest)
      (if (catch 'reaching
            (while (setq dest (funcall function (point) prop))
              (goto-char dest)
              (let ((pvalue (get-text-property (point) prop)))
                (when (if value (and pvalue (= pvalue value)) pvalue)
                  (throw 'reaching t)))))
          (point)))))

(defun pukiwiki-insert-ls2 ()
  (goto-char (point-min))
  (when pukiwiki-index-page-info-list
    ;;#ls2($B@_Dj:Q$_(BMeadow/)
    ;;#ls2
    ;;#ls2($B%Q%?!<%s(B,$B%Q%i%a!<%?(B,link$B$NJLL>I=<((B)
    (let ((pagename nil))
      (while (re-search-forward "^#ls2" nil t)
        (beginning-of-line)
        (cond
         ((re-search-forward "(\\([^,]+\\))" (line-end-position) t)
          (setq pagename
                (buffer-substring-no-properties
                 (match-beginning 1) (match-end 1))))
         ((re-search-forward "(\\([^,]+\\),.+)" (line-end-position) t)
          (setq pagename
                (buffer-substring-no-properties
                 (match-beginning 1) (match-end 1))))
         (t
          (setq pagename
                (concat
                 "^" pukiwiki-pagename "/"))))
        (end-of-line)
        (insert "\n")
        (let ((ls2 nil))
          (setq ls2
                (delete
                 nil
                 (mapcar
                  (lambda (elm)
                    (if (string-match
                         pagename (nth 1 elm))
                        (nth 1 elm)))
                  pukiwiki-index-page-info-list)))
          (while ls2
            (insert
             (concat "\n- [[" (car ls2) "]]"))
            (setq ls2 (cdr ls2))))))))

(defun pukiwiki-text-reformating ()
  "$BI=<($N;~$KFI$_$d$9$$$h$&$KE,Ev$J$H$3$m$G@^$jJV$9$J$I$N=hM}$r9T$&(B"
  (let ((pt) (end-pt) (reg "^[^ *->#\n\r]+[^\n\r]*$") str match)
    (goto-char (point-min))
    (while (re-search-forward
            "^\\(.\\).*\\(\\s-*[~]+\\(\\s-*[\n\r]\\)\\)" nil t)
      (setq match (match-string 2))
      (delete-region (match-beginning 2)
                     (match-end 2))
      (setq line-beginning-char
            (buffer-substring-no-properties (match-beginning 1) (match-end 1)))
      (cond
       ((string-match "[-+]" line-beginning-char)
        (insert "\n~"))
       ((string-match "[>]" line-beginning-char)
        (insert inner-line-feed-mark)
        (and
         (string-match "[\n\f][\n\f]+" match)
         (insert "\n")))
       ((string-match "[ |*#]" line-beginning-char)
        (insert "\n"))
       (t
        (insert inner-line-feed-mark)
        (and
         (not (eq (point) (point-max)))
         (string-match "[-+ *<\t\n\f]"
                       (buffer-substring-no-properties (point) (1+ (point))))
         (insert "\n"))))
      (beginning-of-line))

    ;; $BDj5A$rFI$_$d$9$/=hM}(B
    (goto-char (point-min))
    (pukiwiki-replace-regexp "^:\\([^|\n\r]+\\)|\\([^\n\r]*\\)$"
                             "\n\\1\n\n\t\\2\n" nil (point-min) (point-max))

    ;; $B%3%a%s%H$rFI$_$d$9$/=hM}(B
    (goto-char (point-min))
    (while (re-search-forward
            (concat
             "^[-]+\\([^\n\r]+\\)[ ]*--[ ]*[^\n\r]+\\("
             (mapconcat 'identity pukiwiki-view-comment-date-regexp "\\|")
             "\\)[^\n\r]+")
            nil t)
      (setq pt (line-beginning-position))
      (if (re-search-forward
           "\\(^$\\|^[^-\n\r]+\\)" nil t)
          (setq end-pt (- (line-beginning-position) 1))
        (setq end-pt (point-max)))
      (pukiwiki-insert-comment-str nil pt end-pt))

    ;; 2004.09.16 $B%3%a%s%H%U%)!<%`$NA^F~!#(B
    (unless (string-match "pukiwiki\\s-+[^\\s-]+\\s-+tmp"
                          (buffer-name (current-buffer)))
      (let ((flag nil))
        (save-excursion
          (goto-char (point-min))
          (when (re-search-forward
                 "^#\\(p*comment\\|article\\)\\(([^)]*)\\)*$" nil t)
            (setq flag t)))
        (when flag
          (pukiwiki-view-comment-form-insert 'all))))

    (goto-char (point-min))
    (while (re-search-forward
            "^*" nil t)
      (save-excursion
        (forward-line -1)
        (if (string=
             ""
             (buffer-substring
              (line-beginning-position)
              (line-end-position)))
            ()
          (end-of-line)
          (insert "\n"))))

    (goto-char (point-min))
    (while (re-search-forward
            "^*" nil t)
      (save-excursion
        (forward-line 1)
        (if (string=
             ""
             (buffer-substring
              (line-beginning-position)
              (line-end-position)))
            ()
          (beginning-of-line)
          (insert "\n"))))

    ;; $B9T$rE,Ev$J$H$3$m$G@^$jJV$9(B
    (goto-char (point-min))
    (while (re-search-forward
            "^\\([^-+ |*>#\n\r]+\\)[^\n\r]*$" nil t)
      (let ((str (match-string 1))
            (pos nil))
        ;; fill-region $B$r9T$J$&4V$O9TF,$N(B `~' $B$r:o=|$7$F$*$/!#(B
        (if (string-match "^~" str)
            (save-excursion
              (beginning-of-line)
              (re-search-forward "^~\\s-*" nil t)
              (delete-region (match-beginning 0) (match-end 0))
              (insert "\n")
              (setq pos (point))))
        (setq pt (line-beginning-position))
        (if (re-search-forward
             ;; $B0J2<$bCJMn3+;O$HG'<1$5$;$kMM$KDI2C!#(B
             ;; - $B9TF,$N(B `/' ($B%3%a%s%H9T(B: $B0l$D$@$1$@$1$I(B)
             ;; - $B9TF,$N(B `_' ($B@07A$5$l$?%3%a%s%H(B)
             ;; - $B9TF,$N(B `:' ($BDj5A%j%9%H(B)
             "^[-+ |*>#~/_:]+[^\n\r]*$" nil t)
            (setq end-pt (line-beginning-position)) ;;(line-end-position))
          (setq end-pt (point-max))
          (goto-char (point-max)))
        (pukiwiki-fill-region-paragraph pt end-pt)
        ;; $B9TF,$N(B `~' $B$rI|85!#(B
        (if pos (save-excursion (goto-char pos) (insert "~")))))))

(defvar inner-line-feed-mark "%%%INNER-LINE-FEED%%%")
(defun pukiwiki-fill-region-paragraph (top bottom &optional delimited)
  (let ((regexp (or delimited inner-line-feed-mark))
        (fill-start-point top)
        (fill-limit-point (make-marker))
        (limit bottom)
        indent prev-mark)
    (set-marker fill-limit-point limit)
    (goto-char fill-start-point)

    ;; $B$3$NCJMn$N<oN`$r3NG'$7!"I,MW$J$i%$%s%G%s%HNL$rF@$k!#(B
    (save-excursion
      (when (eq ?\  (char-after (point)))
        (re-search-forward "^[ ]+" nil t)
        (setq indent (length (match-string 0))))
      (forward-line -1)
      (setq prev-mark (char-after (point))))

    (catch 'range-over
      (while (setq result (re-search-forward regexp fill-limit-point t))
        (setq fill-end-point (match-beginning 0))
        (delete-region fill-end-point (match-end 0))
        ;; (setq fill-limit-point
        ;;       (- fill-limit-point (- (match-end 0) fill-end-point)))
        (fill-region fill-start-point fill-end-point)
        (if (>= (point) fill-limit-point)
            (throw 'range-over t)
          (setq fill-start-point (point))
          (when indent (insert (make-string indent ?\ )))))
      (cond ((>= (point) fill-limit-point)
             (throw 'range-over t))
            ((eq result nil)
             (if (not (= (point) fill-limit-point))
                 (fill-region (point) fill-limit-point)
               (goto-char fill-limit-point))
             (throw 'range-over t))))
    (save-excursion
      (when (and (not (eq ?\_ (char-after top)))
                 (not (and (eq ?\/ (char-after top))
                           (not (eq ?\_ (char-after (point)))))))
        (when (and (not (eq top (point-min)))
                   (not (eq ?\-  prev-mark))
                   (not (eq ?\>  prev-mark)))
          (goto-char top) (insert "\n"))
        (goto-char fill-limit-point) (insert "\n"))
      (when (and (eq ?\_ (char-after top))
                 (eq ?\-  prev-mark))
        (goto-char top) (insert "\n"))
      )
    (set-marker fill-limit-point nil)))

(defun pukiwiki-insert-attach-file-list ()
  (when pukiwiki-index-attach-list
    (let ((lst nil))
      (if (assoc pukiwiki-pagename
                 pukiwiki-index-attach-list)
          (setq lst
                (cdr
                 (assoc pukiwiki-pagename
                        pukiwiki-index-attach-list))))
      (when lst
        (goto-char (point-max))
        (insert "\n* $BE:IU%U%!%$%k(B\n\n")
        (while lst
          (insert "#ref(" (car lst) ")\n")
          (setq lst (cdr lst)))))))

;; for XEmacs.
(if (featurep 'xemacs)
    (defun x-color-defined-p (color)
      (valid-color-name-p color)))

(defun pukiwiki-set-face-color ()
  (let ((color nil) (str nil) (ov nil) start)
    (goto-char (point-min))
    (while (re-search-forward
            (if pukiwiki-auto-insert
                "&*COLOR(\\([^)]+\\)){\\([^}]+\\)};*"
              "&*COLOR(\\([^)]+\\)){\\([^}\n\r]+\\)};*")
            nil t)
      (setq color (match-string 1))
      (setq str (match-string 2))
      (setq start (match-beginning 0))
      (delete-region start (match-end 0))
      (insert str)
      (when (x-color-defined-p color)
        (setq ov (make-overlay start (point)))
        (overlay-put ov
                     'face
                     (if (featurep 'xemacs)
                         (progn
                           (make-face (intern color))
                           (set-face-foreground (intern color) color)
                           (intern color))
                       (cons (cons 'background-color "white")
                             (cons 'foreground-color color))))
        (overlay-put ov 'priority 2)))))

(defun pukiwiki-set-bold (&optional strikethru)
  (goto-char (point-min))
  (let* ((start nil) (str nil) (ov nil) (reg-start 0)
         (regexp (if pukiwiki-auto-insert
                     "\\([']['][']?\\)\\([^']*\\)\\([']['][']?\\)"
                   "\\([']['][']?\\)\\([^'\n\r]*\\)\\([']['][']?\\)"))
         (regexp (if strikethru
                     (progn
                       (while (setq reg-start
                                    (string-match "'" regexp reg-start))
                         (setq regexp (replace-match "%" nil nil regexp))
                         (setq reg-start (1+ reg-start)))
                       regexp)
                   regexp))
         (face (if strikethru 'pukiwiki-view-strikethru-face 'bold)))
    (while (re-search-forward
            regexp
            nil t)
      ;; $BFs8D0J>eO"B3$7$?2~9T(B ($B6u9T(B) $B$rD6$($k$3$H$O5v2D$7$J$$!#(B
      ;; $B$D$^$j!"CJMn$rD6$($F$N6/D4$O5v2D$7$J$$!#(B
      (catch 'next
        (let ((mstr (match-string 0)))
          (save-match-data
            (when (string-match "[\n\r][\n\r]+" mstr)
              (throw 'next t))))
        (setq start (match-string 1))
        (setq str (match-string 2))
        ;; $BA4It>C$7$F$7$^$&$H(B anchor $B$N(B overlay $B$,L58z$K$J$C$F$7$^$&$N$G!"(B
        ;; $B0zMQId$NItJ,$@$1$r:o=|$9$k!#(B
        (delete-region (match-beginning 3)
                       (match-end 3))
        (delete-region (match-beginning 1)
                       (match-end 1))

        (setq ov (make-overlay (match-beginning 0)
                               (point)))
        (if (= 2 (length start))
            (overlay-put ov 'face face)
          (overlay-put ov 'face 'italic))
        (overlay-put ov 'priority 1)))))

(defun pukiwiki-set-justification ()
  (interactive)
  (let ((just nil) (str nil) (ov nil) beg)
    (goto-char (point-min))
    (while (re-search-forward
            "\\(CENTER:\\|RIGHT:\\)\\([^\r\n]+\\)" nil t)
      (setq just (match-string 1))
      (setq str (match-string 2))
      (delete-region (match-beginning 0)
                     (match-end 0))
      (setq beg (point))
      (insert str)
      (save-excursion
        (forward-line 1)
        (if (string= (buffer-substring-no-properties
                      (line-beginning-position)
                      (line-end-position))
                     "")
            ()
          (insert "\n")
          (forward-char -1)))
      (cond
       ((string= just "CENTER:")
        (set-justification beg
                           (point)
                           'center t))
       ((string= just "RIGHT:")
        (set-justification beg
                           (point)
                           'right t)))
      (beginning-of-line))))

(defun pukiwiki-insert-cite ()
  (interactive)
  (goto-char (point-min))
  (let* ((str nil)
         (page-delimiter "^")
         (paragraph-start (concat page-delimiter "\\|^>+\\|^[ \t]*$"))
         (paragraph-start
          (if (eq ?^ (aref paragraph-start 0))
              (substring paragraph-start 1)))
         (paragraph-separate paragraph-start))
    (while (re-search-forward "\\(^[>]+\\)" nil t)
      (setq str (length (match-string-no-properties 1)))
      (delete-region (match-beginning 0)
                     (match-end 0))
      (while (and str (not (= str 0)))
        (insert "  ")
        (setq str (- str 1)))
      (beginning-of-line)
      (insert "\n")
      ;; putting overlay and filling region for part of citing.
      (let ((start (point))
            (end (save-excursion
                   ;;(re-search-forward paragraph-separate nil t)
                   ;;(line-beginning-position)
                   (line-end-position)
                   ;; $B0zMQ$J$i$3$l$GLdBj$J$$$O$:!%!%!%(B
                   )))
        ;; overlay set.
        (setq ovr (make-overlay start end))
        (overlay-put ovr 'face 'pukiwiki-view-cite-face)
        (overlay-put ovr 'priority 1)
        ;; fill region.
        (condition-case err
            (pukiwiki-fill-region-paragraph
             start end)
          (error ()))))))

(defvar pukiwiki-view-list-face 'font-lock-keyword-face) ; $B30$+$i;XDj2DG=$K!#(B
(defun pukiwiki-insert-list ()
  (goto-char (point-min))
  (let ((str nil) (level 1) (num 1))
    (while (re-search-forward "\\(^[-+]+\\)\\([ \t]*\\)" nil t)
      (let* ((start (match-beginning 1))
             (end (match-end 1))
             (margin (1+ (- (match-end 2) end)))
             (elem (match-string 0)))

        (setq str (length (buffer-substring-no-properties start end)))
        (cond
         ((and (>= str 4)
               (string= elem
                        (buffer-substring
                         (line-beginning-position) (line-end-position))))
          ;; $B?eJ?@~$K!#(B
          (delete-region (match-beginning 0) end)
          (insert-char ?\055 fill-column))
         (t
          ;; $B$=$N$^$^(B delete-region, insert $B$@$H!"D>8e$N(B property, overlay $B$N(B
          ;; $BHO0O$K4^$^$l$F$7$^$&$N$G!">/$7D4@0$9$k!#(B
          (let ((len str))
            (goto-char start)
            ;; $B@h$K(B insert $B$7$F!"(B
            (while (not (= str 1))
              (insert "  ")
              (setq str (- str 1)))
            (insert "-")
            ;; region $B$r(B delete $B$9$k!#(B
            (delete-region (point) (+ len (point))))

          (let ((fill-individual-varying-indent t)
                (paragraph-start "^\\($\\|[ ]*[-+]+\\)")
                (paragraph-separate "^[ ]*[-+ <\t\n\f]")
                (fill-end-position (make-marker)))
            ;; filling.
            (save-excursion
              ;; $B9TF,$N(B `/' $B0l$D$bCJMn3+;O07$$$K$9$k$?$aDI2C!#(B
              (unless (re-search-forward "^[ ]*[-+ /<\t\n\f]" nil t nil)
                ;; $B0J9_$KCJMnAjEv$,L5$$$N$G!"$3$l$,:G8e$N%j%9%H9`L\$H4GJo$9!#(B
                (goto-char (point-max)))
              ;; indent $B$,<!$NCJMn$N@hF,$^$GH?1G$5$l$F$7$^$&$3$H$,(B
              ;; $B$"$k$N$G!#(B
              (set-marker fill-end-position (1- (line-beginning-position))))
            (save-excursion
              ;; overlay set.
              (setq ovr
                    (make-overlay (line-beginning-position) fill-end-position))
              (overlay-put ovr 'face pukiwiki-view-list-face)
              (overlay-put ovr 'priority 1)
              ;; $B:8%^!<%8%s$r@_Dj$7$F!"CJMn5M$a9~$_!#(B
              (set-left-margin (point) fill-end-position margin)
              (condition-case err
                  (fill-individual-paragraphs (line-beginning-position)
                                              fill-end-position t)
                (error
                 (message "Error fill-individual-paragraphs: %s"
                          (error-message-string err)))))
            (set-marker fill-end-position nil))))))))

;; simple element replacing.
(defun pukiwiki-insert-simple-elements ()
  "$BC1=c$J%(%l%a%s%H$rCV49$9$k!#(B"

  (goto-char (point-min))
  (while (re-search-forward "^#\\(br\\|hr\\)" nil t)
    (cond
     ((string= (match-string 1) "br")
      (replace-match "\n"))
     ((string= (match-string 1) "hr")
      (replace-match (make-string fill-column ?\055))))))

;; paragraph formatting.
(defun pukiwiki-insert-paragraph ()
  "$BCJMn=q<0$r@07A$9$k!#(B

$BCJMn$r8=$o$99TF,=q<0J8;z(B `~' $B$,;XDj$5$l$F$$$k$H$-!"0J2<$N2U=j$K6u9T$rA^F~$9$k!#(B
- $BCJMnD>A0(B
- $B<!$K8=$o$l$kCJMn@hF,9T$ND>A0$N9T(B

$B8=>u$O$3$l$@$1$G==J,$+$H;W$$$^$9!#(B"

  (goto-char (point-min))
  ;; $BCJMn$ND>A0$K$O0l9T6u9T$rA^F~!#(B
  (while (re-search-forward "^\\(~[ ]*\\)" nil t)
    (save-excursion
      (forward-line -1)
      (unless (string-match
               "^[\\s-]*$"
               (buffer-substring (line-beginning-position) (line-end-position)))
        (end-of-line)
        (insert "\n"))))
  ;; $BCJMn$N@hF,9T$N<!$N9T$,;z2<$2!"$b$7$/$O9TF,=q<0J8;z$J$i6u9T$rA^F~!#(B
  (goto-char (point-min))
  (while (re-search-forward "^\\(~[ ]*\\)" nil t)
    (delete-region (match-beginning 0)
                   (match-end 0))
    (save-excursion
      ;; 2004.09.26 $B$b$&>/$7@:EY$r>e$2$F$_$k!#(B
      ;; (forward-line 1)
      (re-search-forward "^[-+ |*>#~/]" nil t)
      (if (string-match
           ;; $B9TF,$N(B `/' $B0l$D$bCJMn3+;O07$$$K$9$k$?$aDI2C!#(B
           "^[-+ |*>#~/]"
           (buffer-substring
            (line-beginning-position) (+ (line-beginning-position) 1)))
          (progn
            (beginning-of-line)
            (insert "\n"))))))

(defun pukiwiki-delete-blank-line ()
  (goto-char (point-min))
  (while (re-search-forward
          "^\\([ \t]+\\)$" nil t)
    (delete-region (match-beginning 1)
                   (match-end 1)))
  (goto-char (point-min))
  (while (re-search-forward
          "\\([ \t]+\\)$" nil t)
    (delete-region (match-beginning 1)
                   (match-end 1)))
  (goto-char (point-min))
  (while (re-search-forward
          "^\n[\n]+" nil t)
    (delete-region (match-beginning 0)
                   (match-end 0))
    (insert "\n"))
  (goto-char (point-max))
  (delete-blank-lines))

(defun pukiwiki-set-auto-face ()
  (when pukiwiki-auto-face
    (pukiwiki-set-bold)
    (pukiwiki-set-bold 'strikethru)
    (pukiwiki-set-face-color)
    (pukiwiki-set-justification)))

(defun pukiwiki-mode-auto-insert ()
  (save-excursion
    ;; with delete url description.
    (pukiwiki-insert-anchor
     (cdr (assoc 'delete-url-description pukiwiki-style-anchor-regexp-alist)))

    (pukiwiki-insert-aname)
    ;; $B5-=R$N:o=|$,H<$J$&$N$G!"@07AA0$K0\F0!#(B
    (pukiwiki-set-auto-face)

    (pukiwiki-text-reformating)
    (pukiwiki-insert-paragraph)
    (pukiwiki-insert-cite)
    (pukiwiki-insert-comment)           ; include pukiwiki-insert-anchor().
    (pukiwiki-insert-list)
    (pukiwiki-insert-ls2)
    (pukiwiki-insert-simple-elements)

    ;; to leave url description.
    (pukiwiki-insert-anchor
     (cdr (assoc 'leave-url-description pukiwiki-style-anchor-regexp-alist)))

    (pukiwiki-insert-attach-file-list)
    ;; $B5-=R$N:o=|$,H<$J$&$N$G!"@07AA0$K0\F0!#(B
    ;; (pukiwiki-set-auto-face)
    (pukiwiki-delete-blank-line)
    (pukiwiki-set-content-chip-away-property-at)
    (pukiwiki-replace-tilda-to-blank-line)
    ))

(defun pukiwiki-replace-tilda-to-blank-line ()
  ;; $B$3$3$^$GMh$F;D$C$F$$$k(B `~' $B$O6u9T$NH&$J$N$G!#(B
  (goto-char (point-min))
  (while (re-search-forward "~\\s-*$" nil t)
    (replace-match "\n" nil nil)))

(defun pukiwiki-insert-aname ()
  (goto-char (point-min))
  (let ((pos (point)))
    (when pukiwiki-auto-anchor
      (while (re-search-forward "&aname(\\([^)]+\\));" nil t)
        (let ((start (match-beginning 0))
              (end (match-end 0))
              (anchor-name (match-string 1)))
          ;; aname element delete.
          (delete-region start end)
          (setq end (1+ start))
          ;; property set.
          (add-text-properties start end (list 'aname anchor-name))
          ))))
  ;; $B8+=P$7;2>H$r(B anchor $B$K!#(B
  (goto-char (point-min))
  (let ((pos (point)))
    (when pukiwiki-auto-anchor
      (while
          (re-search-forward "^\\s-*\\*+.+\\[+\\([^]]+\\)\\]+[^\n\r]*$" nil t)
        (let ((start (match-beginning 1))
              (end (match-end 1))
              (anchor-name (match-string 1)))
          ;; aname element delete.
          (delete-region start end)
          (setq end start)
          ;; $BA08e$N(B bracket $B$r:o$k!#(B
          (pukiwiki-view-chip-away-bracket-around-region start end)
          ;; property set.
          (setq anchor-name
                (when (string-match "^#\\(.+\\)$" anchor-name)
                  (match-string 1 anchor-name)))
          (setq start (line-beginning-position))
          (unless (get-text-property start 'aname)
            (setq end (line-end-position))
            (let (pos)
              (when (> end (setq pos
                                 (or (next-single-property-change start 'aname)
                                     end)))
                (setq end pos)))
            (add-text-properties (line-beginning-position) end
                                 (list 'aname anchor-name)))
          )))))

(defun pukiwiki-view-jump-to-aname (aname)
  (let ((pos (point))
        pos1 found res)
    (catch 'found
      (setq pos1 pos)
      (while (setq res (next-single-property-change pos1 'aname nil nil))
        (if (string= aname (get-text-property res 'aname))
            (progn (setq found t)
                   (throw 'found t))
          (setq pos1 res))))
    (unless found
      (catch 'found
        (setq pos1 pos)
        (while (setq res (previous-single-property-change pos1 'aname nil nil))
          (if (string= aname (get-text-property res 'aname))
              (progn (setq found t)
                     (throw 'found t))
            (setq pos1 res)))))
    (if res (goto-char res)
      (message (format "Not found anchor: %s." aname)))))

(defun pukiwiki-view-chip-away-bracket-around-region (start end)
  (if pukiwiki-view-chip-away-bracket
      (let ((pos1 start) (pos2 end) (count1 0) (count2 0))
        (save-excursion
          ;; $BD>A0$N6u$-(B bracket.
          (goto-char pos1)
          (when (> (point) (point-min)) ; $B%P%C%U%!@hF,$J$i$b$&?J$a$J$$!#(B
            (forward-char -1))
          (while (= (char-after) ?\[)
            (delete-char 1)
            (setq count1 (1+ count1))
            (when (> (point) (point-min)) ; $B%P%C%U%!@hF,$J$i$b$&?J$a$J$$!#(B
              (forward-char -1)))
          ;; $BD>8e$NJD$8(B bracket.
          (setq pos2 (- pos2 count1))
          (goto-char pos2)
          (unless (= (point) (point-max)) ; $B%P%C%U%!KvHx$J$i:o=|$G$-$J$$!#(B
            (catch 'reaching-point-max
              (while (= (char-after) ?\])
                (delete-char 1)
                (setq count2 (1+ count2))
                (when (>= (point) (point-max)) ; $B%P%C%U%!KvHx$K$J$C$?$iH4$1$k!#(B
                  (throw 'reaching-point-max t)))))
          (setq pos2 (- pos2 count2))
          (cons count1 count2)))
    (cons 0 0)))

(defvar pukiwiki-auto-anchor t)
(defun pukiwiki-insert-anchor-subr (type value face start end)
  ;; property set.
  (pukiwiki-set-content-anchor-property start end type value)
  ;; overlay set.
  (setq ovr (make-overlay start end))
  (overlay-put ovr 'face face)
  (overlay-put ovr 'priority 1))

(defun pukiwiki-insert-anchor (regexp-alist)
  (goto-char (point-min))
  (let ((pos (point)) value)
    (when pukiwiki-auto-anchor
      (while (setq result-list (pukiwiki-search-anchor pos regexp-alist))
        (let ((start (car result-list))
              (end (cdr result-list))
              url delete-count interwiki-delete-flag)
          (cond
           ((string-match "\\(\\(ht\\|f\\)tps*://[^ ]+\\)\\(\\s-+\\)\\(.+\\)$"
                          (buffer-substring-no-properties start end))
            ;; url entry delete.
            (let* ((offset1 (match-end 1))
                   (offset2 (match-end 3))
                   (url
                    (buffer-substring-no-properties start (+ start offset1))))
              (delete-region start (+ start offset2))
              (setq end (- end offset2))
              ;; set property and overlay.
              (pukiwiki-insert-anchor-subr 'url url
                                           'pukiwiki-view-url-face start end)
              ;; $BA08e$N(B bracket $B$r:o$k!#(B
              (setq delete-count
                    (pukiwiki-view-chip-away-bracket-around-region start end))))

           ;; 2004.09.21 url $B$,8eH>$K$"$k%?%$%W$N(B anchor $B$KBP=h$7$F$_$k!#(B
           ((string-match "\\([^:]+\\)\\([>:]\\)\\(\\(ht\\|f\\)tps*://[^ ]+\\)$"
                          (buffer-substring-no-properties start end))
            ;; url entry delete.
            (let* ((offset1 (match-beginning 3))
                   (offset2 (match-beginning 2))
                   (url
                    (buffer-substring-no-properties (+ start offset1) end)))
              (delete-region (+ start offset2) end)
              (setq end (+ start offset2))
              ;; set property and overlay.
              (pukiwiki-insert-anchor-subr 'url url
                                           'pukiwiki-view-url-face start end)
              ;; $BA08e$N(B bracket $B$r:o$k!#(B
              (setq delete-count
                    (pukiwiki-view-chip-away-bracket-around-region start end))))

           ((string-match (car pukiwiki-view-no-bracket-url-regexp)
                          (buffer-substring-no-properties start end))
            (let ((url (buffer-substring-no-properties start end)))
              (when (null (string-match "https*://" url))
                (setq url (concat "h" url)))
              ;; set property and overlay.
              (pukiwiki-insert-anchor-subr 'url url
                                           'pukiwiki-view-url-face start end)
              ;; $BA08e$N(B bracket $B$r:o$k!#(B
              (setq delete-count
                    (pukiwiki-view-chip-away-bracket-around-region start end))))

           ;; InterWikiName
           ((string-match
             "^\\(\\([^]:|]+\\)\\(>+\\)\\)*\\(\\([^]:|]+\\):+.+\\)$"
             (buffer-substring-no-properties start end))
            (if (match-string 1 (buffer-substring-no-properties start end))
                (progn
                  (setq offset (match-beginning 3))
                  (setq interwiki-delete-flag t))
              (setq offset (match-beginning 5)))
            (setq interwikiname (match-string
                                 5 (buffer-substring-no-properties start end)))
            (setq value (match-string
                         4 (buffer-substring-no-properties start end)))

            ;; page name entry delete.
            (when interwiki-delete-flag
              (delete-region (+ start offset) end)
              (setq end (+ start offset)))
            ;; set property and overlay.
            (pukiwiki-insert-anchor-subr 'pagename value
                                         'pukiwiki-view-anchor-face start end)
            ;; $BA08e$N(B bracket $B$r:o$k!#(B
            (setq delete-count
                  (pukiwiki-view-chip-away-bracket-around-region start end)))

           ;; alias.
           ((string-match "^\\([^>]+\\)\\(>+\\)\\(.+\\)$"
                          (buffer-substring-no-properties start end))
            (let* ((offset (match-beginning 2))
                   (value (match-string
                           3 (buffer-substring-no-properties start end))))
              ;; $B%Z!<%8L>$,L5$$$H$-$O8=:_%Z!<%8$N%Z!<%8L>$r!#(B
              (when (string-match "^#" value)
                (setq value (concat pukiwiki-pagename value)))
              ;; page name entry delete.
              (delete-region (+ start offset) end)
              (setq end (+ start offset))
              ;; set property and overlay.
              (pukiwiki-insert-anchor-subr 'pagename value
                                           'pukiwiki-view-anchor-face start end)
              ;; $BA08e$N(B bracket $B$r:o$k!#(B
              (setq delete-count
                    (pukiwiki-view-chip-away-bracket-around-region start end))))

           ;; page name.
           ((string-match "^.+$"
                          (buffer-substring-no-properties start end))
            (let ((value (buffer-substring-no-properties start end)))
              (while (string-match "\n+ *" value)
                (setq value (replace-match "" nil nil value)))
              ;; $B%Z!<%8L>$,L5$$$H$-$O8=:_%Z!<%8$N%Z!<%8L>$r!#(B
              (when (string-match "^#" value)
                (setq value (concat pukiwiki-pagename value)))
              ;; set property and overlay.
              (pukiwiki-insert-anchor-subr 'pagename value
                                           'pukiwiki-view-anchor-face start end)
              ;; $BA08e$N(B bracket $B$r:o$k!#(B
              ;; bracket $B$G0O$^$l$?J8;zNs$,6uGr$@$1$N>l9g$K;D$9$+:o$k$+HyL/!#(B
              ;; (if (string-match "^\\s-*$" value)
              ;;     (setq delete-count (cons 0 0))
              ;;   (setq delete-count
              ;;         (pukiwiki-view-chip-away-bracket-around-region
              ;;          start end)))))
              (setq delete-count
                    (pukiwiki-view-chip-away-bracket-around-region
                     start end))))
           (t
            (setq delete-count (cons 0  0))))

          (setq pos (- end (car delete-count) (cdr delete-count))))))))

(if (fboundp 'mapcan)
    ()
  (defun mapcan (cl-func cl-seq &rest cl-rest)
    "Like `mapcar', but nconc's together the values returned by the function."
    (apply 'nconc (apply 'mapcar* cl-func cl-seq cl-rest))))

(defun pukiwiki-outline-renumber ()
  "Renumber headings in buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((stack nil)
          (whole 1))
      (while (re-search-forward "^[*]+ \\([0-9]+\\(\\.[0-9]+\\)*\\)" nil t)
        (let ((level (1+ (loop for c across
                               (match-string whole) count (eq c ?.)))))
          (while (< level (length stack)) (pop stack))
          (while (> level (length stack)) (push 0 stack))
          (incf (car stack)))
        (delete-region (match-beginning whole) (match-end whole))
        (apply #'insert
               (nreverse (butlast
                          (mapcan #'(lambda (x)
                                      (list (number-to-string x) "."))
                                  stack))))))))

(defun pukiwiki-view-renumber ()
  "Renumber headings in buffer."
  (interactive)
  (let ((header nil))
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward
              "^\\([*]+\\)" nil t)
        (setq header (length (match-string 1)))
        (insert " ")
        (while (not (= header 0))
          (insert "1.")
          (setq header (- header 1)))
        (insert " "))               ; YYYY.MM.DD $B$J$I$N8+=P$7$,0[>o$K$J$k$N$G!#(B
      (goto-char (point-min))
      (if (re-search-forward "^#contents" nil t)
          ()
        (goto-char (point-max))
        (insert "\n\n* 1. $B$b$/$8(B\n\n#contents\n"))
      (goto-char (point-min))
      (pukiwiki-outline-renumber)
      )))

(defun pukiwiki-view-delete-html-tag ()
  (let (pt end-pt)
    (goto-char (point-min))
    (while (re-search-forward
            "<span class=\"diff_removed\">" nil t)
      (setq pt (match-beginning 0))
      (if (re-search-forward "</span>" nil t)
          (setq end-pt (point)))
      (if end-pt
          (delete-region pt end-pt))
      (setq pt nil
            end-pt nil))
    (goto-char (point-min))
    (while (re-search-forward
            "\\(<span class=\"[^\"]+\">\\|</span>\\)" nil t)
      (delete-region (match-beginning 0)
                     (match-end 0)))
    (goto-char (point-min))))

(defun pukiwiki-view-reformating (&optional ediffp)
  (when (not buffer-read-only)
    (pukiwiki-view-delete-html-tag)
    (when (and pukiwiki-auto-insert
               (not buffer-read-only))
      (pukiwiki-mode-auto-insert))
    (if ediffp
        ()
      (pukiwiki-view-renumber))
    (pukiwiki-insert-contents)))

;;;; http.el $BFb$N4X?t$r(B pukiwiki $BMQ$K2~B$$7$?$b$N$?$A(B
(defvar pukiwiki-http-fetch-running nil)
(defun pukiwiki-http-fetch-sentinel (proc str)
  (setq pukiwiki-http-fetch-running nil))

;; no-proxy-domain $B$KBP=h!#(B
(defun pukiwiki-no-proxy-domain-p (url)
  "proxy server $B$N;XDj$,$"$k$H$-$G!"(Bproxy $B$r2p$5$J$$%I%a%$%s$+$rD4$Y$k!#(B"
  (let (host domain)
    (save-match-data
      (when
          (and pukiwiki-no-proxy-domains-list
               (string-match "^[a-z]+://\\([^/:]+\\)" url)
               (catch 'domain-match
                 (setq host (match-string 1 url))
                 (dolist (domain pukiwiki-no-proxy-domains-list)
                   (when (string-match (concat "\\(^\\|\\.\\)" (regexp-quote domain) "$") host)
                     (throw 'domain-match t)))))
        t))))

(defun pukiwiki-http-fetch (url method &optional user pass data)
  "Fetch via HTTP.

URL is a url to be POSTed.
METHOD is 'get or 'post.
USER and PASS must be a valid username and password, if required.
DATA is an alist, each element is in the form of (FIELD . DATA).

If no error, return a buffer which contains output from the web server.
If error, return a cons cell (ERRCODE . DESCRIPTION)."
  (setq pukiwiki-http-fetch-running t)
  (let (connection server port path buf str len)
    (string-match
     "^http://\\([^/:]+\\)\\(:\\([0-9]+\\)\\)?\\(/.*$\\)" url)
    (setq server (match-string 1 url)
          port (string-to-int (or (match-string 3 url) "80"))
          path (if (pukiwiki-no-proxy-domain-p url) (match-string 4 url) url))
    (setq str (mapconcat
               '(lambda (x)
                  (concat (car x) "=" (cdr x)))
               data "&"))
    (setq len (length str))
    (save-excursion
      (setq buf (get-buffer-create
                 (concat "*result from " server "*")))
      (set-buffer buf)
      (erase-buffer)
      (setq connection
            (as-binary-process
             (open-network-stream
              (concat "*request to " server "*")
              buf
              (if (pukiwiki-no-proxy-domain-p url) server
                (or http-proxy-server server))
              (if (pukiwiki-no-proxy-domain-p url) port
                (or http-proxy-port port)))))
      (set-process-coding-system connection 'binary 'binary)
      ;;(set-process-sentinel connection 'ignore)
      (set-process-sentinel connection 'pukiwiki-http-fetch-sentinel)
      (process-send-string
       connection
       (concat (if (eq method 'post)
                   (concat "POST " path)
                 (concat "GET " path (if (> len 0)
                                         (concat "?" str))))
               " HTTP/1.0\r\n"
               (concat "Host: " server "\r\n")
               "Connection: close\r\n"
               "Content-type: application/x-www-form-urlencoded\r\n"
               (if (and user pass)
                   (concat "Authorization: Basic "
                           (base64-encode-string
                            (concat user ":" pass))
                           "\r\n"))
               (if (eq method 'post)
                   (concat "Content-length: " (int-to-string len) "\r\n"
                           "\r\n"
                           str))
               "\r\n"))
      (while pukiwiki-http-fetch-running
        (unless (accept-process-output connection pukiwiki-process-timeout)
          (error "HTTP fetch: Connection timeout!"))
        (sit-for pukiwiki-process-sentinel-interval))
      (delete-process connection)
      (goto-char (point-min))
      (save-excursion
        (if (re-search-forward
             "HTTP/1.[01] \\([0-9][0-9][0-9]\\) \\(.*\\)" nil t)
            (let ((code (match-string 1))
                  (desc (match-string 2)))
              (cond ((or (equal code "200")
                         (equal code "302"))
                     buf)
                    ;; support authorization
                    ;; $B$H$j$"$($:!"(B1$B%5!<%P$G(B1$B8D$N%Q%9%o!<%I$rJ]B8$7$F$_$k(B
                    ;; $BK\Ev$O(B1$B%Z!<%8Kh$K%f!<%6L>$H%Q%9%o!<%I$r49$($k$3$H$b$G$-$k(B
                    ((equal code "401")
                     (let* (user pass
                                (default (assoc server pukiwiki-password-alist)))
                       (cond
                        (default
                          (setq user (car (cdr default)))
                          (setq pass (car (cdr (cdr default)))))
                        (t
                         (setq user (read-from-minibuffer "Username: "))
                         (unless (equal user "")
                           (setq pass (read-passwd "Password: ")))))

                       ;; save
                       (pukiwiki-save-passwd server user pass)
                       (condition-case err
                           (setq buf (pukiwiki-http-fetch
                                      url method user pass data))
                         (error
                          ;; $B%Q%9%o!<%I$NF~NO%_%9;~(B
                          (setq user (read-from-minibuffer "Username: "))
                          (unless (equal user "")
                            (setq pass (read-passwd "Password: "))
                            (pukiwiki-save-passwd server user pass t)
                            (setq buf (pukiwiki-http-fetch
                                       url method user pass data)))))))
                    (t
                     (cons code desc))))
          buf)))))

(defvar pukiwiki-download-running nil)
(defun pukiwiki-download-sentinel (proc str)
  (setq pukiwiki-download-running nil))

(defun pukiwiki-http-download (url filename)
  "Fetch via HTTP and save to the filename."
  (message "Downloading file...")
  (let (connection server port path buf str len
                   (coding-system-for-write 'binary)
                   (coding-system-for-read 'binary))
    (setq pukiwiki-download-running t)
    (string-match
     "^http://\\([^/:]+\\)\\(:\\([0-9]+\\)\\)?\\(/.*$\\)" url)
    (setq server (match-string 1 url)
          port (string-to-int (or (match-string 3 url) "80"))
          path (if (pukiwiki-no-proxy-domain-p url) (match-string 4 url) url))
    (save-excursion
      (setq buf (get-buffer-create
                 (concat "*result from " server "*")))
      (set-buffer buf)
      (erase-buffer)
      (setq connection
            (open-network-stream
             (concat "*request to " server "*")
             buf
             (if (pukiwiki-no-proxy-domain-p url) server
               (or http-proxy-server server))
             (if (pukiwiki-no-proxy-domain-p url) port
               (or http-proxy-port port))))
      (set-process-coding-system connection 'binary 'binary)
      (set-process-sentinel connection 'pukiwiki-download-sentinel)
      (process-send-string
       connection
       (concat
        (concat "GET " path
                " HTTP/1.0\r\n"
                (concat "Host: " server "\r\n")
                "Connection: close\r\n"
                "Content-type: application/x-www-form-urlencoded\r\n"
                "\r\n")))
      (goto-char (point-min))
      (while pukiwiki-download-running
        (unless (accept-process-output connection pukiwiki-process-timeout)
          (error "HTTP fetch: Connection timeout!"))
        (sit-for pukiwiki-process-sentinel-interval))
      (delete-process connection)
      )
    (set-buffer buf)
    (goto-char (point-min))
    ;; header $B$N8e$K0\F0(B
    (re-search-forward "\r\n\r?\n" nil t)
    (write-region
     (point) (point-max) filename))
  (message "Downloading file... done!"))

;;;; $B%$%s%G%C%/%9$NF|IU$1=hM}4XO"(B
(defun pukiwiki-date-convert (time)
  "time $B$G;XDj$7$?F|$@$1A0$N;~4V$rJV$9(B"
  (let ((now (current-time)) (days (* -1 time))
        dateh datel daysec daysh daysl dir
        (offset 0))
    (setq daysec (* -1.0 days 60 60 24))
    (setq daysh (floor (/ daysec 65536.0)))
    (setq daysl (round (- daysec (* daysh 65536.0))))
    (setq dateh (- (nth 0 now) daysh))
    (setq datel (- (nth 1 now) (* offset 3600) daysl))
    (if (< datel 0)
        (progn
          (setq datel (+ datel 65536))
          (setq dateh (- dateh 1)))) ;;(floor (/ offset 24))))))
    (if (< dateh 0)
        (setq dateh 0))
    ;;(insert (concat (int-to-string dateh) ":"))
    (list dateh datel)))

(defun pukiwiki-last-date (time)
  (let ((now (current-time)) (days (* -1 time)) dateh datel daysec daysh daysl dir
        (offset 0))
    (setq daysec (* -1.0 days 60 60 24))
    (setq daysh (floor (/ daysec 65536.0)))
    (setq daysl (round (- daysec (* daysh 65536.0))))
    (setq dateh (- (nth 0 now) daysh))
    (setq datel (- (nth 1 now) (* offset 3600) daysl))
    (if (< datel 0)
        (progn
          (setq datel (+ datel 65536))
          (setq dateh (- dateh 1)))) ;;(floor (/ offset 24))))))
    (if (< dateh 0)
        (setq dateh 0))
    (list dateh datel)))

(defun pukiwiki-index-date (time-str)
  (let ((current-hour
         (string-to-int (format-time-string "%H" (current-time)))))
    (if (and
         (string-match "(\\([0-9]+\\)\\($B;~4VA0(B\\|h\\))" time-str)
         (> (string-to-int (substring
                            time-str
                            1
                            (string-match "[^0-9]" time-str 1)))
            current-hour))
        (pukiwiki-last-date 1)
      (if (or
           (string-match "(\\([0-9]+\\)\\($B;~4VA0(B\\|h\\))" time-str)
           (string-match "(\\([0-9]+\\)\\($BJ,A0(B\\|m\\))" time-str))
          (pukiwiki-last-date 0)
        (string-match "(\\([0-9]+\\)\\($BF|A0(B\\|d\\))" time-str)
        (pukiwiki-last-date
         (string-to-int (substring
                         time-str
                         1
                         (string-match "[^0-9]" time-str 1))))))))

;;;; $B%"%s%+!<$G%j%?!<%s$7$?>l9g$N=hM}(B
(defun pukiwiki-get-face (pt)
  (if (get-text-property pt 'face)
      (get-text-property pt 'face)
    (get-char-property pt 'face)))

(defun pukiwiki-edit-new-line ()
  (interactive)
  (let ((cursorface
         (pukiwiki-get-face (point)))
        (prevb pukiwiki-prev-buffer)
        (wikiname nil)
        (str
         (buffer-substring-no-properties
          (line-beginning-position)
          (line-end-position)))
        filename url (buf-name "*pukiwiki download*")
        end start)
    (cond
     ((string= cursorface 'pukiwiki-anchor-face)
      (if (not
           (string= 'pukiwiki-anchor-face
                    (pukiwiki-get-face (- (point) 1))))
          (setq start (point)))
      (if (not
           (string= 'pukiwiki-anchor-face
                    (pukiwiki-get-face (+ (point) 1))))
          (setq end (+ (point) 1)))
      (if start
          ()
        (setq start (previous-property-change (point))))
      (if end
          ()
        (setq end (next-property-change (point))))
      (setq wikiname (buffer-substring-no-properties start end))
      (let ((buffer-read buffer-read-only))
        (pukiwiki-index-edit-page wikiname)
        (setq buffer-read-only buffer-read))
      (delete-other-windows))

     ((string-match
       "^#ref(\\([^,)]+\\)[,)]"
       (buffer-substring-no-properties
        (line-beginning-position) (line-end-position)))
      (setq filename
            (match-string
             1
             (buffer-substring-no-properties
              (line-beginning-position) (line-end-position))))
      (setq url
            (concat
             (nth 1 pukiwiki-site-info)
             "?plugin=attach&pcmd=open&file="
             filename
             "&refer="
             (http-url-hexify-string
              pukiwiki-pagename
              (pukiwiki-site-coding-system))))
      (setq filename
            (concat
             (expand-file-name
              (concat (make-temp-name "pw")
                      filename)
              temporary-file-directory)))
      (pukiwiki-http-download url filename)
      (setq pukiwiki-preview-file-list
            (cons
             filename
             pukiwiki-preview-file-list))
      (let ((history file-name-history))
        (find-file filename)
        (setq file-name-history history))
      (pukiwiki-diff-mode)
      (setq pukiwiki-prev-buffer prevb)
      (set-buffer-modified-p nil))

     ((string-match "[hft]+tp://[\000-\039\041-\133\134\136-\377]*" str) ;;\000-\377
      (setq str
            (substring
             str
             (match-beginning 0)
             (match-end 0)))
      (browse-url str))

     (t
      (if buffer-read-only
          (re-search-backward "^*" nil t)
        (newline-and-indent))))))

;;;; $B=*N;=hM}(B
(defadvice save-buffers-kill-emacs
  (before delete-temp-file-of-pukiwiki activate)
  (if pukiwiki-preview-file-list
      (while pukiwiki-preview-file-list
        (if (file-exists-p (car pukiwiki-preview-file-list))
            (delete-file (car pukiwiki-preview-file-list)))
        (setq pukiwiki-preview-file-list
              (cdr pukiwiki-preview-file-list)))))

;;; Pukiwiki $B%5!<%P!<%b!<%I(B
(defvar pukiwiki-server-font-lock-keywords
  (list
   '("^[ ]*[0-9]+[ ]*\\([^\r\n]+\\)[ ]+[0-9]+ pages$" 1 'pukiwiki-index-cache-face)
   '("^[ ]*[0-9]+[ ]*[^\r\n]+[ ]+\\([0-9]+ pages\\)$" 1 'pukiwiki-index-normal-face)
   ))

(defun pukiwiki-server-setup-keys ()
  (define-key pukiwiki-server-mode-map "\C-m" 'pukiwiki-sever-in)
  )

(define-derived-mode pukiwiki-server-mode text-mode "Pukiwiki Index"
  "Pukiwiki $B$N%5!<%P!<%b!<%I(B"
  (pukiwiki-server-setup-keys)
  ;; hooks
  (progn
    (make-local-hook 'post-command-hook)
    (make-local-hook 'pukiwiki-server-post-command-hook)
    (add-hook 'pukiwiki-server-post-command-hook
              (function
               (lambda ()
                 (pukiwiki-index-highlight-current-line)))
              nil t)))

;;; $B%5!<%PMQ4X?t(B
(defvar pukiwiki-server-history nil)
(make-variable-buffer-local 'pukiwiki-server-history)
(defun pukiwiki-server-page-info-current-line ()
  "$B8=:_9T$N%5!<%P>pJs(B(list)$B$rJV$9!#(B"
  (let (num)
    (save-excursion
      (beginning-of-line)
      (re-search-forward "\\([0-9]+\\)" nil t nil)
      (setq num (match-string 1)))
    (cond
     (num (nth (1- (string-to-number num))
               pukiwiki-server-history))
     (t nil))))

;;; $B%5!<%P%b!<%IMQ%f!<%6%3%^%s%I(B
(defun pukiwiki-sever-in ()
  (interactive)
  (cond
   ((string-match "pukiwiki-history"
                  (buffer-substring-no-properties
                   (line-beginning-position)
                   (line-end-position)))
    (pukiwiki-histoy-index))
   (t
    (let ((server-info (pukiwiki-server-page-info-current-line))
          (old-win (selected-window))
          name win url)
      (when server-info
        (setq name (car server-info))
        (condition-case err
            (if (assoc name pukiwiki-site-list)
                (pukiwiki-index (assoc name pukiwiki-site-list))
              (pukiwiki-index-url name))
          (error
           (error "$B%5!<%P$r3+$1$^$;$s$G$7$?(B"))))))))

;;; $B%5!<%PMQ$N4pK\%3%^%s%I(B
(defun pukiwiki-server-get-buffer-create ()
  "$B%5!<%P!<0lMwI=<(MQ$N%P%C%U%!$rJV$9!#(B"
  (let ((buf-name "*pukiwiki server*"))
    (or (get-buffer buf-name)
        (progn
          (save-excursion
            (get-buffer-create buf-name)
            (set-buffer buf-name)
            (pukiwiki-server-mode)
            (make-local-variable 'font-lock-defaults)
            (setq font-lock-defaults
                  '(pukiwiki-server-font-lock-keywords
                    nil nil ((?_ . "w")) nil))
            (pukiwiki-mode-set-font-lock 'pukiwiki-server-mode)
            (if (fboundp 'turn-off-font-lock)
                (turn-off-font-lock))
            (if (fboundp 'turn-on-font-lock)
                (turn-on-font-lock))

            ;;(setq pukiwiki-site-info site-info)
            (get-buffer buf-name)
            )))))

(defun pukiwiki-server ()
  (interactive)
  (let ((history pukiwiki-pagename-history)
        plist (num 1)
        (buf (pukiwiki-server-get-buffer-create)))
    (switch-to-buffer buf)
    (setq buffer-read-only nil)
    (erase-buffer)
    (when pukiwiki-save-post-data
      (setq history
            (cons
             (cons
              "pukiwiki-history"
              (directory-files pukiwiki-directory))
             history)))
    (while history
      (setq plist (car history))
      (insert
       (format "%4d  %s  %6d pages%s"
               num (pukiwiki-prefix
                    (car plist)
                    pukiwiki-index-wiki-name)
               (length (cdr plist))
               "\n"))
      (setq num (+ 1 num))
      (setq history (cdr history))
      )
    (setq pukiwiki-server-history pukiwiki-pagename-history)

    (set-buffer-modified-p nil)
    (setq buffer-read-only t)
    (goto-char (point-min))
    buf
    ))

;;; $BAw?.%G!<%?$N%R%9%H%j4XO"(B
(defun pukiwiki-display-history ()
  (let ((old-buf (current-buffer))
        (num 1)
        (buf "*pukiwiki history*")
        (files
         (cdr (cdr
               (directory-files pukiwiki-directory)))))
    (switch-to-buffer (get-buffer-create buf))
    (setq buffer-read-only nil)
    (erase-buffer)
    (mapcar
     (lambda (str)
       (insert
        (format "%4d %s\n" num str))
        (setq num (+ num 1)))
     files)
    (pukiwiki-history-mode)
    (set-buffer-modified-p nil)
    (setq buffer-read-only t)
    (goto-char (point-min))
    (set-buffer old-buf)
    buf))

(defun pukiwiki-histoy-index ()
  (interactive)
  (pukiwiki-initialize)
  (let (buf)
    ;; site-name input (if required)
    (setq buf (pukiwiki-display-history))
    (set-buffer buf)))

;;; $BAw?.%G!<%?$N%R%9%H%j%b!<%I(B
(define-derived-mode pukiwiki-history-mode text-mode "Pukiwiki History"
  "Major mode for Pukiwiki history.

\\{pukiwiki-index-mode-map}"
  (pukiwiki-history-setup-keys)
  ;; hooks
  (progn
    (make-local-hook 'post-command-hook)
  (run-hooks 'pukiwiki-history-mode-hook)))

(defun pukiwiki-history-setup-keys ()
  "Set up keymap for pukiwiki-history-mode.
If you want to set up your own key bindings, use `pukiwiki-history-mode-hook'."
  ;;(define-key pukiwiki-history-mode-map "?" 'pukiwiki-index-help)
  )

(provide 'pukiwiki-mode)
;;; pukiwiki-mode.el ends here
