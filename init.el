;; -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 1. Offline Packages & Directory Load Path Mappings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)

;; Disable network checks entirely to block macOS sandbox connection errors
(setq package-enable-at-startup nil)
(setq package-check-signature nil)

;; Point your Emacs configuration load path directly to the folders on disk
(dolist (pkg '("use-package" "clojure-mode" "cider" "rainbow-delimiters" "paredit" "ivy" "swiper" "org-roam"))
  (add-to-list 'load-path (expand-file-name (concat "~/.emacs.d/elpa/" pkg))))

(require 'use-package)
(setq use-package-always-ensure nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 2. Visual Theme Configuration (Zero-Dependency Custom Sourcerer Layout)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun apply-custom-sourcerer-theme ()
  "Apply a high-fidelity inline reproduction of the doom-sourcerer palette."
  (interactive)
  (let ((bg "#151517")
        (fg "#c2c2c4")
        (comment "#6b6b6e")
        (keyword "#aa759f")
        (string "#718c00")
        (builtin "#4f8287")
        (variable "#dc9656")
        (function "#7cafc2")
        (type "#fab28e")s)
    
    (set-face-attribute 'default nil :background bg :foreground fg)
    (set-face-attribute 'cursor nil :background fg)
    
    (set-face-attribute 'font-lock-comment-face nil :foreground comment :background 'unspecified :slant 'italic)
    (set-face-attribute 'font-lock-keyword-face nil :foreground keyword :weight 'bold)
    (set-face-attribute 'font-lock-string-face nil :foreground string)
    (set-face-attribute 'font-lock-builtin-face nil :foreground builtin)
    (set-face-attribute 'font-lock-variable-name-face nil :foreground variable)
    (set-face-attribute 'font-lock-function-name-face nil :foreground function :weight 'bold)
    (set-face-attribute 'font-lock-type-face nil :foreground type)
    (set-face-attribute 'font-lock-constant-face nil :foreground variable :weight 'bold)))

(apply-custom-sourcerer-theme)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 3. Core System Startup Preferences
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq inhibit-startup-message t)
(setq inhibit-splash-screen t)
(setq default-directory "~/org/")

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 5)
(menu-bar-mode t)
(blink-cursor-mode 0)
(global-hl-line-mode 1)
(transient-mark-mode 1)

(setq visible-bell t)
(global-display-line-numbers-mode t)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(setq mac-command-modifier 'control)
(set-face-attribute 'default nil :height 200)
(global-set-key (kbd "C-x C-b") #'ibuffer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 4. Dropbox Cloud Synchronization Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq org-directory "~/org")
(setq org-mobile-files-alist nil)
(setq org-mobile-directory "/Users/joseph.savoie/Library/CloudStorage/Dropbox/Apps/MobileOrg")
(setq org-mobile-inbox-for-pull "/Users/joseph.savoie/Library/CloudStorage/Dropbox/Apps/MobileOrg/inbox.org")
(setq org-mobile-files '("~/org"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 5. Calendar & Localization Settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq calendar-latitude 41.3)
(setq calendar-longitude -95.9)
(setq calendar-location-name "Omaha, NE")
(setq org-agenda-include-diary t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 6. Org-Mode Setup & Capture Templates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'org)

(setq org-agenda-custom-commands
      '(("w" "Waiting Tasks" ((todo "WAIT" ((org-agenda-overriding-header "Tasks Waiting")))))))

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "IN PROGRESS(i)" "|" "DONE(d)")
	(sequence "PLAN(p)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

(setq org-default-notes-file (concat org-directory "/notes.org"))

(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c c") #'org-capture)

(setq org-capture-templates
       '(("t" "Table Entry" table-line (file+headline "~/org/cycling/fit-utils.org" "Weight & Energy Tracker") "| %U | %^{Lbs} | 35 | %^{Fat%} | 243 | | | |":table-line-pos "II+1" :immediate-finish t)
	 ("l" "Todo" entry (file+headline "~/org/inbox.org" "Story Board") "* TODO %U -  %?" :prepend t)
	 ("w" "Weekly Cycling Plan" entry (file+headline "~/org/cycling/cycling.org" "Weekly Plans") "* Week of %^t\n:PROPERTIES:\n:GOAL: 3.0 W/kg\n:END:\n\n** Monday\n- Lift (heavy)\n- Optional 30–45 min Z2\n\n** Tuesday\n- Threshold session\n\n** Wednesday\n- Z2 aerobic\n\n** Thursday\n- Punch / VO2 session\n\n** Friday\n- Light lift\n\n** Saturday\n- Race or simulation\n\n** Sunday\n- 3 hr aerobic\n\nNotes:\n- Weight:\n- Fatigue:\n- Adjustments:\n")
        ("d" "Daily Workout Log" entry (file+headline "~/org/cycling/cycling.org" "Workout Log") "* %U - %^{Workout Type}\n:PROPERTIES:\n:TSS: %^{TSS}\n:WEIGHT: %^{Weight}\n:END:\n\n** Plan\n%?\n\n** Actual\n\n** Notes\n- RPE:\n- Recovery:\n- Nutrition:\n")
        ("p" "Phase Planning Block" entry (file+headline "~/org/cycling/cycling.org" "Season Plan") "* %^{Phase Name}\n:PROPERTIES:\n:START: %^t\n:END: %^t\n:END:\n\n** Objectives\n- \n\n** Focus Workouts\n- \n\n** Weight Target\n- \n\n** Notes\n%?\n")
        ("c" "Weight Check-in" entry (file+headline "~/org/cycling/cycling.org" "Weight Tracking") "* %U\n- Weight: %^{Weight} lb\n- Weekly Trend:\n- Notes:\n")))

(org-babel-do-load-languages 'org-babel-load-languages '((python . t) (R . t) (shell . t)))
(setq org-babel-python-command "python3")
(setq org-agenda-start-with-log-mode t)
(setq org-log-done t)
(setq org-log-into-drawer t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 7. Org-Roam Knowledge Graph Management
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/org-roam")
  (org-roam-completion-everywhere t)
  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert)
	 :map org-mode-map
	 ("C-M-i" . completion-at-point))
  :config
  (org-roam-setup))

(setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag) ""))
(setq org-roam-dailies-directory "daily/")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 8. Clojure IDE Ecosystem Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package clojure-mode
  :config
  (add-hook 'clojure-mode-hook (lambda () (when (fboundp 'rainbow-delimiters-mode) (rainbow-delimiters-mode))))
  (add-hook 'clojure-mode-hook (lambda () (when (fboundp 'paredit-mode) (paredit-mode)))))

(use-package cider :defer t :config (setq cider-repl-display-help nil))
(use-package paredit :defer t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; 9. Core Search Layout Preference Engines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package which-key :config (which-key-mode))
(use-package rainbow-delimiters :hook (prog-mode . rainbow-delimiters-mode))
(use-package swiper)
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(cider clojure-mode ivy magit org-roam paredit rainbow-delimiters
	   swiper which-key)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
