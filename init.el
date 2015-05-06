;;; init.el

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'init-utils)
(require 'init-defaults)
(require 'init-package)

(use-package misc
  :bind ("M-z" . zap-up-to-char))

(use-package whitespace
  :diminish global-whitespace-mode
  :init (setq-default whitespace-style '(face tab-mark trailing))
  :config (global-whitespace-mode 1))

(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns))
  :config (exec-path-from-shell-initialize))

(use-package solarized-theme
  :ensure t
  :if window-system
  :init
  (setq solarized-distinct-fringe-background t
        solarized-use-variable-pitch nil
        solarized-use-less-bold t
        solarized-emphasize-indicators nil
        solarized-scale-org-headlines nil
        color-base03    "#002b36"
        color-base02    "#073642"
        color-base01    "#586e75"
        color-base00    "#657b83"
        color-base0     "#839496"
        color-base1     "#93a1a1"
        color-base2     "#eee8d5"
        color-base3     "#fdf6e3"
        color-yellow    "#b58900"
        color-orange    "#cb4b16"
        color-red       "#dc322f"
        color-magenta   "#d33682"
        color-violet    "#6c71c4"
        color-blue      "#268bd2"
        color-cyan      "#2aa198"
        color-green     "#859900"
        color-mode-line-background "#084150")
  :config
  (load-theme 'solarized-dark t)
  (set-face-attribute 'region nil :background color-base3 :foreground color-magenta)
  (set-face-attribute 'mode-line nil :background color-mode-line-background))

(use-package smart-mode-line
  :ensure t
  :init (sml/setup))

(use-package ace-jump-mode
  :ensure t
  :bind ("C-c <SPC>" . ace-jump-mode))

(use-package ace-window
  :ensure t
  :bind ("C-x o" . ace-window))

(use-package undo-tree
  :ensure t
  :diminish undo-tree-mode
  :config (global-undo-tree-mode))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(use-package multiple-cursors
  :ensure t
  :init (setq mc/list-file (concat my-gen-dir "mc-lists.el")))

(use-package volatile-highlights
  :ensure t
  :diminish volatile-highlights-mode
  :config (volatile-highlights-mode t))

(use-package anzu
  :ensure t
  :diminish anzu-mode
  :config (global-anzu-mode +1))

(use-package magit
  :ensure t
  :diminish magit-auto-revert-mode
  :init (setq magit-last-seen-setup-instructions "1.4.0")
  :bind (("C-c g s" . magit-status)
         ("C-c g l" . magit-file-log)
         ("C-c g b" . magit-blame-mode)))

(use-package git-gutter-fringe
  :ensure t
  :diminish git-gutter-mode
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

(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :config
  (require 'smartparens-config)
  (smartparens-global-mode 1))

(use-package restclient
  :ensure t)

(use-package markdown-mode
  :ensure t
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode)))

(use-package json-mode
  :ensure t)

(use-package js2-mode
  :ensure t
  :mode "\\.js\\'"
  :init
  (setq js2-highlight-level 3
        js2-basic-offset 2
        js2-allow-rhino-new-expr-initializer nil
        js2-global-externs '("describe" "before" "beforeEach" "after" "afterEach" "it")
        js2-include-node-externs t)
  :config
  (rename-modeline "js2-mode" js2-mode "JS2")
  (add-hook 'js2-mode-hook 'subword-mode)
  (use-package tern
    :ensure t
    :diminish tern-mode
    :config
    (add-hook 'js2-mode-hook (lambda () (tern-mode t))))
  (use-package js-doc
    :ensure t)
  (use-package js2-refactor
    :ensure t
    :diminish js2-refactor-mode
    :config
    (add-hook 'js2-mode-hook #'js2-refactor-mode)
    (js2r-add-keybindings-with-prefix "C-c C-m")))

(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.ejs\\'" . web-mode)
         ("\\.jsx\\'" . web-mode))
  :init
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-style-padding 2
        web-mode-script-padding 2)
  (add-hook 'web-mode-hook (lambda () (local-set-key (kbd "C-=") 'web-mode-mark-and-expand))))

(use-package jsx-mode
  :ensure t)

(use-package tss
  :ensure t
  :mode ("\\.ts\\'" . typescript-mode))

(use-package css-mode
  :init (setq css-indent-offset 2)
  :config
  (use-package rainbow-mode
    :ensure t
    :diminish rainbow-mode
    :config
    (add-hook 'css-mode-hook (lambda () (rainbow-mode t)))))

(use-package less-css-mode
  :ensure t)

(use-package scss-mode
  :ensure t)

(load custom-file 'no-error 'no-message)

(provide 'init)
;;; init.el ends here
