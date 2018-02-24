;;; guido-mode.el --- Mode for editing Guido Music Notation files

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; Author:   Berend de Boer <berend@pobox.com>
;; Keywords: Guido
;; URL:      http://www.pobox.com/~berend/emacs/guido-mode.el

;;; Commentary:
;;
;; Add this to your .emacs file to load and bind it to files with extension
;; .gmn:
;;(add-to-list 'auto-mode-alist '("\\.gmn\\'" . guido-mode))
;;(autoload 'guido-mode "guido-mode")

;;; Code:

(defgroup guido nil
  "Major mode for editing Guido source in Emacs"
  :group 'languages)

;;
(defvar guido-load-hook nil
  "*Hook run when the guido-mode is loaded.")

;;
(defvar guido-font-lock-keywords
  (let ((guido-description-functions (eval-when-compile
             (concat "\\\\"
                     (regexp-opt '(
"composer" "instr" "label" "mark" "t" "text" "title") t) "\\b")))
        (guido-known-functions (eval-when-compile
             (concat "\\\\"
                     (regexp-opt '(
"accel" "accelBegin" "accelEnd" "accent" "bar" "beam" "beamsAuto" "beamsOff"
"bm" "clef" "cresc" "crescBegin" "crescEnd" "cue" "dim" "dimBegin" "dimEnd"
"doubleBar" "fermata" "grace" "i"
"intens" "key" "marcato" "meter" "mord" "noteFormat" "oct"
"repeatBegin" "repeatEnd" "rit"
"ritBegin" "ritEnd" "sl" "slur" "stac" "staff" "stemsAuto" "stemsDown"
"stemsUp" "tactus" "tempo" "ten" "tie" "tieBegin" "tieEnd" "trem"
"trill" "turn") t) "\\b"))))
    (setq guido-font-lock-keywords
	  (list
     (cons "%.*$" 'font-lock-comment-face)
     (cons "\"\\([^\"]*\\|\"\"\\)*\\(\"\\|$\\)" 'font-lock-string-face)
     ;; description functions
     (cons guido-description-functions 'font-lock-constant-face)
     ;; known functions
     (cons guido-known-functions 'font-lock-function-name-face)
     ;; all other functions
     (cons "\\\\[a-zA-Z]+" 'font-lock-warning-face)
     ;; duration indications
;;      (cons "\/[1-9]" 'font-lock-type-face)
     )))
  "Info for function `font-lock-mode'."
)

;; Create mode-specific tables.
(defvar guido-mode-syntax-table nil
  "Syntax table used while in Guido mode.")

;;;###autoload
(defun guido-mode ()
  "Major mode for editing Guido Music Notation files."
  (interactive)
  ;;
  (kill-all-local-variables)
  (setq mode-name "Guido")
  (setq major-mode 'guido-mode)
  ;;
  (setq comment-start "%")
  (setq comment-start-skip "%+ *")
  ;;
  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '(guido-font-lock-keywords))
  (make-local-variable 'font-lock-keywords-case-fold-search)
  (setq font-lock-keywords-case-fold-search nil)
  (make-local-variable 'font-lock-beginning-of-syntax-function)
  (setq font-lock-beginning-of-syntax-function 'beginning-of-line)
  ;; why do I have this??
  (make-local-variable 'font-lock-keywords-only)
  (setq font-lock-keywords-only t)
  ;; Make <> a parenthesis
  (if guido-mode-syntax-table
      ()              ; Do not change the table if it is already set up.
    (setq guido-mode-syntax-table (make-syntax-table 'syntax-table)))
  (set-syntax-table guido-mode-syntax-table)
  (modify-syntax-entry ?< "(" guido-mode-syntax-table)
  (modify-syntax-entry ?> ")" guido-mode-syntax-table)
  ;;
  (run-hooks 'guido-mode-hook)
  )

(provide 'guido-mode)
(run-hooks 'guido-load-hook)

;;; guido-mode.el ends here
