;;; darkroom.el --- 

;; Copyright (C) 2010  yama

;; Author: yama 
;; Keywords: 

;; 	$Id: darkroom.el,v 1.14 2011/01/26 06:31:06 yama Exp $ 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; use color-theme

;;; Usage

;;; (require 'darkroom)
;;; M-x darkroom

;;; Code:
(require 'color-theme)


;;; Config ---------------------------------------------------------
(defvar darkroom-left-margin  15
  "left margin")

(defvar darkroom-right-margin 15
  "right margin")

(defvar dark-mode-on nil
  "Non-nil if DarkRoom mode is enabled.
Don't change this variable directly, you must change it by one of the
functions that enable or disable Dark Room mode.")

;;; -------------------------------------------------------------------


(defun fullscreen ()
  (interactive)
  (shell-command "wmctrl -r :ACTIVE: -b toggle,fullscreen"))

;; (defun fullscreen (&optional f)
;; ;;(defun fullscreen ()
;;   "Chenge FullScreen. for Emacs23"
;;   (interactive)
;;   (set-frame-parameter f 'fullscreen
;; 					   (if (frame-parameter f 'fullscreen) nil 'fullboth)))
  ;; (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
  ;;                        ;; if first parameter is '2', can toggle fullscreen status
  ;;                        '(2 "_NET_WM_STATE_FULLSCREEN" 0)))


(defun darkroom-mode ()
  "simple writing environment."
  (interactive)
  (if (equal dark-mode-on t) (darkroom-mode-disable)
	(darkroom-mode-enable)))

(defun darkroom-mode-enable ()
  (setq dark-mode-on t)
  (setq darkroom-default-background-color
		(cdr (assoc 'background-color default-frame-alist)))
  (fset 'color-theme-snapshot (color-theme-make-snapshot))
  (sleep-for 0.05)
  (color-theme-simple-1)
  (fullscreen )
  (set-cursor-color "yellow") ;; cursor color
  (tool-bar-mode 0)
  (menu-bar-mode 0)
  (display-time-mode 1)
  (scroll-bar-mode)
  (set-face-foreground 'mode-line "gray25")
  (set-face-background 'mode-line "gray1")
  (if (equal (intern-soft "elscreen-version") nil) nil
	(elscreen-toggle-display-tab)))

(defun darkroom-mode-disable ()
  (setq dark-mode-on nil)
  (add-to-list 'default-frame-alist
  			   '(background-color . darkroom-default-background-color))
  (color-theme-snapshot)
  (scroll-bar-mode)
    (if (equal (intern-soft "elscreen-version") nil) nil
	(elscreen-toggle-display-tab))
  (display-time-mode 0)
  (menu-bar-mode 1)
  (sleep-for 0.05)
  (fullscreen ))
	
(defun window-count ()
  (length (window-list (selected-frame) 1)))

(defun set-margin ()
  (set-window-margins (selected-window)
					  darkroom-left-margin
					  darkroom-right-margin))

(defun dark-window-update ()
  (if (equal dark-mode-on t)
	  (if (> (window-count) 1)
		  (progn
			(set-window-margins (selected-window) 0 0)
			(set-window-margins (previous-window) 0 0))
		(set-margin))
  (set-window-margins (selected-window) 0 0)))

(add-hook 'window-configuration-change-hook 'dark-window-update)


(provide 'darkroom)
;;; darkroom.el ends here
