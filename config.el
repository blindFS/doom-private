(load! "orgme")

(set-frame-parameter (selected-frame) 'alpha '(95 . 90))
(add-to-list 'default-frame-alist '(alpha . (95 . 90)))

(setq doom-font (font-spec :family 'Iosevka' :size 15))
(setq doom-font (font-spec :family "NovaMono Nerd Font" :size 14 :weight 'normal)
     doom-variable-pitch-font (font-spec :family "NovaMono Nerd Font" :size 14)
     doom-theme 'doom-dracula)
(setq doom-themes-neotree-file-icons t)

(setq configuration-layer--elpa-archives
      '(("melpa-cn" . "http://elpa.emacs-china.org/melpa/")
        ("org-cn"   . "http://elpa.emacs-china.org/org/")
        ("gnu-cn"   . "http://elpa.emacs-china.org/gnu/")))
