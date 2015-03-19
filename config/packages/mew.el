;;
;; http://www.clear-code.com/blog/2015/3/17.html
;;
(defun mew-render-html-shr (begin end)
  (save-excursion
    (save-restriction
      (narrow-to-region begin end)
      (shr-render-region (point-min) (point-max))
      (goto-char (point-min))
      (let ((url-begin-pos (next-single-property-change (point) 'shr-url))
            (url-end-pos))
        (while url-begin-pos
          (goto-char url-begin-pos)
          (setq url-end-pos
                (or (next-single-property-change (point) 'shr-url)
                    (point-max)))
          (put-text-property (point) url-end-pos
                             'mew-url (get-text-property (point) 'shr-url))
          (setq url-begin-pos
                (next-single-property-change url-end-pos 'shr-url)))))))

(when (and (fboundp 'shr-render-region)
           (fboundp 'libxml-parse-html-region))
  (setq mew-prog-text/html 'mew-render-html-shr)
  (setq mew-use-text/html t)
  (setq mew-mime-multipart-alternative-list
        '("Text/Html" "Text/Plain" ".*")))

(setq mew-debug t
      mew-use-master-passwd t
      mew-imap-size 0
      mew-config-alist
      '((default
          (name              "Takeru Naito")
          (user              "takeru.naito")
          (mail-domain       "gmail.com")
          (proto             "%")
          (imap-server       "imap.gmail.com")
          (imap-user         "takeru.naito@gmail.com")
          (imap-auth         t)
          (imap-ssl          t)
          (imap-ssl-port     993)

          (smtp-server       "smtp.gmail.com")
          (smtp-user         "takeru.naito@gmail.com")
          (smtp-auth         t)
          (smtp-ssl          t)
          (smtp-ssl-port     465)
          (fcc               "%[Gmail]/Sent Mail")
          (imap-trash-folder "%[Gmail]/All Mail")
          (use-master-passwd t))
        (ezweb
          (name              "Takeru Naito")
          (user              "alchemist")
          (mail-domain       "ezweb.ne.jp")
          (proto             "%")
          (imap-server       "imap.ezweb.ne.jp")
          (imap-user         "x1pztrns")
          (imap-auth         t)
          (imap-ssl          t)
          (imap-ssl-port     993)

          (smtp-server       "smtp.ezweb.ne.jp")
          (smtp-user         "x1pztrns")
          (smtp-auth         t)
          (smtp-ssl          t)
          (smtp-ssl-port     465)
          (fcc               "%Sent Mail")
          (imap-trash-folder "%Trash")
          (use-master-passwd t))))
