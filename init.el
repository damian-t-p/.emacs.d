; Location: C:\Users\damia\AppData\Roaming\.emacs.d
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; Blocks added by customize interface
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; install use-package if missing
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; This is only needed once, near the top of the file
(eval-when-compile
  (require 'use-package))

;; Load everything immediately if launching from a daemon
(if (daemonp)
    (setq use-package-always-demand t))

(use-package ace-jump-mode
  :bind ("C-c SPC" . ace-jump-mode))

(use-package adaptive-wrap
  :hook (visual-line-mode . adaptive-wrap-prefix-mode))

(use-package bookmark+
  :load-path "lisp/bookmark+-master/")

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

(use-package dired+
  :load-path "lisp"
  :custom
  (dired-dwim-target t))

(use-package flyspell
  :hook ((text-mode . flyspell-mode)
	 (prog-mode . flyspell-prog-mode))
  :config
  (if (eq system-type 'windows-nt)
       (setq ispell-program-name "D:\\Program Files\\Aspell\\bin\\aspell.exe")))

(use-package helm
  :bind (("M-x" . helm-M-x)
	 ("M-y" . helm-show-kill-ring)
	 ("C-x b" . helm-mini)
	 ("C-x C-f" . helm-find-files))
  :custom
  (helm-split-window-in-side-p t)
  :config
  (helm-mode 1))

(use-package jemdoc-mode)

;; (use-package markdown-mode
;;   :hook visual-line-mode)
(add-hook 'markdown-mode-hook #'visual-line-mode)

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

(require 'org-ref)

(use-package paredit
  :hook ((emacs-lisp-mode . paredit-mode)
	 (lisp-mode . paredit-mode)
	 (list-interaction-mode . paredit-mode)))

(use-package pdf-tools
  :if (eq system-type 'gnu/linux)
  :config (pdf-tools-install)
  :mode (("\\.pdf\\'" . pdf-view-mode))
  :hook ((pdf-view-mode . pdf-outline-minor-mode)))

(use-package phi-search
  :bind (("C-s" . phi-search)
	 ("C-r" . phi-search-backward)))

(use-package projectile
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1))

(use-package reftex
  :after tex
  :hook (LaTeX-mode . turn-on-reftex)
  :custom
  (reftex-plug-into-AUCTeX t)
  :config
  (eval-after-load
      "latex"
    '(TeX-add-style-hook
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

  (setq reftex-default-bibliography '("D:/Users/Damian/Local tex files/bibtex/bib/mendeley/library.bib")))

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
  (font-latex-match-reference-keywords
      '(("cref" "{")
	("Cref" "{")
	("citet" "{"))) ;; Recognise as a \ref-type commans
  :hook ((LaTeX-mode . visual-line-mode)
	 (LaTeX-mode . linum-mode)
	 (LaTeX-mode . LaTeX-math-mode))
  :config
  (if (eq system-type 'windows-nt)
      (setq preview-gs-command "GSWIN64C.EXE"))
  (if (eq system-type 'gnu/linux)
      (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)))

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

(toggle-scroll-bar -1)

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

;; Open previous buffer when splitting windows
(defun vsplit-last-buffer ()
  (interactive)
  (split-window-vertically)
  (other-window 1 nil)
  (switch-to-next-buffer)
  )
(defun hsplit-last-buffer ()
  (interactive)
  (split-window-horizontally)
  (other-window 1 nil)
  (switch-to-next-buffer)
  )
 
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
