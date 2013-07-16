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

;(define-key evil-normal-state-map ":A" 'ff-find-related-file)

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

(provide 'init-evil)
