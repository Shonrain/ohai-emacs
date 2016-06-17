;;; ohai-scala.el --- Ohai scala support

;;; Commentary:
;; Bring scala development related modes

;;; Code:
(require 'ohai-lib)
(define-derived-mode sbt-build-mode scala-mode ".sbt build file major mode")
(add-to-list 'auto-mode-alist '("\\.sbt\\'" . sbt-build-mode))

(use-package scala-mode
  :config
  (when (ohai/resolve-exec "drip") (setenv "JAVACMD" "drip"))
  (setq scala-indent:use-javadoc-style t)
  (use-package sbt-mode
    :config
    (defun compile-sbt-project ()
      (interactive)
      "Compile the sbt project."
      (when
          (comint-check-proc (sbt:buffer-name))
        (sbt-command "test:compile")))))


(global-set-key (kbd "C-c b") 'compile-sbt-project)
(provide 'ohai-scala)
;;; Enable compile on save

;;; ohai-scala.el ends here
