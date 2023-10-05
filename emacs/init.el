;; Add MELPA as a package repository
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)


;; Bootstrap use-package, packages are installed via the package manager 
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-verbose t)
(setq use-package-always-ensure t)
(require 'use-package)
(setq load-prefer-newer t)

;; Open this init file via C-c I
(defun find-config ()
  "Edit init.el"
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "C-c I") 'find-config)

;; customize shall not write changes to init.el, but to a temporary file
(setq custom-file (make-temp-file "emacs-custom"))

;; do not show the help screen on startup
(setq inhibit-startup-screen t)

;; turn off window decorations
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

;; turn of error bell
(setq ring-bell-function 'ignore)

;; make yes-or-no prompts shorter
(defalias 'yes-or-no-p 'y-or-n-p)

;; all backup files go to the same central location
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 20   ; how many of the newest versions to keep
      kept-old-versions 5    ; and how many of the old
      )

;; start in fullscreen
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; do not use tabs
(setq-default indent-tabs-mode nil)

;; always indent correctly
(use-package aggressive-indent)
(setq tab-width 4)
(setq-default tab-width 4)

;; performance tweaks
(defun my-minibuffer-setup-hook ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun my-minibuffer-exit-hook ()
  (setq gc-cons-threshold 800000))
(add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
(add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)

;; use ivy as completion framework for the minibuffer
(use-package ivy
	     :diminish ivy-mode
	     :config
	     (ivy-mode t))

;; use swiper (minibuffer search bar)
(use-package swiper
	     :config
	     (global-set-key "\C-s" 'swiper))


(setq dired-dwim-target t)

;; make dired colorful
(use-package dired-rainbow)

;; some dired enhancing tools
(use-package dired-hacks-utils)

;; use ibuffer to show buffers
  (defalias 'list-buffers 'ibuffer)
  
(setq ibuffer-formats 
      '((mark modified read-only " "
              (name 60 60 :left :elide)
              " "
              (size 9 -1 :right)
              " "
              (mode 16 16 :left :elide)
              " " filename-and-process)
        (mark " "
              (name 16 -1)
              " " filename)))
(use-package ibuffer-projectile)

;; color themes
(use-package material-theme)
(use-package base16-theme
	     :config
	     (load-theme 'base16-default-dark t))

;; highlight current line
(global-hl-line-mode 1)

;; show line numbers
(global-display-line-numbers-mode 1)

;; delete characters when typing while text is selected
(delete-selection-mode 1)

;; leerzeichen-mode shows whitespace characters
(use-package leerzeichen
	     :config
	     (leerzeichen-mode))

;; font settings
(set-face-attribute 'default nil
		    :height 100
		    :family "Jetbrains Mono")
(setq-default line-spacing 5)

;; highlight strings that represent colors in programming modes
(use-package rainbow-mode
	     :config
	     (setq rainbow-x-colors nil)
	     (add-hook 'prog-mode-hook 'rainbow-mode))

;; dynamically expand region selections
(use-package expand-region
  :config
  (global-set-key (kbd "M-q") 'er/expand-region))

;; use projectile as a project managing tool
(use-package projectile
	     :config
	     (projectile-mode)
	     (setq projectile-svn-command "find . -type f -not -iwholename '*.svn/*' -print0")
	     (setq projectile-indexing-method 'alien))
(setq projectile-completion-system 'ivy) ; use ivy for compltions
(setq ivy-initial-inputs-alist nil) ; make sure the minibuffer is empty when invoked...
(setq projectile-enable-caching t) ; enable caching for large files
(setq projectile-enable-cmake-presets t)
(global-set-key (kbd "M-o") 'projectile-find-file)
(global-set-key (kbd "M-O") 'projectile-find-file-in-known-projects)
(global-set-key (kbd "C-c o") 'projectile-find-other-file)
(global-set-key (kbd "C-c p i") 'projectile-configure-project)
(global-set-key (kbd "C-c p c") 'projectile-compile-project)
(global-set-key (kbd "C-c p d") 'projectile-dired)
(global-set-key (kbd "C-c p r") 'projectile-run-project)
(global-set-key (kbd "C-c p t") 'projectile-test-project)

;; use magit as a git-frontend
(use-package magit
	     :bind ("C-x g" . magit-status))
(use-package git-timemachine)
(use-package flycheck
	     :config
	     (add-hook 'after-init-hook 'global-flycheck-mode)
	     (setq-default flycheck-highlighting-mode 'lines)
	     ;; Define fringe indicator / warning levels
	     (define-fringe-bitmap 'flycheck-fringe-bitmap-ball
	       (vector #b00000000
		       #b00000000
		       #b00000000
		       #b00000000
		       #b00000000
		       #b00000000
		       #b00000000
		       #b00011100
		       #b00111110
		       #b00111110
		       #b00111110
		       #b00011100
		       #b00000000
		       #b00000000
		       #b00000000
		       #b00000000
		       #b00000000))
	     (flycheck-define-error-level 'error
					  :severity 2
					  :overlay-category 'flycheck-error-overlay
					  :fringe-bitmap 'flycheck-fringe-bitmap-ball
					  :fringe-face 'flycheck-fringe-error)
	     (flycheck-define-error-level 'warning
					  :severity 1
					  :overlay-category 'flycheck-warning-overlay
					  :fringe-bitmap 'flycheck-fringe-bitmap-ball
					  :fringe-face 'flycheck-fringe-warning)
	     (flycheck-define-error-level 'info
					  :severity 0
					  :overlay-category 'flycheck-info-overlay
					  :fringe-bitmap 'flycheck-fringe-bitmap-ball
					  :fringe-face 'flycheck-fringe-info)

	     (global-set-key (kbd "M-+") 'flycheck-next-error)
	     (global-set-key (kbd "M-\-") 'flycheck-previous-error))

;; use company as a code completion tool
(use-package company
	     :diminish
	     :config
	     (add-hook 'after-init-hook 'global-company-mode)
	     (global-set-key (kbd "C-<tab>") 'company-complete)
	     (setq company-idle-delay 0.5))
(setq company-backends nil)
(add-to-list 'company-backends 'company-dabbrev)
(setq company-dabbrev-downcase nil)

;; yasnippet for code snippeds
(use-package yasnippet
	     :diminish yas-minor-mode
	     :config
	     (add-to-list 'yas-snippet-dirs "~/.emacs.d/yasnippet-snippets")
	     (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets")
	     (add-to-list 'yas-snippet-dirs "~/config/snippets")
	     (yas-global-mode)
	     (global-set-key (kbd "M-/") 'company-yasnippet)
	     
	     ;; Add yasnippet support for all company backends
	     ;; https://github.com/syl20bnr/spacemacs/pull/179
	     (defvar company-mode/enable-yas ;TODO: 
	       "Enable yasnippet for all backends.")
	     
	     (defun company-mode/backend-with-yas (backend)
	       (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
		   backend
		 (append (if (consp backend) backend (list backend))
			 '(:with company-yasnippet))))
	     
	     (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends)))


;; markdown
(use-package markdown-mode
	     :commands (markdown-mode gfm-mode)
	     :mode (("README\\.md\\'" . gfm-mode)
		    ("\\.md\\'" . markdown-mode)
		    ("\\.markdown\\'" . markdown-mode))
	     :init (setq markdown-command "multimarkdown"))

;; open header files in c++-mode
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; use clang-format and auto-format on save for c/c++ files
(use-package clang-format
	     :config
	     (defun my-formatting-setup()
	       (global-set-key (kbd "C-c l") 'clang-format-buffer)
	       (setq-default tab-width 4)
	       (setq tab-width 4)
	       (setq c-basic-offset 4))
	     
	     (add-hook 'c-mode-hook #'my-formatting-setup)
	     (add-hook 'c++-mode-hook #'my-formatting-setup)
	     (add-hook 'c++-mode-hook
		       (lambda () (add-hook 'before-save-hook 'clang-format-buffer nil 'local))))


;; indexing
(use-package lsp-mode
	     :config
	     (setq lsp-clients-clangd-args '("-j=8" "--background-index" "--log=error"))
	     (setq lsp-prefer-flymake nil) ;; Prefer using lsp-ui (flycheck) over flymake.
	     (add-hook 'c++-mode-hook #'lsp)
	     (global-set-key (kbd "M-h") 'lsp-clangd-find-other-file)
	     (global-set-key (kbd "M-.") 'lsp-find-definition)
	     (global-set-key (kbd "M-,") 'lsp-find-declaration)
	     (global-set-key (kbd "C-M-,") 'lsp-find-references))

(use-package lsp-ui
	     :requires lsp-mode flycheck
	     :config
	     (setq lsp-ui-doc-enable nil
		   lsp-ui-sideline-enable t
		   lsp-ui-flycheck-enable t
		   lsp-ui-flycheck-list-position 'right
		   lsp-ui-flycheck-live-reporting t)
         (global-set-key (kbd "C-c s") 'lsp-ivy-workspace-symbol)
	     (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package lsp-ivy
	     :requires lsp-mode
	     :config
	     (global-set-key (kbd "M-#") 'lsp-ivy-workspace-symbol))          

;; jump to first error in compile mode
(setq compilation-scroll-output 'first-error)

;; keybind for my global todo-org-file
(defun find-todo ()
  "Edit todo.org"
  (interactive)
  (find-file "~/org/todo.org"))
(global-set-key (kbd "C-c T") 'find-todo)

;; org mode bullet points
(use-package org-bullets
    :config
    (setq org-bullets-bullet-list '("∙"))
    (add-hook 'org-mode-hook 'org-bullets-mode))

;; tree-sitter aims to provide better syntax highlighting
(use-package tree-sitter
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs)

;; for text-search with ripgrep (ripgrep needs to be in the PATH)
(use-package deadgrep
  :config
  (global-set-key (kbd "<f5>") #'deadgrep))

;; syntax highlighting for cmake files
(use-package cmake-mode)

(use-package dap-mode
  :config
  (require 'dap-lldb)
  (dap-mode 1)
  (dap-tooltip-mode 1)
  (dap-auto-configure-mode 1)
  (dap-ui-controls-mode 1)
  (setq dap-lldb-debug-program '("C:/Users/rothe/home/repos/llvm-project/build/bin/lldb-vscode.exe"))  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(tooltip ((t (:inherit default :background "#282828" :foreground "white")))))
