;;; -*- lexical-binding: t -*-
;;; ohai-complete.el --- All cool IDEs have IntelliSense.

;; Copyright (C) 2015 Bodil Stokke

;; Author: Bodil Stokke <bodil@bodil.org>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Code:

(require 'ohai-package)
(require 'ohai-appearance)
(require 'ohai-centaur)

(use-package company
  :demand t
  :commands company-mode
  :config
  ;; Enable company-mode globally.
  (global-company-mode)
  ;; Except when you're in term-mode.
  (setq company-global-modes '(not term-mode))
  ;; Give Company a decent default configuration.
  (setq company-minimum-prefix-length 2
        company-selection-wrap-around t
        company-show-numbers t
        company-tooltip-align-annotations t
        company-require-match nil
        company-dabbrev-downcase nil
        company-dabbrev-ignore-case nil)

  ;; ;; after a short delay.
  (use-package company-quickhelp
    :config
    (setq company-quickhelp-delay 1)
    (company-quickhelp-mode 1))

  ;;Add a completion source for emoji. 😸
  (use-package company-emoji
    :config
    (company-emoji-init))
  ;; Use C-\ to activate the Company autocompleter.
  ;; We invoke company-try-hard to gather completion candidates from multiple
  ;; sources if the active source isn't being very forthcoming.
  (use-package company-try-hard
    :commands company-try-hard
    :bind ("C-\\" . company-try-hard)
    :config
    (bind-keys :map company-active-map
               ("C-\\" . company-try-hard)))
  :diminish company-mode)

(use-package company-box
      :diminish
      :hook (company-mode . company-box-mode)
      :init (setq company-box-enable-icon centaur-icon
                  company-box-backends-colors nil
                  company-box-show-single-candidate t
                  company-box-max-candidates 50
                  company-box-doc-delay 0.2)
      :config
      (with-no-warnings
        ;; Highlight `company-common'
        (defun my-company-box--make-line (candidate)
          (-let* (((candidate annotation len-c len-a backend) candidate)
                  (color (company-box--get-color backend))
                  ((c-color a-color i-color s-color) (company-box--resolve-colors color))
                  (icon-string (and company-box--with-icons-p (company-box--add-icon candidate)))
                  (candidate-string (concat (propertize (or company-common "") 'face 'company-tooltip-common)
                                            (substring (propertize candidate 'face 'company-box-candidate)
                                                       (length company-common) nil)))
                  (align-string (when annotation
                                  (concat
                                   " "
                                   (and company-tooltip-align-annotations
                                        (propertize " "
                                                    'display
                                                    `(space :align-to (- right-fringe ,(or len-a 0) 1)))))))
                  (space company-box--space)
                  (icon-p company-box-enable-icon)
                  (annotation-string (and annotation (propertize annotation 'face 'company-box-annotation)))
                  (line (concat (unless (or (and (= space 2) icon-p) (= space 0))
                                  (propertize " " 'display `(space :width ,(if (or (= space 1) (not icon-p)) 1 0.75))))
                                (company-box--apply-color icon-string i-color)
                                (company-box--apply-color candidate-string c-color)
                                align-string
                                (company-box--apply-color annotation-string a-color)))
                  (len (length line)))
            (add-text-properties 0 len (list 'company-box--len (+ len-c len-a)
                                             'company-box--color s-color)
                                 line)
            line))
        (advice-add #'company-box--make-line :override #'my-company-box--make-line)

        ;; Prettify icons
        (defun my-company-box-icons--elisp (candidate)
          (when (derived-mode-p 'emacs-lisp-mode)
            (let ((sym (intern candidate)))
              (cond ((fboundp sym) 'Function)
                    ((featurep sym) 'Module)
                    ((facep sym) 'Color)
                    ((boundp sym) 'Variable)
                    ((symbolp sym) 'Text)
                    (t . nil)))))
        (advice-add #'company-box-icons--elisp :override #'my-company-box-icons--elisp))

      (when (icons-displayable-p)
        (declare-function all-the-icons-faicon 'all-the-icons)
        (declare-function all-the-icons-material 'all-the-icons)
        (declare-function all-the-icons-octicon 'all-the-icons)
        (setq company-box-icons-all-the-icons
              `((Unknown . ,(all-the-icons-material "find_in_page" :height 0.85 :v-adjust -0.15))
                (Text . ,(all-the-icons-faicon "text-width" :height 0.8 :v-adjust -0.02))
                (Method . ,(all-the-icons-faicon "cube" :height 0.85 :v-adjust -0.02 :face 'all-the-icons-purple))
                (Function . ,(all-the-icons-faicon "cube" :height 0.85 :v-adjust -0.02 :face 'all-the-icons-purple))
                (Constructor . ,(all-the-icons-faicon "cube" :height 0.85 :v-adjust -0.02 :face 'all-the-icons-purple))
                (Field . ,(all-the-icons-octicon "tag" :height 0.9 :v-adjust 0 :face 'all-the-icons-lblue))
                (Variable . ,(all-the-icons-octicon "tag" :height 0.9 :v-adjust 0 :face 'all-the-icons-lblue))
                (Class . ,(all-the-icons-material "settings_input_component" :height 0.8 :v-adjust -0.15 :face 'all-the-icons-orange))
                (Interface . ,(all-the-icons-material "share" :height 0.85 :v-adjust -0.15 :face 'all-the-icons-lblue))
                (Module . ,(all-the-icons-material "view_module" :height 0.85 :v-adjust -0.15 :face 'all-the-icons-lblue))
                (Property . ,(all-the-icons-faicon "wrench" :height 0.8 :v-adjust -0.02))
                (Unit . ,(all-the-icons-material "settings_system_daydream" :height 0.85 :v-adjust -0.15))
                (Value . ,(all-the-icons-material "format_align_right" :height 0.85 :v-adjust -0.15 :face 'all-the-icons-lblue))
                (Enum . ,(all-the-icons-material "storage" :height 0.85 :v-adjust -0.15 :face 'all-the-icons-orange))
                (Keyword . ,(all-the-icons-material "filter_center_focus" :height 0.85 :v-adjust -0.15))
                (Snippet . ,(all-the-icons-material "format_align_center" :height 0.85 :v-adjust -0.15))
                (Color . ,(all-the-icons-material "palette" :height 0.85 :v-adjust -0.15))
                (File . ,(all-the-icons-faicon "file-o" :height 0.85 :v-adjust -0.02))
                (Reference . ,(all-the-icons-material "collections_bookmark" :height 0.85 :v-adjust -0.15))
                (Folder . ,(all-the-icons-faicon "folder-open" :height 0.85 :v-adjust -0.02))
                (EnumMember . ,(all-the-icons-material "format_align_right" :height 0.85 :v-adjust -0.15))
                (Constant . ,(all-the-icons-faicon "square-o" :height 0.85 :v-adjust -0.1))
                (Struct . ,(all-the-icons-material "settings_input_component" :height 0.8 :v-adjust -0.15 :face 'all-the-icons-orange))
                (Event . ,(all-the-icons-octicon "zap" :height 0.85 :v-adjust 0 :face 'all-the-icons-orange))
                (Operator . ,(all-the-icons-material "control_point" :height 0.85 :v-adjust -0.15))
                (TypeParameter . ,(all-the-icons-faicon "arrows" :height 0.8 :v-adjust -0.02))
                (Template . ,(all-the-icons-material "format_align_left" :height 0.85 :v-adjust -0.15)))
              company-box-icons-alist 'company-box-icons-all-the-icons)))

(provide 'ohai-complete)
