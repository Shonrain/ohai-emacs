;;; ohai-ivy.el --- Initialize ivy configurations.  -*- lexical-binding: t -*-

;; Copyright (C) 2016-2020 Vincent Zhang

;; Author: Vincent Zhang <seagle0128@gmail.com>
;; URL: https://github.com/seagle0128/.emacs.d

;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;

;;; Commentary:
;;
;; Ivy configurations.
;;

;;; Code:

(require 'ohai-centaur)

(use-package counsel
  :diminish ivy-mode counsel-mode
  :bind (("C-s"   . swiper)
         ("C-r"   . swiper-backward)
         ("s-f"   . swiper)
         ("C-S-s" . swiper-all)
         ("C-c h i" . counsel-imenu)
         ("C-c C-r" . ivy-resume)

         :map counsel-mode-map
         ([remap swiper] . counsel-grep-or-swiper)
         ([remap swiper-backward] . counsel-grep-or-swiper-backward)
         ([remap dired] . counsel-dired)
         ([remap set-variable] . counsel-set-variable)
         ([remap insert-char] . counsel-unicode-char)
         ([remap recentf-open-files] . counsel-recentf)

         ("C-x j"   . counsel-mark-ring)
         ("C-h F"   . counsel-faces)

         ("C-c B" . counsel-bookmarked-directory)
         ("C-c L" . counsel-load-library)
         ("C-c O" . counsel-find-file-extern)
         ("C-c P" . counsel-package)
         ("C-c R" . counsel-list-processes)
         ("C-c f" . counsel-find-library)
         ("C-c g" . counsel-grep)
         ("C-c i" . counsel-git)
         ("C-c j" . counsel-git-grep)
         ("C-c o" . counsel-outline)
         ("C-c r" . counsel-rg)
         ("C-c z" . counsel-fzf)

         ("C-c c B" . counsel-bookmarked-directory)
         ("C-c c F" . counsel-faces)
         ("C-c c L" . counsel-load-library)
         ("C-c c O" . counsel-find-file-extern)
         ("C-c c P" . counsel-package)
         ("C-c c R" . counsel-list-processes)
         ("C-c c a" . counsel-apropos)
         ("C-c c e" . counsel-colors-emacs)
         ("C-c c f" . counsel-find-library)
         ("C-c c g" . counsel-grep)
         ("C-c c h" . counsel-command-history)
         ("C-c c i" . counsel-git)
         ("C-c c j" . counsel-git-grep)
         ("C-c c l" . counsel-locate)
         ("C-c c m" . counsel-minibuffer-history)
         ("C-c c o" . counsel-outline)
         ("C-c c p" . counsel-pt)
         ("C-c c r" . counsel-rg)
         ("C-c c s" . counsel-ag)
         ("C-c c t" . counsel-load-theme)
         ("C-c c u" . counsel-unicode-char)
         ("C-c c w" . counsel-colors-web)
         ("C-c c v" . counsel-set-variable)
         ("C-c c z" . counsel-fzf)

         :map ivy-minibuffer-map
         ("C-w" . ivy-yank-word)
         ("C-`" . ivy-avy)

         :map counsel-find-file-map
         ("C-h" . counsel-up-directory)

         :map swiper-map
         ("M-s" . swiper-isearch-toggle)
         ("M-%" . swiper-query-replace)

         :map isearch-mode-map
         ("M-s" . swiper-isearch-toggle))
  :hook ((after-init . ivy-mode)
         (ivy-mode . counsel-mode))
  :init
  (setq enable-recursive-minibuffers t) ; Allow commands in minibuffers

  (setq ivy-use-selectable-prompt t
        ivy-use-virtual-buffers t    ; Enable bookmarks and recentf
        ivy-height 10
        ivy-fixed-height-minibuffer t
        ivy-count-format "(%d/%d) "
        ivy-on-del-error-function nil
        ivy-initial-inputs-alist nil)

  ;; Better performance on Windows
  (when sys/win32p
    (setq ivy-dynamic-exhibit-delay-ms 200))

  (setq swiper-action-recenter t)

  (setq counsel-find-file-at-point t
        counsel-yank-pop-separator "\n────────\n")

  ;; Additional key bindings for Ivy
  (use-package ivy-hydra
    :commands ivy-hydra-read-action
    :init (setq ivy-read-action-function #'ivy-hydra-read-action))

  ;; Ivy integration for Projectile
  (use-package counsel-projectile
    :hook (counsel-mode . counsel-projectile-mode)
    :init (setq counsel-projectile-grep-initial-input '(ivy-thing-at-point)))

  ;; Integrate yasnippet
  (use-package ivy-yasnippet
    :bind ("C-c C-y" . ivy-yasnippet))

  ;; Select from xref candidates with Ivy
  (use-package ivy-xref
    :init
    (when (boundp 'xref-show-definitions-function)
      (setq xref-show-definitions-function #'ivy-xref-show-defs))
    (setq xref-show-xrefs-function #'ivy-xref-show-xrefs)))
;; Better experience with icons
;; Enable it before`ivy-rich-mode' for better performance
(use-package all-the-icons-ivy-rich
  :if (icons-displayable-p)
  :hook (ivy-mode . all-the-icons-ivy-rich-mode)
  :init (setq all-the-icons-ivy-rich-icon-size 0.85))

;; More friendly display transformer for Ivy
(use-package ivy-rich
  :hook (;; Must load after `counsel-projectile'
         (counsel-projectile-mode . ivy-rich-mode)
         (ivy-rich-mode . (lambda ()
                            "Use abbreviate in `ivy-rich-mode'."
                            (setq ivy-virtual-abbreviate
                                  (or (and ivy-rich-mode 'abbreviate) 'name)))))
  :init
  ;; For better performance
  (setq ivy-rich-parse-remote-buffer nil))

(provide 'ohai-ivy)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ohai-ivy.el ends here
