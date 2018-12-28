;;; init-org-mode.el --- A setting of the org-mode -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(set-variable 'org-directory "~/Dropbox/org/")

(let*
    ((journal-file (expand-file-name "journal.org" org-directory))
     (note-file    (expand-file-name "notes.org"   org-directory))

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
    :bind (("C-c a"   . org-agenda)
           ("C-c c"   . org-capture)
           ("C-c C-l" . org-insert-link)
           ("C-c l"   . org-store-link))

    :custom
    (org-agenda-files (list org-directory))
    (org-capture-templates
     (append capture-templates-journal capture-templates-others))
    (org-image-actual-width '(400))
    (org-refile-targets
     (quote ((nil :maxlevel . 3)
             (org-agenda-files :maxlevel . 3))))
    (org-startup-folded 'showeverything)
    (org-startup-indented nil)
    (org-startup-truncated nil)
    (org-startup-with-inline-images t)
    (org-use-speed-commands t))

  (use-package org-id
    :custom
    (org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)
    (org-id-track-globally t)))

;;; init-org-mode.el ends here