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

(let*
    ((journal-file (expand-file-name "journal.org" elim:org-directory))
     (note-file    (expand-file-name "notes.org"   elim:org-directory))

     (journal-template-common `(entry
                                (file+datetree ,journal-file)
                                "* %U\n%?"
                                :jump-to-captured t
                                :unnarrowed t))

     (capture-templates-journal
      `(,(append '("j" "Journal")                  journal-template-common)
        ,(append '("J" "Journal with time-prompt") journal-template-common '(:time-prompt t))))

     (capture-templates-others
      '(("n" "Note" entry (file+headline ,note-file "Notes")
         "* %?\nEntered on %U\n %i\n %a"))))

  (use-package org
    :bind (("C-c a" . org-agenda)
           ("C-c c" . org-capture)
           ("C-c l" . org-store-link)
           ("C-M-C" . elim:show-org-journal-buffer))

    :custom
    (org-capture-templates
     (append capture-templates-journal capture-templates-others))
    (org-image-actual-width '(400))
    (org-startup-folded 'showeverything)
    (org-startup-indented t)
    (org-startup-truncated nil)
    (org-startup-with-inline-images t)))

;;; init-org-mode.el ends here
