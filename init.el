;; User pack init file
;;
;; User this file to initiate the pack configuration.
;; See README for more information.

;; Load bindings config
(live-load-config-file "bindings.el")


(require 'package)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;; required because of a package.el bug
(setq url-http-attempt-keepalives nil)

(defvar my-packages '(expand-region gist helm helm-projectile magit magithub melpa
                      rainbow-mode volatile-highlights htmlize highlight-symbol
                      evil hippie-expand-slime ac-slime solarized-theme
	 	                  highlight-indentation rainbow-delimiters auto-complete smart-tab diminish
                      paredit color-theme-sanityinc-solarized fill-column-indicator shen-mode
                      nrepl lua-mode))

(defun my-packages-installed-p ()
  (loop for p in my-packages
        when (not (package-installed-p p))
        do (return nil)
        finally (return t)))

(defun install-my-packages ()
  (unless (my-packages-installed-p)
    (package-refresh-contents)
    ;; install the missing packages
    (dolist (p my-packages)
      (unless (package-installed-p p)
        (package-install p)))))

(install-my-packages)

(require 'evil)

(defun evil-passthrough (&optional arg)
  "Execute the next command in Emacs state."
  (interactive "p")
  (cond
   (arg
    (add-hook 'post-command-hook 'evil-passthrough nil t)
    (evil-emacs-state))
   ((not (eq this-command #'evil-passthrough))
    (remove-hook 'post-command-hook 'evil-passthrough t)
    (evil-exit-emacs-state))))

(global-set-key (kbd "M-p") 'evil-passthrough)

(evil-define-command evil-switch-header ()
  "Switch between header and impl"
  :repeat nil
  (interactive)
  (ff-find-related-file nil t))

(defun evil-kill-line (&optional arg)
  (interactive "p")
    (paredit-kill arg))

(evil-ex-define-cmd "A" 'evil-switch-header)

(evil-mode 1)

(mapcar #'(lambda (map)
            (define-key map (kbd "C-h") 'comment-or-uncomment-region-or-line)
            (define-key map (kbd "C-k") 'paredit-kill)
            (define-key map (kbd "C-y") 'yank))
        (list evil-insert-state-map evil-normal-state-map))

(evil-set-cursor-color "magenta")

(define-key paredit-mode-map (read-kbd-macro "C-<right>") 'paredit-forward)
(define-key paredit-mode-map (read-kbd-macro "C-<left>") 'paredit-backward)
(define-key paredit-mode-map (read-kbd-macro "M-<right>") 'paredit-forward-slurp-sexp)
(define-key paredit-mode-map (read-kbd-macro "M-<left>") 'paredit-backward-slurp-sexp)
(define-key paredit-mode-map (read-kbd-macro "M-<up>") 'paredit-backward-barf-sexp)
(define-key paredit-mode-map (read-kbd-macro "M-<down>") 'paredit-forward-barf-sexp)

(setq nrepl-popup-stacktraces-in-repl t)
(setq nrepl-history-file "~/.emacs.d/nrepl-history")
