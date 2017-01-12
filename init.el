;;; init.el

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'init-utils)
(require 'init-defaults)
(require 'init-package)

(setq use-package-always-ensure t)

(use-package misc
  :ensure f
  :bind ("M-z" . zap-up-to-char))

(use-package ibuffer
  :bind ("C-x C-b" . ibuffer))

(use-package whitespace
  :diminish global-whitespace-mode
  :init (setq-default whitespace-style '(face tab-mark trailing))
  :config (global-whitespace-mode 1))

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :config (exec-path-from-shell-initialize))

(use-package solarized-theme
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
  :if window-system
  :init (sml/setup))

(use-package ace-jump-mode
  :disabled t
  :bind ("C-c <SPC>" . ace-jump-mode))

(use-package avy
  :bind ("C-." . avy-goto-word-1)
  :config (setq avy-all-windows nil))

(use-package ace-window
  :bind* ("M-o" . ace-window)
  :init (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package undo-tree
  :diminish undo-tree-mode
  :config (global-undo-tree-mode))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package multiple-cursors
  :bind (("C-c m c" . mc/edit-lines)
         ("C-c m n" . mc/mark-next-like-this)
         ("C-c m p" . mc/mark-previous-like-this)
         ("C-c m a" . mc/mark-all-like-this))
  :init (setq mc/list-file (concat my-gen-dir "mc-lists.el")))

(use-package volatile-highlights
  :diminish volatile-highlights-mode
  :config (volatile-highlights-mode t))

(use-package anzu
  :diminish anzu-mode
  :config (global-anzu-mode +1))

(use-package company
  :diminish company-mode
  :init
  (setq company-dabbrev-ignore-case t
        company-dabbrev-downcase nil)
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  (use-package company-tern
    :init (add-to-list 'company-backends 'company-tern)))

(use-package yasnippet
  :disabled t
  :diminish yas-minor-mode
  :config
  (yas-global-mode 1))

(use-package magit
  :bind (("C-c g s" . magit-status)
         ("C-c g b" . magit-blame)
         ("C-c g d" . vc-diff)))

(use-package git-gutter-fringe
  :disabled t
  :diminish git-gutter-mode
  :init (setq git-gutter-fr:side 'right-fringe)
  :config (global-git-gutter-mode t))

(use-package ag)

(use-package helm
  :diminish helm-mode
  :bind (("C-c i" . helm-imenu)
         ("M-y" . helm-show-kill-ring)
         ("M-x" . helm-M-x))
  :init
  (require 'helm-config)
  (helm-mode 1)

  ;; https://www.reddit.com/r/emacs/comments/345vtl/make_helm_window_at_the_bottom_without_using_any/
  (add-to-list 'display-buffer-alist
               `(,(rx bos "*helm" (* not-newline) "*" eos)
                 (display-buffer-in-side-window)
                 (inhibit-same-window . t)
                 (window-height . 0.4))))

(use-package projectile
  :config
  (projectile-global-mode)
  (use-package helm-projectile
    :bind ("C-c p s a" . helm-projectile-ag)))

(use-package flycheck
  :init
  (setq flycheck-highlighting-mode 'nil)
  (add-hook 'after-init-hook #'global-flycheck-mode)
  :config
  ;; Disable JSHint checker in favor of ESLint.
  (setq-default flycheck-disabled-checkers '(javascript-jshint)))

(use-package smartparens-config
  :ensure smartparens
  :diminish smartparens-mode
  :config
  (smartparens-global-strict-mode))

(use-package restclient)

(use-package markdown-mode
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode)))

(use-package json-mode
  :init (setq js-indent-level 2))

(use-package js2-mode
  :mode (("\\.js\\'" . js2-jsx-mode))
  :init
  (setq js2-highlight-level 3
        js2-mode-assume-strict t
        js2-strict-trailing-comma-warning nil
        js2-missing-semi-one-line-override t
        js2-allow-rhino-new-expr-initializer nil
        js2-global-externs '("jest"
                             "require"
                             "describe"
                             "it"
                             "test"
                             "expect"
                             "afterEach"
                             "beforeEach"
                             "afterAll"
                             "beforeAll")
        js2-include-node-externs t
        js2-warn-about-unused-function-arguments t
        js2-basic-offset 2)
  (add-hook 'js2-mode-hook (lambda ()
                             (subword-mode 1)
                             (diminish 'subword-mode)
                             (js2-imenu-extras-mode 1)))
  (rename-modeline "js2-mode" js2-mode "JS2")
  (rename-modeline "js2-mode" js2-jsx-mode "JSX2")
  :config
  (use-package tern
    :diminish tern-mode
    :init
    (add-hook 'js2-mode-hook 'tern-mode))
  (use-package js-doc)
  (use-package js2-refactor
    :diminish js2-refactor-mode
    :init
    (add-hook 'js2-mode-hook #'js2-refactor-mode)
    :config
    (js2r-add-keybindings-with-prefix "C-c r")))

(use-package web-mode
  :mode (("\\.html?\\'" . web-mode)
         ("\\.ejs\\'" . web-mode))
  :init
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-style-padding 2
        web-mode-script-padding 2)

  (flycheck-add-mode 'html-tidy 'web-mode)

  (add-hook 'web-mode-hook 'my-web-mode-hook))

(use-package haml-mode)

(use-package jsx-mode
  :init (setq jsx-indent-level 2))

(use-package tss
  :mode ("\\.ts\\'" . typescript-mode))

(use-package css-mode
  :init (setq css-indent-offset 2)
  :config
  (use-package rainbow-mode
    :diminish rainbow-mode
    :init
    (add-hook 'css-mode-hook (lambda () (rainbow-mode t)))))

(use-package less-css-mode)

(use-package scss-mode
  :mode (("\\.scss\\'" . scss-mode)
         ("\\.postcss\\'" . scss-mode)))

(use-package scala-mode2
  :config
  (use-package sbt-mode)
  (use-package ensime
    :disabled t
    :init
    (add-hook 'scala-mode-hook 'ensime-scala-mode-hook)))

(use-package cider
  :config
  (add-hook 'clojure-mode-hook #'cider-mode)
  (add-hook 'cider-mode-hook #'eldoc-mode)
  (defun my-cider-reset ()
    (interactive)
    (cider-ensure-connected)
    (save-some-buffers)
    (cider-interactive-eval "(user/reset)"))
  (global-set-key (kbd "C-c r") #'my-cider-reset)
  (use-package align-cljlet
    :bind ("C-c a l" . align-cljlet)))

(use-package rainbow-delimiters
  :config
  (add-hook 'lisp-mode-hook #'rainbow-delimiters-mode))

(use-package geiser)

(use-package inf-ruby
  :config
  (add-hook 'after-init-hook 'inf-ruby-switch-setup)
  (use-package robe))

(use-package crux
  :bind ("C-M-z" . crux-indent-defun))

(load custom-file 'no-error 'no-message)

(provide 'init)
;;; init.el ends here
