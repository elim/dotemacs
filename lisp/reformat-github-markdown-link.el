;;; reformat-github-markdown-link.el --- . -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defconst rgml-github-markdown-link-regexp
  "^\\[\\(.+?\\)\\(?: by \\(.*?\\) · \\| · \\).*· \\(.*\\)/\\(.*\\)](\\(https.+/\\(.+\\)\\))$")

(defcustom rgml-reformat-style 'simple
  "Select the style on reformatting."
  :group 'reformat-github-markdown-link
  :type '(radio
          (const :tag "[#number title](url)" simple)
          (const :tag "[repository#number title](url)" with-repository)
          (const :tag "[owner/repository#number title](url)" with-owner/repository)))

(cl-defun rgml-string-match-to-alist (string regexp names)
  "Return matched strings with NAMES as an alist.
Matches REGEXP to STRING, allocates NAMES to matches, and returns
them in alist."
  (unless (string-match regexp string)
    (cl-return-from string-match-to-alist nil))

  (let ((index 1) (match) (alist))
    (dolist (name names alist)
      (setq match `(,name . ,(match-string index string)))
      (setq alist (cons match alist))
      (setq index (1+ index)))))

;;;###autoload
(cl-defun reformat-github-markdown-link (markdown-link &optional variant)
  "Reformat a title of a Markdown-style link.
MARKDOWN-LINK should be a link to a GitHub pull request, issue, or
discussion.

Input example:
[Title · Pull Request #1 · elim/nowhere](https://github.com/elim/nowhere/pull/1)

Output example:
[nowhere#1 Title](https://github.com/elim/nowhere/pull/1)

If set VARIANT to 'with-owner then the output string is including owner"

  (let
      ((alist (rgml-string-match-to-alist
               markdown-link
               rgml-github-markdown-link-regexp
               '(title author owner repository url number))))

    (unless alist
      (cl-return-from reformat-github-markdown-link markdown-link))

    (let-alist alist
      (pcase (or variant rgml-reformat-style)
        ('simple                (format "[#%s %s](%s)"                         .number .title .url))
        ('with-repository       (format "[%s#%s %s](%s)"           .repository .number .title .url))
        ('with-owner/repository (format "[%s/%s#%s %s](%s)" .owner .repository .number .title .url))))))

(provide 'reformat-github-markdown-link)
;;; reformat-github-markdown-link.el ends here
