;;; init.el --- Personal Emacs configuration -*- lexical-binding: t; -*-
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  )

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; Blocks added by customize interface
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; Machine-specific paths, set in local.el (see local.el.example for a
;; template). Declared here as nil so init.el doesn't ;; reference free
;; variables when local.el is absent.
(defvar my/r-bin-dir nil
  "Directory containing R.exe and Rscript.exe.")
(defvar my/quarto-bin-dir nil
  "Directory containing RStudio's bundled quarto tools.")
(defvar my/hunspell-dir nil
  "Directory containing the portable hunspell install.")

;; local.el is untracked (see .gitignore) and holds settings specific
;; to this machine. See local.el.example for a template.
(let ((local-file (expand-file-name "local.el" user-emacs-directory)))
  (when (file-exists-p local-file)
    (load local-file)))

;; Magit supersedes vc-mode for Git; leaving vc's own Git backend enabled
;; makes Emacs shell out to git redundantly on every buffer visit/save,
;; on top of whatever Magit itself runs.
(setq vc-handled-backends (delq 'Git vc-handled-backends))

(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; install use-package if missing
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; This is only needed once, near the top of the file
(eval-when-compile
  (require 'use-package))

(setq use-package-always-ensure t)
(setq use-package-always-defer t)

;; Load everything immediately if launching from a daemon
(if (daemonp)
    (setq use-package-always-demand t))

;; Global customisations
(blink-cursor-mode 0)

(add-to-list 'default-frame-alist '(font . "Consolas" ))
(set-face-attribute 'default t :font "Consolas" )

;; Fix sas-mode to properly parse inline comments containing '
(defvar my/sas-comment-syntax-propertize
  (syntax-propertize-rules
   ("\\(^[0-9]*\\|[:;!]\\)[ \t]*\\(%?\\*\\)[^;/][^z-a]*?\\(;\\)"
    (2 (string-to-syntax "<"))
    (3 (string-to-syntax ">")))))

(defun my/sas-fix-comment-syntax ()
  (setq-local syntax-propertize-function my/sas-comment-syntax-propertize)
  (syntax-ppss-flush-cache (point-min)))

(use-package avy
  :bind ("C-c SPC" . avy-goto-char-timer))

(use-package adaptive-wrap
  :hook (visual-line-mode . adaptive-wrap-prefix-mode))

(use-package buffer-move
  :bind (("<C-S-up>" . buf-move-up)
	 ("<C-S-down>" . buf-move-down)
	 ("<C-S-left>" . buf-move-left)
	 ("<C-S-right>" . buf-move-right)))

(use-package buffer-stack
  :load-path "lisp"
  :bind (("<f9>" . buffer-stack-bury)
	 ("C-<f9>" . buffer-stack-bury-and-kill)
	 ("<f10>" . buffer-stack-up)
	 ("<f11>" . buffer-stack-down)
	 ("<f12>" . buffer-stack-track)
	 ("C-<f12>". buffer-stack-untrack)))

(use-package csv-mode
  :hook (csv-mode . csv-align-mode))

(use-package ess
  :init
  (require 'ess-site)
  (when my/r-bin-dir
    (add-to-list 'exec-path my/r-bin-dir)
    (setenv "PATH" (concat (getenv "PATH") path-separator my/r-bin-dir)))
  (when my/quarto-bin-dir
    (setenv "PATH" (concat (getenv "PATH") path-separator my/quarto-bin-dir)))
  :hook ((inferior-ess-r-mode . (lambda()
				   (local-unset-key (kbd "C-c SPC"))))
	 (SAS-mode . my/sas-fix-comment-syntax))
  :custom
  (inferior-R-program-name (and my/r-bin-dir (expand-file-name "R.exe" my/r-bin-dir)))
  (ess-style 'RStudio))

(use-package polymode)

(use-package poly-markdown)

(use-package poly-R
  :mode ("\\.Rmd\\'" . poly-markdown+r-mode))

(use-package flyspell
  :ensure nil ;; built into Emacs; not an installable ELPA/MELPA package
  :hook ((text-mode . flyspell-mode)
	 (prog-mode . flyspell-prog-mode))
  :config
  (when my/hunspell-dir
    (setq ispell-program-name (expand-file-name "bin/hunspell.exe" my/hunspell-dir))
    (setenv "DICPATH" (expand-file-name "share/hunspell" my/hunspell-dir)))
  (setq ispell-really-hunspell t)
  (setq ispell-local-dictionary "en_US")
  ;; Both dictionaries declare `SET ISO8859-1' in their .aff files, so
  ;; that -- not utf-8 -- is the encoding ispell.el must use when
  ;; talking to this hunspell build.
  (setq ispell-local-dictionary-alist
	'(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil iso-8859-1)
	  ("en_GB" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_GB") nil iso-8859-1)))
  (setq ispell-hunspell-dictionary-alist ispell-local-dictionary-alist))

(use-package vertico
  :init
  (vertico-mode))

;; vertico-directory.el ships inside the vertico package itself, so no
;; separate install is needed.
(use-package vertico-directory
  :ensure nil
  :after vertico
  :bind (:map vertico-map
	      ("DEL" . vertico-directory-delete-char)
	      ("M-DEL" . vertico-directory-delete-word)
	      ("RET" . vertico-directory-enter))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package consult
  :bind (("C-x b" . consult-buffer)
	 ("M-y" . consult-yank-pop)))

(use-package consult-dir
  :after (consult vertico)
  :bind (("C-x C-d" . consult-dir)
	 :map vertico-map
	 ("C-x C-d" . consult-dir)
	 ("C-x C-j" . consult-dir-jump-file)))

(use-package jemdoc-mode)

 (use-package markdown-mode
   :hook visual-line-mode)

(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
	 ("C->" . mc/mark-next-like-this)
	 ("C-<" . mc/mark-previous-like-this)
	 ("C-=" . mc/mark-all-like-this-dwim)
	 ("C-#" . mc/insert-numbers)
	 ("M-<down-mouse-1>" . mc/add-cursor-on-click))
  :custom
  (mc/insert-numbers-default 1)
  :init
  (global-unset-key (kbd "M-<down-mouse-1>")))

(use-package org
  :mode (("\\.org$" . org-mode))
  :hook ((org-mode . visual-line-mode))
  :custom
  (org-hide-emphasis-markers t)
  :config
  (global-set-key
   (kbd "C-c t e")
   (lambda () (interactive) (toggle-variable 'org-hide-emphasis-markers))))

;; (require 'org-ref)

;; org-journal-dir is machine-specific; set in local.el (see near the
;; top of this file).
(use-package org-journal)

(use-package pdf-tools
  :if (eq system-type 'gnu/linux)
  :config (pdf-tools-install)
  :mode (("\\.pdf\\'" . pdf-view-mode))
  :hook ((pdf-view-mode . pdf-outline-minor-mode)))

(use-package phi-search
  :bind (("C-s" . phi-search)
	 ("C-r" . phi-search-backward)
	 ("M-%" . phi-replace-query)))

(use-package reftex
  :after tex
  :hook (LaTeX-mode . turn-on-reftex)
  :custom
  (reftex-plug-into-AUCTeX t)
  :config
  (with-eval-after-load "latex"
    (TeX-add-style-hook
      "cleveref"
      (lambda ()
	(if (boundp 'reftex-ref-style-alist)
	    (add-to-list
	     'reftex-ref-style-alist
	     '("Cleveref" "cleveref"
	       (("\\cref" ?c) ("\\Cref" ?C) ("\\cpageref" ?d) ("\\Cpageref" ?D)))))
	(reftex-ref-style-activate "Cleveref")
	(TeX-add-symbols
	 '("cref" TeX-arg-ref)
	 '("Cref" TeX-arg-ref)
	 '("cpageref" TeX-arg-ref)
	 '("Cpageref" TeX-arg-ref)))))

  (setq reftex-label-alist
	(append reftex-label-alist
		'(("equation" ?e "eq:" "~\\ref{%s}" t (regexp "equations?" "eqs?\\." "eqn\\."))
		  ("theorem" ?T "thm:" "~\\ref{%s}" t ("theorem" "theorem" "thm"))
		  ("lemma" ?T "lem:" "~\\ref{%s}" t ("lemma lemmas lm"))
		  ("proposition" ?T "prop:" "~\\ref{%s}" t ("proposition prop"))
		  ("definition" ?T "def:" "~\\ref{%s}" t ("definition" "def"))
		  ("claim" ?T "clm:" "~\\ref{%s}" t ("claim"))
		  ("corollary" ?T "cor" "~\\ref{%s}" t ("corollary" "cor")))))

  )

(use-package smart-mode-line
  :config
  (sml/setup)
  (add-to-list 'sml/replacer-regexp-list
	       '("^.*Documents/Uni/PhD/" ":PhD:" t)))

(use-package tex
  :ensure auctex
  :custom
  (TeX-parse-self t) ; Enable parse on load.
  (TeX-auto-save t) ; Enable parse on save.
  (TeX-error-overview-open-after-TeX-run t)
  (TeX-debug-warnings t)
  (TeX-ignore-warnings "todonotes")
  (TeX-suppress-ignored-warnings t)
  (font-latex-match-reference-keywords
      '(("cref" "{")
	("Cref" "{")
	("citet" "{"))) ;; Recognise as a \ref-type commans
  :hook ((LaTeX-mode . visual-line-mode)
	 (LaTeX-mode . display-line-numbers-mode)
	 (LaTeX-mode . LaTeX-math-mode))
  :config
  (when (eq system-type 'windows-nt)
    (setq preview-gs-command "GSWIN64C.EXE"))
  (when (eq system-type 'gnu/linux)
    (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)))

(use-package vim-empty-lines-mode
  :hook (prog-mode text-mode))

(use-package web-mode
  :mode ("\\.html?\\'" "\\.css\\'"))

(use-package yasnippet
  :init
  (setq closing-brackets
	'(("(" . ")")
	  ("[" . "]")
	  ("\\\{" . "\\\}")))
  (defun close-size (opener)
    (cond ((string-match "left" opener) "right")
	  ((string-suffix-p "l" opener)
	   (concat (substring opener nil -1) "r"))
	  (t opener)))
  (defun close-bracket (opener)
    (cond ((assoc opener closing-brackets)
	   (cdr (assoc opener closing-brackets)))
	  ((string-prefix-p "\\l" opener)
	   (concat "\\r" (substring opener 2 nil)))
	  (t ".")))
  :config
  (yas-reload-all)
  :hook ((LaTeX-mode . yas-minor-mode)
	 (julia-mode . yas-minor-mode)
	 (ess-r-mode . yas-minor-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Non-package customisations ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(global-set-key (kbd "C-j") 'delete-backward-char)

;; Fix an issue in which scroll bars keep appearing in new frames
;; that are created when running in emacsclient.
;; https://emacs.stackexchange.com/a/23785/23486
(scroll-bar-mode -1)
(defun my/disable-scroll-bars (frame)
  (modify-frame-parameters frame
                           '((vertical-scroll-bars . nil)
                             (horizontal-scroll-bars . nil))))
(add-hook 'after-make-frame-functions 'my/disable-scroll-bars)

;; Restore normal kill-line behaviour instead of visual-line-mode's
;; kill-visual-line remap.
(define-key visual-line-mode-map [remap kill-line] nil)

;;;;;;;;;;;;;;;;;;;;;;
;; Custom functions ;;
;;;;;;;;;;;;;;;;;;;;;;

(defun toggle-variable (variable)
  "Toggles variable between t and nil"
  (interactive)
  (if (eval variable)
      (set variable nil)
    (set variable t))
  (message "`%s' is now `%s'" variable (eval variable)))

(defun join-next-line ()
  "Joins next line onto current one"
  (interactive)
  (join-line -1))

(global-set-key (kbd "C-^") 'join-next-line)

;; Open previous buffer when splitting windows
(defun vsplit-last-buffer ()
  (interactive)
  (split-window-vertically)
  ;; (other-window 1 nil)
  (switch-to-next-buffer))

(defun hsplit-last-buffer ()
  (interactive)
  (split-window-horizontally)
  ;; (other-window 1 nil)
  (switch-to-next-buffer))
 
(global-set-key (kbd "C-x 2") 'vsplit-last-buffer)
(global-set-key (kbd "C-x 3") 'hsplit-last-buffer)

;; Move lines around
(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key (kbd "M-N") 'move-line-down)
(global-set-key (kbd "M-P") 'move-line-up)
