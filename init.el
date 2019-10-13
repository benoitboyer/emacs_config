;; init.el --- Emacs configuration

;; INSTALL PACKAGES
;; --------------------------------------
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)


(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

;;Custom function to select the packages I want to use
(defvar myPackages
  '(;;elpy
    ;;company-quickhelp
    projectile))

;;Function that will automaticaly install those package from the repo if they are not instaled yet
(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)


;; This is only needed once, near the top of the file
(eval-when-compile
  (require 'use-package))


(use-package lsp-python-ms
  :ensure t
  :demand
  :hook (python-mode . lsp))  ; or lsp-deferred



(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if (executable-find "python3") 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-follow-delay             0.2
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-desc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-width                         35)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null (executable-find "python3"))))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))


(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)

(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))



;;Init elpy
;(elpy-enable)
;;set jedi as the default rpc backend
;(setq elpy-rpc-backend "jedi")
;(require 'company-quickhelp)

;;having popup helper add the right of jedi autocomplete
;(company-quickhelp-mode 1)

;;yasnippet
(require 'yasnippet)
(yas-global-mode 1)

;;change the default <tab> to C-<tab>
;;(define-key yas-minor-mode-map (kbd "<tab>") nil)
;;(define-key yas-minor-mode-map (kbd "TAB") nil)
;;(define-key yas-minor-mode-map (kbd "<C-tab>") 'yas-expand)

;;linum-mode slow problem
(when (>= emacs-major-version 26)
  (global-display-line-numbers-mode 1)
  (global-linum-mode 0))
;;emmet
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode)
(add-hook 'web-mode-hook  'emmet-mode) 

;;projectile
(require 'projectile)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-mode +1)

;;xah-fly-keys
(require 'xah-fly-keys)
(xah-fly-keys-set-layout "qwerty") ; required

;; possible layout values:

;; "azerty"
;; "azerty-be"
;; "colemak"
;; "colemak-mod-dh"
;; "dvorak"
;; "programer-dvorak"
;; "qwerty"
;; "qwerty-abnt"
;; "qwertz"
;; "workman"
(xah-fly-keys 1)


(use-package flycheck
  :ensure t
  :config
  (add-hook 'typescript-mode-hook 'flycheck-mode))

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1)
  (global-set-key (kbd "C-?") 'tide-documentation-at-point)
  )

(use-package company
  :ensure t
  :config
  (setq company-show-numbers t)
  (setq company-tooltip-align-annotations t)
  ;; invert the navigation direction if the the completion popup-isearch-match
  ;; is displayed on top (happens near the bottom of windows)
  (setq company-tooltip-flip-when-above t)
  (global-company-mode))

(use-package company-quickhelp
  :ensure t
  :init
  (company-quickhelp-mode 1)
  (use-package pos-tip
    :ensure t))



(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.js\\'" . web-mode)
	 ("\\.css\\'" . web-mode)
	 ("\\.vue\\'" . web-mode)
	 ("\\.tsx\\'" . web-mode)
         ("\\.jsx\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-block-padding 2
        web-mode-comment-style 2

        web-mode-enable-css-colorization t
        web-mode-enable-auto-pairing t
        web-mode-enable-comment-keywords t
        web-mode-enable-current-element-highlight t
        )
(setq web-mode-engines-alist
      '(("django"    . "\\.html\\'")))

  (add-hook 'web-mode-hook
            (lambda ()
              (when (string-equal "tsx" (file-name-extension buffer-file-name))
		(setup-tide-mode))))
  ;; enable typescript-tslint checker
  (flycheck-add-mode 'typescript-tslint 'web-mode))

(use-package typescript-mode
  :ensure t
  :config
  (setq typescript-indent-level 2)
  (add-hook 'typescript-mode #'subword-mode))

(use-package tide
  :init
  :ensure t
  :after (typescript-mode company flycheck)
  :hook ((typescript-mode . tide-setup)
         (typescript-mode . tide-hl-identifier-mode)
         (before-save . tide-format-before-save)))

;;TYPE SCRIPT CONFIG
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
    (setq exec-path (append exec-path '("/usr/local/bin")))




;;(require 'js2-refactor)
;;(require 'xref-js2)

;;(add-hook 'js2-mode-hook #'js2-refactor-mode)
;;(js2r-add-keybindings-with-prefix "C-c C-r")
;;(define-key js2-mode-map (kbd "C-k") #'js2r-kill)

;; js-mode (which js2 is based on) binds "M-." which conflicts with xref, so
;; unbind it.
;;(define-key js-mode-map (kbd "M-.") nil)

;;(add-hook 'js2-mode-hook (lambda ()
;;  (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))

;(modify-syntax-entry ?` "\"" js-mode-syntax-table)
;; BASIC CUSTOMIZATION
;; --------------------------------------

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

;;Theme that looks like sublime text
(load-theme 'monokai t)

;; Allow for direct editing of selection when insert
(delete-selection-mode +1)

;; remove the useless toolbar on top

(tool-bar-mode -1)

(setq inhibit-startup-message t) ;; hide the startup message

;;change the behavior of python tabs and indent
(add-hook 'python-mode-hook 'blacken-mode
      (lambda ()
        (setq indent-tabs-mode nil)
        (setq tab-width 4)
        (setq python-indent-offset 4)))

;;Resolve the mac hash tag problem, disable the right opt key
;;being able to use # or € symbol on mac keyboard easily
;;disabling the right option key
(setq ns-right-alternate-modifier (quote none))


;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "5f27195e3f4b85ac50c1e2fac080f0dd6535440891c54fcfa62cdcefedf56b1b" "d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347" "0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f" default)))
 '(magit-diff-use-overlays nil)
 '(package-selected-packages
   (quote
    (realgud solarized-theme company tide company-web ac-html-bootstrap ac-html ac-emmet xref-js2 js2-refactor js2-mode treemacs-projectile treemacs-icons-dired treemacs blacken lsp-python-ms python-mode lsp-ui company-lsp flycheck lsp-mode use-package web-mode py-autopep8 emmet-mode monokai-theme elpy))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
