;;; init.el

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'init-utils)
(require 'init-defaults)

(load custom-file 'no-error 'no-message)

(provide 'init)
;;; init.el ends here
