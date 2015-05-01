;;; init-defaults.el

(defconst is-osx (eq system-type 'darwin))
(defconst my-gen-dir (file-name-as-directory (concat user-emacs-directory "gen")))

;; Hide menu bar unless we're on a GUI within OSX.
(unless (and window-system is-osx)
  (menu-bar-mode -1))

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

(when (fboundp 'winner-mode)
  (winner-mode 1))

(setq uniquify-buffer-name-style 'forward)

(setq-default save-place t)
(require 'saveplace)

(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

(defalias 'qrr 'query-replace-regexp)
(defalias 'dtr 'delete-trailing-whitespace)

(global-linum-mode 1)
(line-number-mode 1)
(column-number-mode 1)
(global-hl-line-mode 1)
(show-paren-mode 1)
(size-indication-mode t)
(blink-cursor-mode -1)

;; Enable whitespace-mode, but keep it subtle.
(global-whitespace-mode 1)
(setq-default whitespace-style '(face tab-mark trailing))

;; Disable modeline 3D highlighting.
(set-face-attribute 'mode-line nil :box nil)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 8)

;; Use UTF-8 everywhere by default.
;; http://stackoverflow.com/a/2903256
(setq utf-translate-cjk-mode nil) ; disable CJK coding/encoding (Chinese/Japanese/Korean characters)
(set-language-environment 'utf-8)
(set-keyboard-coding-system 'utf-8-mac) ; For old Carbon emacs on OS X only
(setq locale-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(unless (eq system-type 'windows-nt)
  (set-selection-coding-system 'utf-8))
(prefer-coding-system 'utf-8)

;; Save recently visited files.
(recentf-mode 1)
(setq recentf-save-file (concat my-gen-dir "recentf")
      recentf-max-saved-items 1000
      recentf-max-menu-items 15)

;; Save minibuffer command history.
(setq savehist-additional-variables
      '(kill-ring search-ring regexp-search-ring)
      savehist-autosave-interval 60
      savehist-file (concat my-gen-dir "history"))
(savehist-mode 1)

;; Save bookmarks every time one is added.
(setq bookmark-default-file (concat my-gen-dir "bookmarks.el"))
(defadvice bookmark-set (after save-bookmarks-automatically activate)
  (bookmark-save))

;; Automatically refresh buffers when the underlying file changes.
(global-auto-revert-mode t)

(fset 'yes-or-no-p 'y-or-n-p)

(setq font-lock-maximum-decoration t
      color-theme-is-global t

      inhibit-startup-screen t
      inhibit-startup-echo-area-message t
      initial-scratch-message nil

      save-interprogram-paste-before-kill t
      apropos-do-all t
      mouse-yank-at-point t
      ring-bell-function 'ignore
      load-prefer-newer t
      ediff-window-setup-function 'ediff-setup-windows-plain

      save-place-file (concat my-gen-dir "places")
      custom-file (concat my-gen-dir "custom.el")

      ;; Backups
      backup-by-copying t
      version-control t
      delete-old-versions t
      delete-by-moving-to-trash t
      kept-new-versions 6
      kept-old-versions 2
      vc-make-backup-files t
      backup-directory-alist `(("." . ,(concat my-gen-dir "backups")))

      confirm-kill-emacs 'y-or-n-p)

(setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                         try-expand-dabbrev-all-buffers
                                         try-expand-dabbrev-from-kill
                                         try-complete-file-name-partially
                                         try-complete-file-name
                                         try-expand-all-abbrevs
                                         try-expand-list
                                         try-expand-line
                                         try-complete-lisp-symbol-partially
                                         try-complete-lisp-symbol))

;; Font
(when window-system
  (add-to-list 'default-frame-alist '(font . "Source Code Pro")))

;; OSX specific setup.
(when is-osx
  (setq mac-option-modifier nil
        mac-command-modifier 'meta))

(provide 'init-defaults)
;;; init-defaults.el ends here
