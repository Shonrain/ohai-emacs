(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ohai-personal-taste/paredit t)
 '(ohai-personal-taste/run-wizard nil)
 '(ohai-personal-taste/splash nil)
 '(ohai-personal-taste/style (quote light))
 '(ohai-personal-taste/training-wheels nil)
 '(ohai-personal-taste/window-state (quote normal))
 '(ohai/modules
   (quote
    (ohai-appearance
     ohai-fonts
     ohai-general
     ohai-splash
     ohai-helm
     ohai-gtags
     ohai-html
     ohai-navigation
     ohai-editing
     ohai-complete
     ohai-javascript
     ohai-snippets
     ohai-codestyle
     ohai-dired
     ohai-project
     ohai-flycheck
     ohai-git
     ohai-orgmode
     ohai-scala
     ohai-php
     ohai-help
     ohai-elisp))))
(setq-default tramp-ssh-controlmaster-options "-o ControlMaster=auto -o ControlPath='tramp.%%C' -o ControlPersist=no")