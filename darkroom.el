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
;;; or
;;; (global-set-key [f11] 'darkroom-mode)

;;; Code:
(require 'color-theme)


;;; Config ---------------------------------------------------------
(defvar darkroom-left-margin  15
  "left margin")

(defvar darkroom-right-margin 15
  "right margin")

(defvar dark-mode-p nil
  "Non-nil if DarkRoom mode is enabled.
Don't change this variable directly, you must change it by one of the
functions that enable or disable Dark Room mode.")

;;; -------------------------------------------------------------------


(defun fullscreen ()
  "toggle FullScreen."
  (cond ((eq (window-system) 'x)
		 (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
								;; if first parameter is '2', can toggle fullscreen status
								'(2 "_NET_WM_STATE_FULLSCREEN" 0)))
		((eq (window-system) 'w32) ;; Windows.
		 ;; Not TEST. non real fullscreen.
		 (if dark-mode-p
			 (w32-send-sys-command 61488) ;; WM_SYSCOMMAND maximaze #xf030
		   (w32-send-sys-command 61728))) ;; WM_SYSCOMMAND restore #xf120
		((eq (window-system) 'ns) ;; Mac OSX.
		 (message "OSX")))
  (redisplay))

(defun darkroom-mode ()
  "simple writing environment."
  (interactive)
  (if (equal dark-mode-p t) (darkroom-mode-disable)
	(darkroom-mode-enable)))

(defun darkroom-mode-enable ()
  (setq dark-mode-p t)
  (setq darkroom-default-background-color
		(cdr (assoc 'background-color default-frame-alist)))
  (setq final-frame-params 
		(cons (frame-width) (frame-height)))
  (fset 'color-theme-snapshot (color-theme-make-snapshot))
  (sleep-for 0.05)
  (color-theme-simple-1)
  (set-cursor-color "yellow") ;; cursor color
  (tool-bar-mode 0)
  (menu-bar-mode 0)
  (display-time-mode 1)
  (set-scroll-bar-mode nil)
  (set-face-foreground 'mode-line "gray25")
  (set-face-background 'mode-line "gray1")
  (set-face-foreground 'mode-line-buffer-id "gray25")
  (set-face-background 'mode-line-buffer-id "gray1")
  (if (equal (intern-soft "elscreen-version") nil) nil
	(elscreen-toggle-display-tab))
  (fullscreen ))

(defun darkroom-mode-disable ()
  (setq dark-mode-p nil)
  (add-to-list 'default-frame-alist
  			   '(background-color . darkroom-default-background-color))
  (color-theme-reset-faces)
  (color-theme-snapshot)
  (scroll-bar-mode)
    (if (equal (intern-soft "elscreen-version") nil) nil
	(elscreen-toggle-display-tab))
  (display-time-mode 0)
  (menu-bar-mode 1)
  (sleep-for 0.05)
  (set-cursor-color "yellow")
  (fullscreen)
  (set-frame-height (selected-frame) (cdr final-frame-params)))
	
(defun window-count ()
  (length (window-list (selected-frame) 1)))

(defun set-margin ()
  (set-window-margins (selected-window)
					  darkroom-left-margin
					  darkroom-right-margin))

(defun dark-window-update ()
  (if (equal dark-mode-p t)
	  (if (> (window-count) 1)
		  (progn
			(set-window-margins (selected-window) 0 0)
			(set-window-margins (previous-window) 0 0))
		(set-margin))
  (set-window-margins (selected-window) 0 0)))

(add-hook 'window-configuration-change-hook 'dark-window-update)


(provide 'darkroom)
;;; darkroom.el ends here
