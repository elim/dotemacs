;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

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
      ((hosts (list "localhost" "idea" "elim.teroknor.org"))
       (services (list 25 143 2010 6667)))

    (if (and (member host hosts)
	     (member service services))
	(setq ad-return-value
	      (open-ssh-stream name buffer host service))
      ad-do-it)))