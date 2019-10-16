;;; js-auto-format-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "js-auto-format-mode" "js-auto-format-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from js-auto-format-mode.el

(autoload 'js-auto-format-enabled-p "js-auto-format-mode" "\
Test whether js-auto-format-mode is enabled.

\(fn)" nil nil)

(autoload 'js-auto-format-execute "js-auto-format-mode" "\
Format JavaScript source code.

\(fn)" t nil)

(autoload 'js-auto-format-mode "js-auto-format-mode" "\
Minor mode for auto-formatting JavaScript code

If called interactively, enable Js-Auto-Format mode if ARG is positive, and
disable it if ARG is zero or negative.  If called from Lisp,
also enable the mode if ARG is omitted or nil, and toggle it
if ARG is `toggle'; disable the mode otherwise.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "js-auto-format-mode" '("js-auto-format-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; js-auto-format-mode-autoloads.el ends here
