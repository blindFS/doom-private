(load! "orgme")

(add-to-list 'default-frame-alist '(alpha . (95 . 90)))
;; (add-to-list 'default-frame-alist '(undecorated . t))
;; (add-to-list 'initial-frame-alist '(fullscreen . maximized))
(tool-bar-mode t)
(tool-bar-mode 0)

(setq doom-font (font-spec :family "Sarasa Term SC Nerd" :size 15))
(setq doom-theme 'doom-Iosvkem)
(setq doom-themes-neotree-file-icons t)

(setq configuration-layer--elpa-archives
      '(("melpa-cn" . "http://elpa.emacs-china.org/melpa/")
        ("org-cn"   . "http://elpa.emacs-china.org/org/")
        ("gnu-cn"   . "http://elpa.emacs-china.org/gnu/")))
(load! "pix2tex")
(setq pix2tex-screenshot-method "screencapture -i %s")
