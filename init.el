(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-for-comint-mode t)
 '(c-basic-offset 4)
 '(c-offsets-alist (quote ((brace-list-open . 0) (substatement-open . 0) (extern-lang-open . 0) (extern-lang-close . 0) (inextern-lang . 0) (innamespace . 0))))
 '(column-number-mode t)
 '(cscope-do-not-update-database t)
 '(custom-buffer-indent 4)
 '(desktop-base-file-name "desktop")
 '(desktop-save (quote ask-if-new))
 '(desktop-save-mode t)
 '(ecb-compilation-buffer-names (quote (("*Calculator*") ("*vc*") ("*vc-diff*") ("*Apropos*") ("*Occur*") ("*shell*") ("\\*[cC]ompilation.*\\*" . t) ("\\*i?grep.*\\*" . t) ("*JDEE Compile Server*") ("*Help*") ("*Completions*") ("*Backtrace*") ("*Compile-log*") ("*bsh*") ("*Messages*") ("\\*Symref.*" . t))))
 '(ecb-compile-window-height 6)
 '(ecb-layout-name "left11")
 '(ecb-layout-window-sizes (quote (("left8" (ecb-directories-buffer-name 0.32905982905982906 . 0.2318840579710145) (ecb-sources-buffer-name 0.32905982905982906 . 0.21739130434782608) (ecb-methods-buffer-name 0.32905982905982906 . 0.3333333333333333) (ecb-history-buffer-name 0.32905982905982906 . 0.2028985507246377)))))
 '(ecb-options-version "2.40")
 '(ecb-tip-of-the-day nil)
 '(ecb-toggle-layout-sequence (quote ("left2" "left11")))
 '(global-auto-revert-mode nil)
 '(grep-highlight-matches t)
 '(indent-tabs-mode nil)
 '(indicate-buffer-boundaries (quote ((top . left) (bottom . right))))
 '(indicate-empty-lines t)
 '(nxml-attribute-indent 4)
 '(nxml-child-indent 4)
 '(nxml-outline-child-indent 4)
 '(save-place t nil (saveplace))
 '(server-mode t)
 '(sgml-basic-offset 4)
 '(show-paren-mode t)
 '(show-trailing-whitespace t)
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(use-dialog-box nil)
 '(x-select-enable-clipboard t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 83 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))

;; MELPA Stuff
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; Create my E/// style
(defconst my-c-style
  '('gnu
    (c-basic-offset . 4)
    ;; (c-tab-always-indent . nil)
    (c-offsets-alist . ((brace-list-open . 0)
                        (substatement-open . 0)
                        (innamespace . 0)))
    (c-backslash-column . 1)
    (c-backslash-max-column . 120)
    (c-auto-align-backslashes . t)
    )
  "E/// C Programming Style")
(c-add-style "E///" my-c-style)

;; xcscope intregration
;; (require 'xcscope)

;; ido integration
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; global integration
;; (autoload 'gtags-mode "gtags" "" t)

;; doxymacs integration
(require 'doxymacs)
(add-hook 'c-mode-common-hook 'doxymacs-mode)
(defun my-doxymacs-font-lock-hook ()
  (if (or (eq major-mode 'c-mode) (eq major-mode 'c++-mode) (eq major-mode 'java-mode))
      (doxymacs-font-lock)))
(add-hook 'font-lock-mode-hook 'my-doxymacs-font-lock-hook)

;; Load local stuff from .emacs.d
;;(add-to-list 'load-path "~/.emacs.d/")

;; Espresso mode integration
(autoload 'espresso-mode "espresso" "Start espresso-mode" t)
(add-to-list 'auto-mode-alist '("\\.js\\'" . espresso-mode))
(add-to-list 'auto-mode-alist '("\\.json\\'" . espresso-mode))

;; Moz-Repl integration
(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)
(add-hook 'espresso-mode-hook 'espresso-custom-setup)
(defun espresso-custom-setup ()
  (moz-minor-mode 1))

;; Put file name or buffer name in frame title
;; (setq frame-title-format '(buffer-file-name "%f" ("%b")))

;; Put full file name in frame title
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
            '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;; use nxml mode for xml, xsd, etc
;; (fset 'xml-mode 'nxml-mode)
;; (defalias 'xml-mode 'nxml-mode)
;;(fset 'html-mode 'nxml-mode)

;; Make .h files always open as C++
;; (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;; Window freezing mods
(defadvice pop-to-buffer (before cancel-other-window first)
  (ad-set-arg 1 nil))

(ad-activate 'pop-to-buffer)

;; Toggle window dedication, bind to pause
(defun toggle-window-dedicated ()
  "Toggle whether the current active window is dedicated or not"
  (interactive)
  (message
   (if (let (window (get-buffer-window (current-buffer)))
         (set-window-dedicated-p window
                                 (not (window-dedicated-p window))))
       "Window '%s' is dedicated"
     "Window '%s' is normal")
   (current-buffer)))
(global-set-key [pause] 'toggle-window-dedicated)

;; Forward yanking, bound to M-Y (iso M-y)
(defun yank-pop-forwards (arg)
      (interactive "p")
      (yank-pop (- arg)))
(global-set-key "\M-Y" 'yank-pop-forwards) ; M-Y (Meta-Shift-Y)

;; Enable CEDET
;;(load-file "~/.emacs.d/cedet-1.0/common/cedet.el")
;;(semantic-load-enable-gaudy-code-helpers)
;;(require 'semantic-ia)

(global-ede-mode 1)
(semantic-mode 1)

(global-semantic-stickyfunc-mode 1)
(global-semantic-idle-completions-mode 1)
(global-semantic-idle-summary-mode 1)
(global-semantic-decoration-mode 1)
(global-semantic-highlight-func-mode 1)
;;(global-semantic-show-unmatched-syntax-mode 1)

;; Needed for ECB
(setq stack-trace-on-error t)

;; Markdown mode (from emacs-goodies-el)
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Key bindings
(global-set-key (kbd "C-x r c") 'clear-rectangle)
(global-set-key (kbd "C-x g") 'magit-status)

;; Enable disabled features
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
