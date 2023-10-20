(add-to-list 'org-modules 'ol-docview)
(after! org
  ;; evil key bindings
  (evil-define-key 'normal org-mode-map
    (kbd "RET")   'org-open-at-point
    (kbd "zO")    'outline-show-all
    (kbd "zC")    'outline-hide-body
    (kbd "<tab>") 'org-cycle)
  ;; (evil-define-key 'insert org-mode-map
  ;;   (kbd "<tab>") 'org-table-next-field)

  ;; options
  (setq org-directory "~/Dropbox/org/")
  (setq org-download-image-dir "~/Dropbox/org/notes/assets/image/")
  (setq org-attach-id-dir "~/Dropbox/org/notes/assets/attach/")

  (unless (file-exists-p org-directory)
    (make-directory org-directory))

  (setq org-tags-column -120)
  (setq org-log-done 'time)
  (setq org-completion-use-ido t)

  (setq org-emphasis-alist
        (quote
         (("*" org-bold)
          ("/" org-italic)
          ("_" underline)
          ("=" org-verbatim verbatim)
          ("~" org-code verbatim)
          ("+" org-strike))))
  (defface org-bold
    '((t :foreground "salmon"
         :inherit bold))
    "Org-mode emphasis bold."
    :group 'org-faces)
  (defface org-italic
    '((t :foreground "pale green"
         :inherit italic))
    "Org-mode emphasis italic."
    :group 'org-faces)
  (defface org-strike
    '((t :strike-through t))
    "Org-mode emphasis strike-through."
    :group 'org-faces)
  (setq org-hide-emphasis-markers t)
  (setcar (nthcdr 2 org-emphasis-regexp-components) " \t\n")

  (setq org-startup-indented t)
  (setq org-startup-folded nil)
  (setq org-indent-indentation-per-level 1)
  (setq org-support-shift-select t)

  (setq org-startup-with-latex-preview nil)
  (setq org-startup-with-inline-images t)
  (setq org-startup-truncated t)
  (setq org-pretty-entities t)
  (setq org-pretty-entities-include-sub-superscripts nil)
  (setq org-src-fontify-natively t)
  (setq org-file-apps '((auto-mode . emacs)
                        ("\\.x?html?\\'" . default)
                        ("\\.pdf\\'" . "open %s")
                        ))

  (require 'ox-latex)
  (require 'ox-bibtex)
  (unless (boundp 'org-latex-classes)
    (setq org-latex-classes nil))
  (setq org-latex-default-class "org-article")
  (add-to-list 'org-latex-classes
               '("org-article"
                 ;; "\\documentclass{IEEEtran}"
                 "\\documentclass[12pt]{article}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

  ;; for latex export
  (setq org-latex-pdf-process '("xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
                                "bibtex %b"
                                "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"
                                "xelatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
  ;; (setq org-latex-to-pdf-process '("latexmk -pdf %f"))

  ;; minted code block
  (setq org-src-preserve-indentation t)
  (setq org-latex-listings 'minted)
  (setq org-latex-minted-options
        '(("fontsize" "\\small")("obeytabs" "true")))
  (add-to-list 'org-latex-packages-alist '("" "minted" nil))
  (add-to-list 'org-latex-packages-alist '("" "animate" nil))
  (add-to-list 'org-latex-packages-alist '("" "zhfontcfg" nil))
  (add-to-list 'org-latex-packages-alist '("" "unicode-math" nil))
  (add-to-list 'org-latex-packages-alist '("" "mathpazo" t))
  ;; make math equations larger
  (setq org-preview-latex-default-process 'dvisvgm)

  ;; export options
  (setq org-export-with-sub-superscripts '{})
  (setq org-export-with-section-numbers t)
  (setq org-latex-caption-above nil)
  (require 'ox-publish)
  (setq org-export-use-babel nil)
  (setq org-publish-project-alist
        `(("html"
           :base-directory ,(concat org-directory "notes")
           :base-extension "org"
           :publishing-directory "~/Dropbox/Public/html"
           :publishing-function org-html-publish-to-html)
          ("pdf"
           :base-directory ,(concat org-directory "notes")
           :base-extension "org"
           :publishing-directory ,(concat org-directory "pdf")
           :publishing-function org-latex-publish-to-pdf)
          ("all" :components ("html" "pdf"))))

  ;; default css style
  (defun my-org-css-hook (exporter)
    (when (eq exporter 'html)
      (setq org-html-head-include-default-style nil)
      (setq org-html-head (concat "<link href=\"assets/css/navigator.css\" rel=\"stylesheet\" type=\"text/css\">\n"
                                  "<link href=\"assets/css/style.css\" rel=\"stylesheet\" type=\"text/css\">\n"))))
  (add-hook 'org-export-before-processing-hook 'my-org-css-hook)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((dot . t)
     (shell . t)
     (ditaa . t)
     (gnuplot . t)
     (plantuml . t)))
  (add-to-list 'org-src-lang-modes (quote ("dot" . graphviz-dot)))
  (add-to-list 'org-src-lang-modes (quote ("dot2tex" . graphviz-dot)))
  (add-to-list 'org-src-lang-modes (quote ("gnuplot" . gnuplot)))

  ;; GTD stuff
  (setq org-todo-keywords
        '((sequence "TODO(t)" "STARTED(s)" "PROGRESSING(p)" "ALMOST(a)" "|" "DONE(d)" "ABORTED(b)")))
  (setq org-todo-keyword-faces
        '(("TODO" . "#cc9393") ("STARTED" . "khaki") ("PROGRESSING" . "GreenYellow")
          ("ALMOST" . "turquoise") ("DONE" . (:inherit org-done :foreground "#afd8af"))
          ("ABORTED" . (:inherit org-done :foreground "OrangeRed"))))
  (setq org-agenda-files `(,(concat org-directory "GTD/inbox.org")
                           ,(concat org-directory "notes/papers.org")))

  (require 'org-agenda)
  (setq org-agenda-log-mode-items '(closed clock state))
  (add-to-list 'org-agenda-custom-commands
               '("W" "Weekly review"
                 agenda ""
                 ((org-agenda-span 'week)
                  (org-agenda-start-on-weekday 0)
                  (org-agenda-start-with-log-mode 1)
                  (org-agenda-skip-function
                   '(org-agenda-skip-entry-if 'nottodo 'done))
                  )))

  (add-to-list 'org-agenda-custom-commands
               '("H" "Half-monthly review"
                 agenda ""
                 ((org-agenda-span 14)
                  (org-agenda-start-day "-14d")
                  (org-agenda-start-on-weekday nil)
                  (org-agenda-start-with-log-mode 1)
                  (org-agenda-skip-function
                   '(org-agenda-skip-entry-if 'nottodo 'done))
                  )))
  (setq my-inbox-org-file (concat org-directory "/GTD/inbox.org"))
  (setq org-default-notes-file my-inbox-org-file)
  (setq org-capture-templates
        `(("t" "Todo" entry (file+headline my-inbox-org-file "INBOX")
           "* TODO %?\n%U\n%a\n")
          ("n" "Note" entry (file+headline my-inbox-org-file "NOTES")
           "* %? :NOTE:\n%U\n%a\n")
          ("m" "Meeting" entry (file my-inbox-org-file)
           "* MEETING %? :MEETING:\n%U")
          ("j" "Journal" entry (file+datetree ,(concat org-directory "/GTD/journal.org"))
           "* %?\n%U\n")))

  (setq org-use-fast-todo-selection t)
  (setq org-treat-S-cursor-todo-selection-as-state-change nil)
  (setq org-refile-targets '((nil :maxlevel . 9)
                             (org-agenda-files :maxlevel . 9)))

  ;; decorator prettify
  (defface org-decorator-face
    '((((class color) (min-colors 88) (background dark))
       :foreground "#bb79d6"))
    "for org-mode decorators."
    :group 'basic-faces)

  (font-lock-add-keywords
   'org-mode '(("^\s*\\([+-]\\|[0-9][.)]\\)\s"
                .
                'org-decorator-face)
               ("^\s*\\(+\\)\s"
                1
                (compose-region (- (match-end 0) 2)
                                (- (match-end 0) 1)
                                "►"))
               ("^\s*\\(-\\)\s"
                1
                (compose-region (- (match-end 0) 2)
                                (- (match-end 0) 1)
                                "◅")))))

;; --------------- Functions --------------

(defun my-org-uml-from-table (table)
  "UML graph from table"
  (cl-flet ((struct-name (x) (save-match-data
                               (and (string-match "\\(struct\\|class\\) \\([^ ]*\\)" x)
                                    (match-string 2 x)))))
    (let ((all-structs (mapcar 'car table)))
      (mapcar #'(lambda (x)
                  (let ((lhead (car x))
                        (ltail (cdr x)))
                    (princ (concat lhead " [label=\"<head> "
                                   lhead " |"
                                   (mapconcat (lambda (y)
                                                (concat " <" (replace-regexp-in-string
                                                              "\\W" "_" y) "> " y))
                                              (delq "" ltail) " | ") "\", shape=\"record\"];\n"))
                    (mapcar (lambda (y)
                              (let ((sname (struct-name y)))
                                (and (member sname all-structs)
                                     (princ (format "%s:%s -> %s:head\n"
                                                    lhead (replace-regexp-in-string
                                                           "\\W" "_" y) sname)))))
                            ltail))) table))))

(defun my-org-figure-from-screenshot ()
  "screenshot inside org-mode"
  (interactive)
  (let* ((base org-download-image-dir)
         (file (concat base (read-string "Name: ")))
         (path (expand-file-name (concat file ".png")))
         (path2x (expand-file-name (concat file "@2x.png")))
         (res (if (or (not (file-exists-p path)) (y-or-n-p "file already exists, override? "))
                  (progn
                    (if (string-equal system-type "darwin")
                        (do-applescript "tell application \"Emacs\" to set miniaturized of window 1 to true"))
                    (call-process "screencapture" nil nil nil "-s" path2x)
                    (call-process-shell-command "convert" nil nil nil
                                                (concat " -scale 50% -quality 100% " path2x " " path))
                    (if (string-equal system-type "darwin")
                        (do-applescript "tell application \"Emacs\" to set miniaturized of window 1 to false"))
                    0))))
    (if (= res 0)
        (insert
         (org-make-link-string (concat "file:" file ".png"))))))

(appendq! +ligatures-extra-symbols
          `(:checkbox      "☐"
            :pending       "◼"
            :checkedbox    "☑"
            :list_property "∷"
            :results       "➾"
            :property      "☸"
            :properties    "⚙"
            :end           "∎"
            :options       "⌥"
            :title         "𝙏"
            :subtitle      "𝙩"
            :author        "𝘼"
            :date          "𝘿"
            :latex_header  "⇥"
            :latex_class   "🄲"
            :beamer_header "↠"
            :begin_quote   "❮"
            :end_quote     "❯"
            :priority_a   ,(propertize "⚑" 'face 'all-the-icons-red)
            :priority_b   ,(propertize "⬆" 'face 'all-the-icons-orange)
            :priority_c   ,(propertize "■" 'face 'all-the-icons-yellow)
            :priority_d   ,(propertize "⬇" 'face 'all-the-icons-green)
            :priority_e   ,(propertize "❓" 'face 'all-the-icons-blue)
            :em_dash       "—"))
(set-ligatures! 'org-mode
  :merge t
  :checkbox      "[ ]"
  :pending       "[-]"
  :checkedbox    "[X]"
  :list_property "::"
  :results       "#+RESULTS:"
  :property      "#+PROPERTY:"
  :property      ":PROPERTIES:"
  :end           ":END:"
  :options       "#+OPTIONS:"
  :title         "#+TITLE:"
  :subtitle      "#+SUBTITLE:"
  :author        "#+AUTHOR:"
  :date          "#+DATE:"
  :latex_class   "#+LATEX_CLASS:"
  :latex_header  "#+LATEX_HEADER:"
  :beamer_header "#+BEAMER_HEADER:"
  :begin_quote   "#+BEGIN_QUOTE"
  :end_quote     "#+END_QUOTE"
  :begin_export  "#+BEGIN_EXPORT"
  :end_export    "#+END_EXPORT"
  :priority_a    "[#A]"
  :priority_b    "[#B]"
  :priority_c    "[#C]"
  :priority_d    "[#D]"
  :priority_e    "[#E]"
  :em_dash       "---")

;; --------------- Packages --------------

(use-package! org-ref
  :after org
  :config
  (plist-put org-format-latex-options :scale 1.0)
  (map! :map bibtex-mode-map
        :n ",s" #'org-ref-sort-bibtex-entry
        :n ",n" #'org-ref-open-bibtex-notes)
  (setq
   bibtex-completion-bibliography "~/Dropbox/org/notes/papers.bib"
   bibtex-completion-library-path "~/Dropbox/Papers/"
   bibtex-completion-notes-path "~/Dropbox/org/notes/papers.org"
   bibtex-completion-notes-template-multiple-files "** ${title}, ${journal}, (${year}) :${=type=}: \n\nSee [[cite:${=key=}]]\n"
   bibtex-completion-notes-template-one-file "\n** TODO ${year} - ${title} \n  :PROPERTIES:\n   :Custom_ID: ${=key=}\n   :AUTHOR: ${author-or-editor}\n   :JOURNAL: ${journal}\n   :YEAR: ${year}\n  :END:\n\n[[cite:${=key=}]]\n"
   bibtex-completion-pdf-open-function
	(lambda (fpath)
	  (call-process "open" nil 0 nil fpath)))

;; (use-package! smart-input-source
;;   :init
;;   (setq smart-input-source-english "com.apple.keylayout.ABC")
;;   (setq smart-input-source-other "com.apple.inputmethod.SCIM.ITABC")
;;   :config
;;   (smart-input-source-global-inline-mode)
;;   (smart-input-source-global-cursor-color-mode)
;;   (smart-input-source-global-respect-mode)
;;   (smart-input-source-global-follow-context-mode))

(use-package! valign
  :config
  ;; (add-hook 'org-mode-hook #'valign-mode)
  )

(use-package! rainbow-mode)

(use-package! org-bullets
  :config
  (add-hook 'org-mode-hook #'org-bullets-mode))

(after! org-roam
  (setq org-roam-directory "~/Dropbox/org/notes/")
  (setq org-roam-graph-exclude-matcher '("bible/" "beamer/")))

(after! pretty-code
  (setq +pretty-code-enabled-modes '(emacs-lisp-mode org-mode))
  (setq +pretty-code-symbols
        (append +pretty-code-symbols
                '(("[ ]" .  "☐")
                  ("[X]" . "☑" )
                  ("[-]" . "❍" )))))