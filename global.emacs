(display-time)
(setq text-mode-hook 'turn-on-auto-fill)
(setq make-backup-files nil)

(global-font-lock-mode t)
(transient-mark-mode t)

;; Configure paths
(add-to-list 'load-path "~/.emacs.d")
(autoload 'matlab-mode "matlab" "Enter Matlab mode." t)
(setq ispell-program-name "/usr/bin/ispell")

;; Load jinja2-mode
(require 'jinja2-mode)

;; Configure google style for c-mode
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)

;; Keybindings
(define-key global-map (kbd "C-2") 'set-tab-width-two)
(define-key global-map (kbd "C-4") 'set-tab-width-four)
(define-key global-map (kbd "C-8") 'set-tab-width-eight)
(define-key global-map (kbd "C-x g") 'goto-line)
(define-key global-map (kbd "M-`") 'next-error)
(define-key global-map (kbd "C-`") 'compile)
(define-key global-map (kbd "C-\\") 'indent-region)
(define-key global-map (kbd "C-S-s") 'replace-string)
(define-key global-map (kbd "C-S-M-s") 'query-replace)
(define-key global-map [(f10)] 'reload-dot-emacs)
(define-key global-map [(shift f10)] 'open-dot-emacs)
(global-set-key [(shift f4)] 'wrap-all-lines) 
(define-key global-map (kbd "C-r") 'shell-script-mode)
(define-key global-map (kbd "C-.") 'increase-left-margin)
(define-key global-map (kbd "C-,") 'decrease-left-margin)

;; File associations
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.h\\'" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cc\\'" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.tpp\\'" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cu\\'" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.proto\\'" . c-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.bashrc\\'" . shell-script-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.bash_aliases\\'" . shell-script-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.go\\'" . go-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.html\\'" . jinja2-mode) auto-mode-alist))

(setq standard-indent 4)

;; Dabbrev
(setq case-fold-search t)

;; Compilation mode hooks
(setq
 compilation-mode-hook
 (function
  (lambda ()
    ;;(and jidanni-truncate-lines
		(setq truncate-lines nil)
		(setq truncate-partial-width-windows nil)
    (define-key compilation-mode-map "q" 'quit-window)
    (define-key compilation-mode-map ":" 'compilation-send-line:tt)
    )))

(add-hook 'compilation-mode-hook 'ansi-color-for-comint-mode-on)

(defun wrap-all-lines ()
  "Enable line wrapping"
  (interactive) ;this makes the function a command too
  (set-default 'truncate-lines nil))

;; Reload .emacs
(defun reload-dot-emacs ()
  "Reload ~/.emacs"
  (interactive)
  (load-file (expand-file-name "~/.emacs"))
  )

;; Open the .emacs file
(defun open-dot-emacs ()
  "Open ~/.emacs"
  (interactive) ;this makes the function a command too
  (find-file "~/.emacs")
  )

;; Set tab width to 2
(defun set-tab-width-two ()
  "Set tab width to 2"
  (interactive)
  (setq standard-indent 2)
  (setq c-basic-offset 2)
  (setq tab-width 2)
  (font-lock-fontify-buffer)
  )

;; Set tab width to 4
(defun set-tab-width-four ()
  "Set tab width to 4"
  (interactive)
  (setq standard-indent 4)
  (setq c-basic-offset 4)
  (setq tab-width 4)
  (font-lock-fontify-buffer)
  )

;; Set tab width to 8
(defun set-tab-width-eight ()
  "Set tab width to 8"
  (interactive)
  (setq standard-indent 8)
  (setq c-basic-offset 8)
  (setq tab-width 8)
  (font-lock-fontify-buffer)
  )

;; Turn off word wrap
(defun no-wrap ()
  "Turn of word-wrap"
  (interactive)
  (auto-fill-mode -1)
  )

;; go mode
(setq load-path (cons "/usr/local/Cellar/go/1.1.2/misc/emacs" load-path))
(require 'go-mode-load)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(load-home-init-file t t)
 '(tab-width 2))

;; turn off wrapping in html mode
(defun my-hook ()
  (auto-fill-mode -1))
(add-hook 'html-mode-hook 'my-hook)
(add-hook 'jinja2-mode-hook 'my-hook)
