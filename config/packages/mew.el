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
