(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-electric-left-right-brace nil)
 '(LaTeX-section-hook
   '(LaTeX-section-heading LaTeX-section-title LaTeX-section-section))
 '(LaTeX-verbatim-environments '("verbatim" "verbatim*" "lstlisting"))
 '(TeX-command-list
   '(("TeX"
      "%(PDF)%(tex) %(file-line-error) %(extraopts) %`%S%(PDFout)%(mode)%' %t"
      TeX-run-TeX nil (plain-texo-mode texinfo-mode ams-tex-mode)
      :help "Run plain TeX")
     ("LaTeX" "%`%l%(mode)%' %t" TeX-run-TeX nil
      (latex-mode doctex-mode) :help "Run LaTeX")
     ("Makeinfo" "makeinfo %(extraopts) %t" TeX-run-compile nil
      (texinfo-mode) :help "Run Makeinfo with Info output")
     ("Makeinfo HTML" "makeinfo %(extraopts) --html %t"
      TeX-run-compile nil (texinfo-mode) :help
      "Run Makeinfo with HTML output")
     ("AmSTeX" "amstex %(PDFout) %(extraopts) %`%S%(mode)%' %t"
      TeX-run-TeX nil (ams-tex-mode) :help "Run AMSTeX")
     ("ConTeXt"
      "%(cntxcom) --once --texutil %(extraopts) %(execopts)%t"
      TeX-run-TeX nil (context-mode) :help "Run ConTeXt once")
     ("ConTeXt Full" "%(cntxcom) %(extraopts) %(execopts)%t"
      TeX-run-TeX nil (context-mode) :help
      "Run ConTeXt until completion")
     ("BibTeX" "bibtex %s" TeX-run-BibTeX nil t :help "Run BibTeX")
     ("Biber" "biber %s" TeX-run-Biber nil t :help "Run Biber")
     ("View" "%V" TeX-run-discard-or-function t t :help "Run Viewer")
     ("Print" "%p" TeX-run-command t t :help "Print the file")
     ("Queue" "%q" TeX-run-background nil t :help
      "View the printer queue" :visible TeX-queue-command)
     ("File" "%(o?)dvips %d -o %f " TeX-run-dvips t t :help
      "Generate PostScript file")
     ("Dvips" "%(o?)dvips %d -o %f " TeX-run-dvips nil t :help
      "Convert DVI file to PostScript")
     ("Dvipdfmx" "dvipdfmx %d" TeX-run-dvipdfmx nil t :help
      "Convert DVI file to PDF with dvipdfmx")
     ("Ps2pdf" "ps2pdf %f" TeX-run-ps2pdf nil t :help
      "Convert PostScript file to PDF")
     ("Glossaries" "makeglossaries %s" TeX-run-command nil t :help
      "Run makeglossaries to create glossary file")
     ("Index" "makeindex %s" TeX-run-index nil t :help
      "Run makeindex to create index file")
     ("upMendex" "upmendex %s" TeX-run-index t t :help
      "Run upmendex to create index file")
     ("Xindy" "texindy %s" TeX-run-command nil t :help
      "Run xindy to create index file")
     ("Check" "lacheck %s" TeX-run-compile nil (latex-mode) :help
      "Check LaTeX file for correctness")
     ("ChkTeX" "chktex -v6 %s" TeX-run-compile nil (latex-mode) :help
      "Check LaTeX file for common mistakes")
     ("Spell" "(TeX-ispell-document \"\")" TeX-run-function nil t
      :help "Spell-check the document")
     ("Clean" "TeX-clean" TeX-run-function nil t :help
      "Delete generated intermediate files")
     ("Clean All" "(TeX-clean t)" TeX-run-function nil t :help
      "Delete generated intermediate and output files")
     ("Other" "" TeX-run-command t t :help "Run an arbitrary command")))
 '(TeX-electric-math '("\\(" . "\\)"))
 '(TeX-insert-braces nil)
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff"
    "#eeeeec"])
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(cursor-type 'box)
 '(custom-enabled-themes '(darktooth))
 '(custom-safe-themes
   '("25e3f1fc8e66c25cb5340487825035c4a1cea2f990df5d081b005fb6798c3893"
     "45631691477ddee3df12013e718689dafa607771e7fd37ebc6c6eb9529a8ede5"
     "d824f0976625bb3bb38d3f6dd10b017bdb4612f27102545a188deef0d88b0cd9"
     "d2e0c53dbc47b35815315fae5f352afd2c56fa8e69752090990563200daae434"
     "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e"
     "88049c35e4a6cedd4437ff6b093230b687d8a1fb65408ef17bfcf9b7338734f6"
     "274fa62b00d732d093fc3f120aca1b31a6bb484492f31081c1814a858e25c72e"
     default))
 '(flyspell-tex-command-regexp
   "\\(\\(begin\\|end\\)[ \11]*{\\|\\(cite[a-z*]*\\|label\\|[cC]?ref\\|eqref\\|usepackage\\|documentclass\\)[ \11]*\\(\\[[^]]*\\]\\)?{[^{}]*\\)")
 '(font-latex-math-environments
   '("display" "displaymath" "equation" "eqnarray" "gather" "math"
     "multline" "align" "alignat" "xalignat" "xxalignat" "flalign"
     "gather"))
 '(inhibit-startup-screen t)
 '(ispell-dictionary "en_US")
 '(line-move-visual t)
 '(org-format-latex-options
   '(:foreground default :background default :scale 1.5 :html-foreground
		 "Black" :html-background "Transparent" :html-scale
		 1.0 :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")))
 '(package-selected-packages
   '(adaptive-wrap auctex avy buffer-move consult consult-dir csv-mode
		   darktooth-theme jemdoc-mode magit marginalia
		   multiple-cursors orderless org-journal pdf-tools
		   phi-search poly-R poly-markdown polymode
		   smart-mode-line vertico vim-empty-lines-mode
		   web-mode yasnippet))
 '(preview-image-type 'pnm)
 '(preview-inner-environments
   '("Bmatrix" "Vmatrix" "aligned" "array" "bmatrix" "cases" "gathered"
     "matrix" "pmatrix" "smallmatrix" "split" "subarray" "vmatrix"
     "piecewise"))
 '(reftex-ref-style-default-list '("Default" "Cleveref"))
 '(standard-indent 4)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
