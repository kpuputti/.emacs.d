;;; init.el

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'init-utils)
(require 'init-defaults)
(require 'init-package)

(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns))
  :config (exec-path-from-shell-initialize))

(use-package color-theme-solarized
  :ensure t
  :if window-system
  :config
  (load-theme 'solarized t)
  (set-frame-parameter nil 'background-mode 'dark)
  (enable-theme 'solarized))

(use-package ace-window
  :ensure t
  :bind ("C-x o" . ace-window))

(use-package undo-tree
  :ensure t
  :config (global-undo-tree-mode))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(use-package multiple-cursors
  :ensure t
  :init (setq mc/list-file (concat my-gen-dir "mc-lists.el")))

(use-package volatile-highlights
  :ensure t
  :config (volatile-highlights-mode t))

(use-package anzu
  :ensure t
  :config (global-anzu-mode +1))

(use-package magit
  :ensure t
  :init (setq magit-last-seen-setup-instructions "1.4.0")
  :bind (("C-c g s" . magit-status)
         ("C-c g l" . magit-file-log)
         ("C-c g b" . magit-blame-mode)))

(use-package git-gutter-fringe
  :ensure t
  :init (setq git-gutter-fr:side 'right-fringe)
  :config (global-git-gutter-mode t))

(use-package ag
  :ensure t)

(use-package projectile
  :ensure t
  :config (projectile-global-mode))

(use-package flycheck
  :ensure t
  :init (setq flycheck-highlighting-mode 'nil)
  :config (add-hook 'after-init-hook #'global-flycheck-mode))

(load custom-file 'no-error 'no-message)

(provide 'init)
;;; init.el ends here
