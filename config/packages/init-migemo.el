(when (require 'migemo nil t)
  (setq migemo-coding-system 'utf-8-unix
        migemo-command "/usr/local/bin/cmigemo"
        migemo-options '("-q" "--emacs")
        migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")

  (migemo-init))
