;;; -*- mode: emacs-lisp; coding: utf-8-unix; indent-tabs-mode: nil -*-

(when (require 'ruby-mode nil t)
  (setq ruby-indent-level 2
        ruby-indent-tabs-mode nil
        ruby-deep-indent-paren-style nil)

  (mapc '(lambda (arg)
           (cons arg auto-mode-alist))
        (list '("\\.rb$" . ruby-mode)
              '("Rakefile" . ruby-mode)))

  (define-key ruby-mode-map "\C-m" 'ruby-reindent-then-newline-and-indent)

  (and (require 'ruby-electric nil t)
       (setq ruby-electric-expand-delimiters-list nil)
       (add-hook 'ruby-mode-hook
                 '(lambda ()
                    (ruby-electric-mode 1))))

  (and (require 'inf-ruby nil t)
       (setq interpreter-mode-alist
             (cons '("ruby" . ruby-mode) interpreter-mode-alist))
       (let
           ((ruby (locate-executable "ruby"))
            (irb (locate-library "irb" nil exec-path))
            (args (list "--inf-ruby-mode" "-Ku")))

         (and irb
              (setq ruby-program-name
                    (mapconcat #'identity
                               `(,ruby ,irb ,@args) " "))

              (add-hook 'ruby-mode-hook
                        '(lambda ()
                           (inf-ruby-keys))))))

  ;; Software Design 2008-02 P152
  ;; devel/which and ffap
  (with-temp-buffer
    (call-process-shell-command
     "ruby -e 'require %[devel/which]'" nil t)
    (goto-char (point-min))
    (unless (re-search-forward "LoadError" nil t)
      (defun ffap-ruby-mode (name)
        (shell-command-to-string
         (format "
ruby -e '
require %%[rubygems]
require %%[devel/which]
require %%[%s]
print(which_library(%%[%s]))'"
                 name name))

        (defun find-rubylib (name)
          (interactive "sRuby library name: ")
          (find-file (ffap-ruby-mode name)))

        (and (require 'ffap nil t)
             (add-to-list 'ffap-alist '(ruby-mode . ffap-ruby-mode))))))

  ;; Software Design 2008-02 P153
  ;; ri
  (when (and
         (locate-executable "fastri-server")
         (locate-executable "fri")
         (setq ri-ruby-script (locate-executable "ri-emacs"))
         (load "ri-ruby" 'noerror))

    (defun fastri-server-alive-p ()
      (with-temp-buffer
        (let
            ((progname "fastri-server")
             (wmic-tmp-file "TempWmicBatchFile.bat"))
          (cond
           ((or (eq system-type 'cygwin)
                (eq system-type 'windows-nt))
            (call-process "wmic" nil t t "process")
            (when (file-exists-p wmic-tmp-file)
              (delete-file wmic-tmp-file)))
           (t
            (call-process "ps" nil t t "uxww")))
          (goto-char (point-min))
          (not (not (re-search-forward progname nil t))))))

    (defun fastri-server-start ()
      (unless (fastri-server-alive-p)
        (message "starting fastri-server. please wait...")
        (let*
            ((progname "fastri-server")
             (buffname (format "*%s*" progname)))

          (start-process progname buffname progname)
          (while (not
                  (with-temp-buffer
                    (sit-for 0.5)
                    (call-process
                     "fri" nil t t "Kernel#lambda")
                    (goto-char (point-min))
                    (re-search-forward "lambda" nil t)))))))

    (defadvice ri-ruby-get-process (before ri/force-start-fastri-server
                                           activate)
      (fastri-server-start)))

  ;; Software Design 2008-02 P154
  ;; xmpfilter (rcodetools)
  (when (require 'rcodetools nil t)
    (when (require 'anything-rcodetools nil t)
      (setq rct-get-all-methods-command "PAGER=cat fri -l")
      (define-key anything-map "\C-z" 'anything-execute-persistent-action))

    (setq rct-find-tag-if-available nil)

    (defun make-ruby-scratch-buffer ()
      (let*
          ((buffer-name-base "ruby scratch")
           (exist-buffer-count
            (length
             (remove nil
                     (mapcar
                      '(lambda (arg)
                         (string-match buffer-name-base
                                       (buffer-name arg)))
                      (buffer-list))))))

        (with-current-buffer (get-buffer-create
                              (format "*%s<%s>*"
                                      buffer-name-base
                                      exist-buffer-count))
          (ruby-mode)
          (current-buffer))))

    (defun ruby-scratch ()
      (interactive)
      (pop-to-buffer (make-ruby-scratch-buffer)))

    (add-hook
     'ruby-mode-hook
     '(lambda ()
        (mapc (lambda (pair)
                (apply #'define-key ruby-mode-map pair))
              (list
               '([(meta i)]                rct-complete-symbol)
               '([(meta control i)]        rct-complete-symbol)
               '([(control c) (control t)] ruby-toggle-buffer)
               '([(control c) (control d)] xmp)
               '([(control c) (control f)] rct-ri)))))))
