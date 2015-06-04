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
  (set-face-attribute 'mode-line nil :background color-mode-line-background :box nil))

(use-package smart-mode-line
  :ensure t
  :if window-system
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

(use-package company
  :ensure t
  :diminish company-mode
  :init (add-hook 'after-init-hook 'global-company-mode)
  :config
  (use-package company-tern
    :ensure t
    :init (add-to-list 'company-backends 'company-tern)))

(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :config
  (yas-global-mode 1))

(use-package magit
  :ensure t
  :diminish magit-auto-revert-mode
  :init (setq magit-last-seen-setup-instructions "1.4.0")
  :bind (("C-c g s" . magit-status)
         ("C-c g l" . magit-file-log)
         ("C-c g b" . magit-blame-mode)))

(use-package git-gutter-fringe
  :ensure t
  :disabled t
  :diminish git-gutter-mode
  :init (setq git-gutter-fr:side 'right-fringe)
  :config (global-git-gutter-mode t))

(use-package ag
  :ensure t)

(use-package helm
  :ensure t
  :diminish helm-mode
  :bind ("C-c i" . helm-imenu)
  :config
  (require 'helm-config)
  (helm-mode 1)
  (use-package helm-ag
    :ensure t
    :bind ("C-c h a" . helm-ag))
  (use-package helm-spotify
    :ensure t))

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode)
  (use-package helm-projectile
    :ensure t))

(use-package flycheck
  :ensure t
  :init
  (setq flycheck-highlighting-mode 'nil)
  (add-hook 'after-init-hook #'global-flycheck-mode)
  :config
  ;; Disable JSHint checker in favor of ESLint.
  (setq-default flycheck-disabled-checkers '(javascript-jshint)))

(use-package smartparens
  :ensure t
  :disabled t
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
  :ensure t
  :init (setq js-indent-level 2))

(use-package js2-mode
  :ensure t
  :mode "\\.js\\'"
  :init
  (setq js2-highlight-level 3
        js2-basic-offset 2
        js2-allow-rhino-new-expr-initializer nil
        js2-global-externs '("describe" "before" "beforeEach" "after" "afterEach" "it")
        js2-include-node-externs t)
  (add-hook 'js2-mode-hook (lambda ()
                             (subword-mode 1)
                             (diminish 'subword-mode)))
  (add-hook 'js2-mode-hook 'js2-imenu-extras-mode)
  (rename-modeline "js2-mode" js2-mode "JS2")
  :config
  (use-package tern
    :ensure t
    :diminish tern-mode
    :init
    (add-hook 'js2-mode-hook 'tern-mode))
  (use-package js-doc
    :ensure t)
  (use-package js2-refactor
    :ensure t
    :diminish js2-refactor-mode
    :init
    (add-hook 'js2-mode-hook #'js2-refactor-mode)
    :config
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

  (defun my-setup-web-mode-html ()
    (local-set-key (kbd "C-=") 'web-mode-mark-and-expand)
    (setq-default flycheck-disabled-checkers '(javascript-eslint javascript-jshint))
    (flycheck-select-checker nil))

  (defun my-setup-web-mode-jsx ()
    (local-set-key (kbd "C-=") 'er/expand-region)
    (flycheck-add-mode 'javascript-eslint 'web-mode)
    (setq-default flycheck-disabled-checkers '(javascript-jshint))
    (flycheck-select-checker 'javascript-eslint)
    (tern-mode 1))

  (defun my-setup-web-mode ()
    (if (equal (file-name-extension buffer-file-name) "jsx")
        (my-setup-web-mode-jsx)
      (my-setup-web-mode-html)))

  (defun my-web-mode-hook ()
    (setq-local electric-pair-pairs (append electric-pair-pairs '((?' . ?'))))
    (setq-local electric-pair-text-pairs electric-pair-pairs))

  (defadvice switch-to-buffer (after my-select-web-mode-config activate)
    (when (equal major-mode 'web-mode)
      (my-setup-web-mode)))

  (add-hook 'web-mode-hook 'my-web-mode-hook))

(use-package jsx-mode
  :ensure t
  :init (setq jsx-indent-level 2))

(use-package tss
  :ensure t
  :mode ("\\.ts\\'" . typescript-mode))

(use-package css-mode
  :init (setq css-indent-offset 2)
  :config
  (use-package rainbow-mode
    :ensure t
    :diminish rainbow-mode
    :init
    (add-hook 'css-mode-hook (lambda () (rainbow-mode t)))))

(use-package less-css-mode
  :ensure t)

(use-package scss-mode
  :ensure t)

(use-package scala-mode2
  :ensure t
  :config
  (use-package sbt-mode
    :ensure t)
  (use-package ensime
    :ensure t
    :init
    (add-hook 'scala-mode-hook 'ensime-scala-mode-hook)))

(load custom-file 'no-error 'no-message)

(provide 'init)
;;; init.el ends here
