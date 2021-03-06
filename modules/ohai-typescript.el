;;; ohai-typescript.el --- tide

;;; Commentary:
;;

;;; Code:

(defun setup-flycheck ()
  "Init checkers."
  (with-eval-after-load 'flycheck
    (setq lsp-prefer-flymake t)
    (advice-add 'flycheck-eslint-config-exists-p :override (lambda() t))
    (flycheck-add-mode 'javascript-eslint 'typescript-mode)))

(use-package lsp-mode)
(use-package lsp-ui)
(use-package company-lsp)
(setq company-lsp-cache-candidates t)
(use-package add-node-modules-path)
(use-package typescript-mode
  :after (flycheck)
  :hook ((typescript-mode . add-node-modules-path)
         (typescript-mode . flymake-mode)
         (typescript-mode . setup-flycheck)))

(use-package web-mode
  :after (flycheck)
  :hook ((web-mode . add-node-modules-path))
  :config
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode)))

(provide 'ohai-typescript)

;;; ohai-typescript.el ends here
