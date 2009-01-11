;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (and (require 'pit nil t)
           (require 'outputz nil t))

  (setq outputz-key
        (cdr (assoc 'key
                    (pit/get 'outputz.com
                             '(require ((key . "Your Outputz key"))))))
        outputz-uri "http://%s.example.com/")

  (defvar outputz-interval-second 20
    "interval of outputz post.")

  (defun paranoid-auto-save-buffers-active-p ()
    (and (fold-left (lambda (x y)
                      (or x (equal 'auto-save-buffers (aref y 5))))
                    nil timer-idle-list)
         auto-save-buffers-active-p))

  (defun outputz-buffers ()
    (mapc (lambda (buffer)
            (with-current-buffer buffer
              (and buffer-file-name (outputz))))
          (buffer-list)))

  (defun symbiosis-outputz-auto-save-buffers ()
    (if (paranoid-auto-save-buffers-active-p)
        (and
         (outputz-buffers)
         (remove-hook 'after-save-hook 'outputz))
      (add-hook 'after-save-hook 'outputz)))

  (defadvice auto-save-buffers-toggle (after
                                       call-symbiosis-outputz-auto-save-buffers
                                       activate)
    (symbiosis-outputz-auto-save-buffers))

  (add-hook 'kill-emacs-hook 'outputz-buffers)

  (run-with-timer outputz-interval-second
                  outputz-interval-second
                  'symbiosis-outputz-auto-save-buffers)

  (and (require 'growl nil t)
       (add-hook 'outputz-mode-hook
                 (lambda ()
                   (set (make-local-variable 'outputz-latest-count) 0)))

       (defun growl-outputz (&optional count)
         (growl (format "You are %s bytes Outputz!"
                        (or count
                            outputz-latest-count))))

       (defadvice outputz-post (before
                                call-growl-outputz (count)
                                activate)
         (growl-outputz (setq outputz-latest-count count)))
       (global-outputz-mode t)))

(setq outputz-interval-second 1)