;;; init-org-mode.el --- A setting of the org-mode.
;;; Commentary:
;;; Code:

(defvar elim:org-directory "~/Dropbox/org/"
  "The directory of my org files.")

;; https://qiita.com/takaxp/items/0b717ad1d0488b74429d
(defun elim:show-org-buffer (file)
  "Show an org-file FILE on the current buffer."
  (interactive)
  (if (get-buffer file)
      (let ((buffer (get-buffer file)))
        (switch-to-buffer buffer)
        (message "%s" file))
    (find-file (concat elim:org-directory file))))

(defun elim:show-org-journal-buffer ()
  "Show a journal on the current buffer."
  (interactive)
  (elim:show-org-buffer "journal.org"))

(use-package org
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c l" . org-store-link)
         ("C-M-C" . elim:show-org-journal-buffer))

  :custom
  (org-capture-templates
   `(("j" "Journal" entry
      (file+datetree ,(expand-file-name "journal.org" elim:org-directory))
      "* %U\n%?"
      :unnarrowed t
      :jump-to-captured t)

     ("n" "Note" entry
      (file+headline ,(expand-file-name "notes.org" elim:org-directory) "Notes")
      "* %?\nEntered on %U\n %i\n %a")))
  (org-image-actual-width '(400))
  (org-startup-truncated nil))

;;; init-org-mode.el ends here
