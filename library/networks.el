;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

;; util.
(defun load-keychain ()
  (interactive)
  (unless (getenv "SSH_AGENT_PID")
    (let
        ((keychain-output
          (expand-file-name
           (format "~/.keychain/%s-sh"
                   (car (split-string (system-name) "\\."))))))

      (when (file-readable-p keychain-output)
        (with-temp-buffer
          (insert-file-contents keychain-output)
          (setenv "SSH_AUTH_SOCK"
                  (when (re-search-forward
                         "SSH_AUTH_SOCK=\\(.+[0-9]+\\);" nil t)
                    (match-string 1)))
          (setenv "SSH_AGENT_PID"
                  (when (re-search-forward
                         "SSH_AGENT_PID=\\([0-9]+\\);" nil t)
                    (match-string 1))))))))
(load-keychain)

;; based upon
;; http://deisui.bug.org/%7Eueno/memo/emacs-ssh.html
;; http://triaez.kaisei.org/%7Ekaoru/ssh/emacs-ssh.html
;; http://www.meadowy.org/%7Egotoh/lisp/relay.el


(defvar sr:ssh-program "ssh"
  "*nodoc*")

(defvar sr:ssh-flags "-Caxq"
  "*nodoc*")

(defvar sr:nc-program "nc"
  "*nodoc*")

(defvar sr:nc-flags "-w 60"
  "*nodoc*")

(defvar sr:destination-host nil
  "*nodoc*")

(defvar sr:relay-hosts (list)
  "*nodoc*")

(defvar sr:relay-services (list)
  "*nodoc*")

(defun sr:check ()
  (mapc (lambda (x)
          (unless (executable-find x)
            (error "command not found: %s" x)))
        (list sr:ssh-program
              sr:nc-program)))

(when (sr:check)
  (defun open-ssh-stream-internal (&rest plist)
    (let ((name (or (plist-get plist :name) name))
          (buffer (or (plist-get plist :buffer) buffer))
          (host (or (plist-get plist :host) host))
          (service (or (plist-get plist :service) service))
          (process-connection-type nil))
      (start-process name buffer
                     (or (plist-get plist :ssh) sr:ssh-program)
                     (or (plist-get plist :ssh-flags) sr:ssh-flags)
                     (plist-get plist :relay)
                     (or (plist-get plist :nc) sr:nc-program)
                     (or (plist-get plist :nc-flags) sr:nc-flags)
                     host (format "%s" service))))

  (defun open-ssh-stream (name buffer host service)
    (open-ssh-stream-internal :relay ssh-relay-target-host
                              :name name
                              :buffer buffer
                              :host host
                              :service service))

  (defadvice open-network-stream (around relay (name buffer host service)
                                         activate)
    "Open network stream with relaying."
    (let
        ((short-system-name (car (split-string (system-name) "\\.")))
         (hosts sr:relay-hosts)
         (services sr:relay-services))

      (if (and sr:destination-host
               (not (member short-system-name hosts))
               (member host hosts)
               (member service services))
          (setq ad-return-value
                (open-ssh-stream name buffer host service))
        ad-do-it)))

  (provide 'ssh-relay))

(ad-deactivate 'open-network-stream)