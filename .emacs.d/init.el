(add-to-list
 'default-frame-alist
 '(font . "-apple-Menlo-medium-normal-normal-*-14-*-*-*-m-0-iso10646-1"))

(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

(add-to-load-path "elisp" "conf" "public_repos")

(when (require 'color-theme nil t)
  (color-theme-initialize)
  (color-theme-dark-laptop))

(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/elisp/")
  (auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup))

(when (require 'package nil t)
  (add-to-list 'package-archives
               '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives
               '("ELPA" . "http://tromey.com/elpa"))
  (add-to-list 'package-archives
               '("melpa" . "http://melpa.milkbox.net/packages/"))
  (package-initialize))

(global-unset-key (kbd "C-z"))

(setq windmove-wrap-around t)
(windmove-default-keybindings)

(column-number-mode t)
(size-indication-mode t)
(setq display-time-24hr-format t)
(display-time-mode t)
(display-battery-mode t)

(setq frame-title-format "%f")

(global-linum-mode t)

(setq-default indent-tabs-mode nil)

(setq show-paren-delay 0)
(show-paren-mode 1)

(require 'anything-startup)
(descbinds-anything-install)
(define-key global-map (kbd "M-y") 'anything-show-kill-ring)

(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
               "~/.emacs.d/elisp/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

(when (require 'redo+ nil t)
  (global-set-key (kbd "C-'") 'redo))

(defalias 'perl-mode 'cperl-mode)
(defun perl-completion-hook ()
  (when (require 'perl-completion nil t)
    (perl-completion-mode t)
    (when (require 'auto-complete nil t)
      (auto-complete-mode t)
      (make-variable-buffer-local 'ac-sources)
      (setq ac-sources
            '(ac-source-perl-completion)))))
(add-hook 'cperl-mode-hook 'perl-completion-hook)
(add-hook 'cperl-mode-hook '(lambda ()
                              (cperl-set-style "PerlStyle")))
(add-hook 'cperl-mode-hook '(lambda () (flymake-mode t)))

(when (require 'yaml-mode nil t)
  (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode)))
  
(require 'haskell-mode)
(require 'haskell-cabal)

(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.lhs$" . literate-haskell-mode))
(add-to-list 'auto-mode-alist '("\\.cabal\\'" . haskell-cabal-mode))

(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(require 'ghc)

(defun haskell-setup ()
  (setq ghc-module-command "~/Library/Haskell/bin/ghc-mod")
  (ghc-init)
  (flymake-mode))
(add-hook 'haskell-mode-hook 'haskell-setup)

(when (executable-find "git")
  (require 'egg nil t))
