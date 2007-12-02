;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;; $Id$

;; based upon
;; http://deisui.bug.org/%7Eueno/memo/emacs-ssh.html
;; http://triaez.kaisei.org/%7Ekaoru/ssh/emacs-ssh.html

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



(defun open-ssh-stream-idea (name buffer host service)
  (open-ssh-stream-internal :relay "elim.teroknor.org"
			    :command "nc"
			    :name name
			    :buffer buffer
			    :host host
			    :service service))

(add-to-list 'riece-server-alist
      '("idea"
	:host "localhost"
	:service 6667
	:coding utf-8
	:function open-ssh-stream-idea))