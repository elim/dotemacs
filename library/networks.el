;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

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

(defun get-ip-address ()
  (interactive)
  (let
      ((traceroute
        (or
         (locate-library "traceroute" nil exec-path)
         (locate-library "tracert.exe" nil exec-path)))
       (host-name
        (if (string-match "\\." system-name)
            (progn
              (string-match "^\\(.+?\\)\\." system-name)
              (match-string-no-properties 1 system-name))
          system-name)))

    (if traceroute
        (with-temp-buffer
          (call-process traceroute nil t nil host-name)
          (goto-char (point-min))
          (if (re-search-forward "[^0-9]*\\([0-9]+\\(\.[0-9]+\\)+\\)" nil t)
              (match-string 1)))
      "unknown")))

(defun domestic-network-member-p ()
  (let
      ((domestic-address "^192.168.119.")
       (domestic-domain-name "fascinating.local$"))
    (and
     (string-match domestic-address (get-ip-address))
     (string-match domestic-domain-name system-name))))

;; based upon
;; http://deisui.bug.org/%7Eueno/memo/emacs-ssh.html
;; http://triaez.kaisei.org/%7Ekaoru/ssh/emacs-ssh.html
;; http://www.meadowy.org/~gotoh/lisp/relay.el
(defun open-ssh-stream-internal (&rest plist)
  (let ((name (or (plist-get plist :name) name))
        (buffer (or (plist-get plist :buffer) buffer))
        (host (or (plist-get plist :host) host))
        (service (or (plist-get plist :service) service))
        (process-connection-type nil))
    (start-process-shell-command
     name buffer
     (or (plist-get plist :ssh) "ssh")
     (or (plist-get plist :sshflags) "-Caxq")
     (plist-get plist :relay)
     (or (plist-get plist :command) "nc -w 60")
     host (format "%s" service))))

(defun open-ssh-stream (name buffer host service)
  (open-ssh-stream-internal :relay "elim.teroknor.org"
                            :name name
                            :buffer buffer
                            :host host
                            :service service))

(defadvice open-network-stream (around relay (name buffer host service)
                                       activate)
  "Open network stream with relaying."
  (let
      ((short-system-name (car (split-string (system-name) "\\.")))
       (hosts (list "localhost" "idea" "elim.teroknor.org"))
       (services (list 25 143 2010 6667)))

    (if (and (not (member short-system-name hosts))
             (member host hosts)
             (member service services))
        (setq ad-return-value
              (open-ssh-stream name buffer host service))
      ad-do-it)))