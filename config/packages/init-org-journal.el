;;; init-org-journal.el --- A setting of the org-journal.
;;; Commentary:
;;; Code:

(use-package org-journal
  :custom
  (org-journal-date-format "%F %A")
  (org-journal-file-format "%Y-%m-%d.org")
  (org-journal-hide-entries-p nil)
  (org-journal-time-format "[%F %a %R]")
  (org-journal-dir (expand-file-name "journals" org-directory))
  (org-agenda-files (cons org-journal-dir org-agenda-files)))

;;; init-org-journal.el ends here
