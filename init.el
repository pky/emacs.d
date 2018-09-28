(setq gc-cons-threshold 134217728)
(setq load-prefer-newer t)
(set-frame-parameter (selected-frame) 'alpha '(90 90))
;;(defvar is-mac (or (eq window-system 'mac) (featurep 'ns)))
(defvar is-mac (or (eq window-system 'ns) (featurep 'ns)))
(set-language-environment  'utf-8)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8-unix)
(cond
 (is-mac
  (require 'ucs-normalize)
  (setq file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs)
  )
 (t
  (setq file-name-coding-system 'utf-8)
  (setq locale-coding-system 'utf-8)
  )
 )

(add-hook 'emacs-startup-hook
          (function (lambda ()
                      (auto-list 'load-path "~/.emacs.d/elpa")
                      (auto-list 'load-path "~/.emacs.d/auto-install")
                      )))


;; old site-lisp
 (setq load-path
       (append
        (list
        (expand-file-name "~/.emacs.d/site-lisp/")
        )
        load-path))

;; set fullpath in title bar
(setq frame-title-format "%f")
;; tab space width 4
(setq-default indent-tabs-mode nil)
(electric-indent-mode -1)
(setq tab-width 2)

(if window-system
(progn
;;  (set-default-font "Andale Mono-10")
;;  (set-fontset-font "fontset-default" 'japanese-jisx0208 '("MigMix 1M" . "unicode-bmp")
 ;; 英語
 (set-face-attribute 'default nil
             :family "Andale Mono"
             :height 100)
;; 日本語
(set-fontset-font
 nil 'japanese-jisx0208
  (font-spec :family "MigMix 1M"))
(setq face-font-rescale-alist
      '((".*MigMix 1M.*" . 1.1)))
;;(set-fontset-font
;; nil 'japanese-jisx0208
;;  (font-spec :family "Hiragino Kaku Gothic ProN"))
;;(setq face-font-rescale-alist
;;      '((".*Hiragino Kaku Gothic ProN.*" . 1.1)))

;; frame size
(set-frame-height (next-frame) 115)
(set-frame-width (next-frame) 138)
))

(add-hook 'kill-emacs-hook 'frame-size-save); Emacs終了時
(add-hook 'window-setup-hook 'frame-size-resume); Emacs起動時
(defun frame-size-save ()
  (set-buffer
   (find-file-noselect (expand-file-name "~/.emacs.d/.framesize")))
  (erase-buffer)
  (insert (concat
           "(set-frame-width (selected-frame) "
           (int-to-string (frame-width))
           ") (set-frame-height (selected-frame) "
           (int-to-string (frame-height))
           ")"))
  (save-buffer)
  (kill-buffer))
(defun frame-size-resume ()
  (let* ((file "~/.emacs.d/.framesize"))
    (if (file-exists-p file)
        (load-file file))))

(setq initial-frame-alist
      '((top . 0) (left . 0) (width . 118) (height . 115)))


;;frame,bufferの保存
;;(desktop-save-mode t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; git egg
;;(require 'egg)

;;close-all-buffers
(defun close-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

;;svn
(setq process-coding-system-alist '(("svn" . utf-8)))
(setq svn-status-svn-process-coding-system 'utf-8)

(setq exec-path (cons "/usr/local/bin" exec-path))
(setenv "PATH"
   (concat '"/usr/local/bin:" (getenv "PATH")))

(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\e[3~" 'delete-char)
(global-set-key "\C-xl" 'indent-region)
(global-set-key "\C-xa" 'recentf-open-files)
(global-set-key "\C-o" 'dabbrev-expand)
(global-set-key (kbd "C-j") 'newline-and-indent)
(setq mac-option-modifier 'meta)

;;(require 'carbon-font)
;; shell zsh
(setq shell-file-name "/usr/local/bin/zsh")

;; Don't show the startup splash screen
(setq inhibit-startup-message t)
(setq blink-matching-paren nil)
(setq blink-matching-delay 0.1)
(setq truncate-lines nil)
(setq truncate-partial-width-windows nil)

;; kill-ring summary
(autoload 'kill-summary "kill-summary" nil t)(global-set-key "\M-y" 'kill-summary)

;; uc dc
(setq read-file-name-completion-ignore-case t)

;;(setq fill-column 80)
(setq-default auto-fill-mode t)
(show-paren-mode 1)
(auto-image-file-mode t)

;; C-x a
(recentf-mode)

(line-number-mode t)
(column-number-mode t)
;(setq delete-auto-save-files nil)
(setq auto-save-default nil)
(setq make-backup-files nil)
;;(require 'auto-save-buffers-enhanced)
;;(setq auto-save-buffers-enhanced-interval 1)
;;(auto-save-buffers-enhanced t)
;;(setq backup-inhibited t)
(menu-bar-mode -1)
(tool-bar-mode 0)
(add-to-list 'load-path "~/.emacs.d/elpa/dash-at-point")
(autoload 'dash-at-point "dash-at-point"
          "Search the word at point with Dash." t nil)
(global-set-key "\C-cd" 'dash-at-point)
(global-set-key "\C-ce" 'dash-at-point-with-docset)

(add-hook 'rinari-minor-mode-hook
          (lambda () (setq dash-at-point-docset "rails")))

(add-hook 'scala-mode-hook
          (lambda () (setq dash-at-point-docset "scala")))

;;tab,whitespaceの可視化
(require 'whitespace)
(setq whitespace-style '(face
                         tabs
                         tab-mark
                         spaces
                         space-mark
                         empty
                         trailing
                         indentaion
                         indentation::space
                         indentation::tab
                         newline
                         newline-mark
                         lines
                         lines-tail
                         ))
;;(setq whitespace-space-regexp "\\(\x3000+\\)")
(setq whitespace-display-mappings
      '((space-mark ?\x3000 [?\□])
        (space-mark   ?\    [?\xB7]     [183])
        (space-mark   ?\xA0 [?\xA4]     [?_])
        (tab-mark   ?\t   [?\xBB ?\t])
        ))
(global-whitespace-mode 1)
;;(setq whitespace-action nil)
(setq whitespace-action '(auto-cleanup))
(set-face-bold-p 'whitespace-space t)
(defvar my/bg-color "#232323")
(set-face-attribute 'whitespace-trailing nil
                    :background my/bg-color
                    :foreground "DeepPink"
                    :underline t)
(set-face-attribute 'whitespace-indentation nil
                    :background my/bg-color
                    :foreground "VioletRed3"
                    :underline nil)
(set-face-attribute 'whitespace-tab nil
                    :background my/bg-color
                    :foreground "LightSkyBlue"
                    :underline t)
(set-face-attribute 'whitespace-space nil
                    :background my/bg-color
                    :foreground "PaleVioletRed1"
                    :weight 'bold)
(set-face-attribute 'whitespace-empty nil
                    :background my/bg-color)
(setq whitespace-style '(face tabs tab-mark spaces space-mark))
(add-hook 'markdown-mode-hook
          '(lambda ()
             (set (make-local-variable 'whitespace-action) nil)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(comment-style (quote extra-line))
 '(custom-enabled-themes (quote (manoj-dark)))
 '(dash-at-point-legacy-mode t)
 '(helm-delete-minibuffer-contents-from-point t)
 '(helm-ls-git-show-abs-or-relative (quote relative))
 '(helm-mini-default-sources
   (quote
    (helm-source-buffers-list helm-source-files-in-current-dir helm-source-ls-git helm-source-recentf)))
 '(helm-truncate-lines t t)
 '(js-doc-author (format "your name <%s>" js-doc-mail-address))
 '(js-doc-license "The MIT License")
 '(js-doc-mail-address "your email address")
 '(js-doc-url "your url")
 '(package-selected-packages
   (quote
    (0xc swift3-mode wgrep-helm 0blayout wgrep-pt yaml-mode wgrep-ag web-mode w3m volatile-highlights twittering-mode tabbar-ruler swift-mode smartrep shorten scss-mode scala-mode2 robe rinari psvn php-mode php-completion packed osx-browse org open-junk-file noctilux-theme markdown-mode mark-multiple magit lui let-alist lcs js3-mode js2-refactor js-doc js-comint imenus ido-vertical-mode ido-occasional helm-swoop helm-projectile helm-migemo helm-ls-svn helm-ls-hg helm-ls-git helm-github-stars helm-git-grep helm-git-files helm-git helm-gist helm-flymake helm-descbinds helm-dash helm-ag haml-mode google-maps git-gutter-fringe+ git-gutter fuzzy full-ack flymake-sass flymake-ruby flymake-php flymake-jslint flymake-jshint flymake-haml flymake-gjshint flymake-cursor flymake-csslint flymake-css flymake-coffee expand-region esqlite epc ensime elscreen-persist descbinds-anything dash-at-point darcula-theme ctags company-web company-inf-ruby company-ansible color-moccur coffee-mode citrus-mode circe autopair auto-save-buffers-enhanced auto-install auto-complete-clang anything-show-completion anything-obsolete anything-match-plugin anything-ipython anything-git-goto anything-git anything-exuberant-ctags anything-extension anything-el-swank-fuzzy anything-config anything-complete ansible android-mode ag ace-jump-mode ace-jump-helm-line ace-isearch ac-math ac-js2 ac-helm)))
 '(standard-indent 2))

;;; apache mode
(autoload 'apache-mode "apache-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.htaccess\\'"   . apache-mode))
(add-to-list 'auto-mode-alist '("httpd\\.conf\\'"  . apache-mode))
(add-to-list 'auto-mode-alist '("srm\\.conf\\'"    . apache-mode))
(add-to-list 'auto-mode-alist '("access\\.conf\\'" . apache-mode))
(add-to-list 'auto-mode-alist '("sites-\\(available\\|enabled\\)/" . apache-mode))

;; Magit
(require 'magit)

;; color-moccur
(when (require 'color-moccur nil t)
  (define-key global-map (kbd "M-o") 'occur-by-moccur)
  (setq moccur-split-word t)
  (add-to-list 'dmoccur-exclusion-mask "\\.DS_Store")
  (add-to-list 'dmoccur-exclusion-mask "\\^#.+#$")
  (when (and (executable-find "cmigemo")
             (require 'migemo nil t))
    (setq moccur-user-migemo t)))

;; moccur-edit
(load "~/.emacs.d/elpa/moccur-edit/moccur-edit")
(require 'moccur-edit nil t)
;; moccur-edit-finisi-edit and save
(defadvice moccur-edit-change-file
  (after save-after-moccur-edit-buffer activate)
  (save-buffer))

;; ack grep find
(defun ack ()
  (interactive)
  (let ((grep-find-command "ack --nocolor --nogroup "))
    (call-interactively 'grep-find)))

(add-hook 'dired-load-hook (lambda () (load "dired-x")))

(require 'ag)
(setq ag-highlight-search t)
(setq ag-reuse-buffers t)
(require 'wgrep)
(require 'wgrep-ag)

(setq wgrep-auto-save-buffer t)
(setq wgrep-enable-key "r")
(setq wgrep-change-readonly-file t)

;; migemo
(require 'migemo)
(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs"))

;; Set your installed path
(setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")

(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(setq migemo-coding-system 'utf-8-unix)
(load-library "migemo")
(migemo-init)

;; perl-completion
(setq plcmp-buffer-dabbrev-expansions-number 0)
(add-hook 'cperl-mode-hook
          (lambda ()
            (require 'perl-completion)
            (perl-completion-mode t)
            (define-key plcmp-mode-map "\C-\M-f" 'plcmp-builtin-function-complete)
            (define-key plcmp-mode-map "\C-\M-v" 'plcmp-builtin-variables-complete)
            (define-key plcmp-mode-map "\C-\M-u" 'plcmp-installed-modules-complete)
            (define-key plcmp-mode-map "\C-\M-s" 'plcmp-search-word-at-point)
            (define-key plcmp-mode-map "\C-\M-c" 'plcmp-clear-all-cache)))

;;; hippie-expand
(global-set-key "\C-o" 'hippie-expand)
(setq hippie-expand-try-functions-list
      '(yas/hippie-try-expand
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs
        try-expand-list try-expand-line
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))

(add-to-list 'default-frame-alist '(font . "fontset-default"))
;;tramp
(add-to-list 'backup-directory-alist
             (cons tramp-file-name-regexp nil))


;; gjshint jshint && gjslint
(require 'flymake-gjshint)
(add-hook 'js2-mode-hook 'flymake-gjshint:load)
(add-hook 'js2-mode-hook
(function (lambda ()
(setq ac-js2-evaluate-calls t))))

;;flaymake-mode js,xml,html,css,scss,java,ruby,perl
(require 'flymake)

(when (load "flymake" t)
 ;;Improved support for remote files over Tramp
  (setq flymake-run-in-place nil)
  ;;Show multiple errors in tooltips
  (setq flymake-number-of-errors-to-display 4)
  ;; JavaScript with Google Closure
  ;; http://www.emacswiki.org/emacs/FlymakeJavaScript
  ;; http://code.google.com/intl/ja/closure/utilities/docs/linter_howto.html
  ;; http://d.hatena.ne.jp/Ehren/20101006/1286386194
  ;; http://d.hatena.ne.jp/Ehren/20110912/1315804158


  ;; flymake coffee
  ;; https://github.com/purcell/flymake-coffee
  (require 'flymake-coffee)
  (add-hook 'coffee-mode-hook 'flymake-coffee-load)

  (defun flymake-gjslint-init ()
    "Initialize flymake for gjslint"
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace)))
      (list "gjslint" (list temp-file "--nosummary --strict --max_line_length=100"))))

  (add-to-list 'flymake-allowed-file-name-masks
               '(".+\\.js$"
                 flymake-gjslint-init
                 flymake-simple-cleanup
                 flymake-get-real-file-name))
  (add-to-list 'flymake-err-line-patterns
               '("^Line \\([[:digit:]]+\\), E:[[:digit:]]+: "
                 nil 1 nil))
  (provide 'gjslint)
  (add-hook 'js2-mode-hook (lambda () (flymake-mode t)))


  ;;; google compiler closure
   (defun flymake-closure-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "~/.emacs.d/bin/closure.sh" (list local-file))))
   (add-to-list 'flymake-allowed-file-name-masks
               '("\\.js|\\.html$\\|\\.tpl\\|\\.erb\\'" flymake-closure-init))
   (add-hook 'js2-mode-hook (lambda () (flymake-mode t)))

  ;;;xml
    (push '(".+\\.xsl$" flymake-xml-init) flymake-allowed-file-name-masks)
    (add-hook 'xsl-mode-hook
              (lambda () (flymake-mode t)))

;;html5
(defun flymake-html-init ()
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))
             (local-file (file-relative-name
                          temp-file
                          (file-name-directory buffer-file-name))))
        (list "~/.emacs.d/bin/html5check.py" (list local-file))))
(add-to-list 'flymake-allowed-file-name-masks
             '("\\.html$\\|\\.tpl|\\.erb" flymake-html-init))
(add-to-list 'flymake-err-line-patterns
             ;; '("\\(Warning:.*?\\|Error:.*?\\)\nFrom line ?\\([0-9]+\\)+,.*?column ?\\([0-9]+\\).*" nil 2 3 1))
             '("\\(Warning:.*?\\|Error:.*?\\)From line ?\\([0-9]+\\)+,.*?column ?\\([0-9]+\\).*?$" nil 2 3 1))
(add-hook 'web-mode-hook '(lambda () (flymake-mode t)))

;; css
    (defun dino-flymake-css-init ()
      "the initialization fn for flymake for CSS"
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
                           'dino-flymake-create-temp-intemp))
             (local-file (file-relative-name
                          temp-file
                          (file-name-directory buffer-file-name))))
        (list (concat (getenv "windir") "\\system32\\cscript.exe")
              (list "c:\\users\\dino\\bin\\csslint-wsh.js" "--format=compiler" local-file))))
    (defvar css-csslint-error-pattern
      ;;"^[ \t]*\\([A-Za-z.0-9_: \\-]+\\)(\\([0-9]+\\)[,]\\( *[0-9]+\\)) CSSLINT: ?\\(error\\|warning\\) ?: +\\(.+\\)$"
      "^[ \t]*\\([\._A-Za-z0-9][^(\n]+\\.css\\)(\\([0-9]+\\)[,]\\([0-9]+\\)) CSSLINT: ?\\(\\(error\\|warning\\) ?: +\\(.+\\)\\)$"
      "The regex pattern for CSSLint error or warning messages. Follows
    the same form as an entry in `flymake-err-line-patterns'. The
    value is a STRING, a regex.")
    (defun dino-css-flymake-install ()
      "install flymake stuff for CSS files."
      (add-to-list
       'flymake-err-line-patterns
       (list css-csslint-error-pattern 1 2 3 4))
      (let* ((key "\\.css\\'")
             (cssentry (assoc key flymake-allowed-file-name-masks)))
        (if cssentry
            (setcdr cssentry '(dino-flymake-css-init))
          (add-to-list
           'flymake-allowed-file-name-masks
           (list key 'dino-flymake-css-init)))))
    (eval-after-load "compile"
      '(progn
         (if (boundp 'compilation-error-regexp-alist-alist)
          (progn
            (add-to-list
             'compilation-error-regexp-alist-alist
             (list 'csslint-wsh css-csslint-error-pattern 1 2 3))
            (add-to-list
             'compilation-error-regexp-alist
             'csslint-wsh)))))
    (eval-after-load "flymake"
      '(progn
         (dino-css-flymake-install)))


;;; SCSS
(defconst scss-validator "sass")

(defun flymake-scss-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list scss-validator (list "--scss" "--check" local-file))))

(push '(".+\\.scss$" flymake-scss-init) flymake-allowed-file-name-masks)

;;'("on line \\([0-9]+\\) of \\([^ ]+\\)$" 2 1 nil 2 nil)

;;;; TODO: Not possible to have multiline regexs in flymake-err-line-patterns?
;; '("Syntax error:\s*\\(.*\\)\n\s*on line\s*\\([0-9]+\\) of \\([^ ]+\\)$" 3 2 nil 1)
(push '("on line \\([0-9]+\\) of \\([^ ]+\\)$" 2 1 nil 2) flymake-err-line-patterns)

(provide 'flymake-scss)

;; java flymake

;; (defun my-java-flymake-init ()
;;   (list "javac" (list (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-with-folder-structure))))
;; (add-to-list 'flymake-allowed-file-name-masks '("\\.java$" my-java-flymake-init flymake-simple-cleanup))
;; (add-hook 'java-mode-hook 'flymake-mode-on)

;;ruby
(defun flymake-ruby-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "ruby" (list "-c" local-file))))

(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)

(push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)

(add-hook 'ruby-mode-hook
          '(lambda ()
             ;; Don't want flymake mode for ruby regions in rhtml files and also on read only files
             (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
                 (flymake-mode))
             ))

;; set-perl5lib
;; http://svn.coderepos.org/share/lang/elisp/set-perl5lib/set-perl5lib.el
(require 'set-perl5lib)

(set-face-background 'flymake-errline "red4")
(set-face-foreground 'flymake-errline "black")
(set-face-background 'flymake-warnline "yellow")
(set-face-foreground 'flymake-warnline "black")

;; http://d.hatena.ne.jp/xcezx/20080314/1205475020
(defun flymake-display-err-minibuf ()
  "Displays the error/warning for the current line in the minibuffer"
  (interactive)
  (let* ((line-no             (flymake-current-line-no))
         (line-err-info-list  (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (count               (length line-err-info-list)))
    (while (> count 0)
      (when line-err-info-list
        (let* ((file       (flymake-ler-file (nth (1- count) line-err-info-list)))
               (full-file  (flymake-ler-full-file (nth (1- count) line-err-info-list)))
               (text (flymake-ler-text (nth (1- count) line-err-info-list)))
               (line       (flymake-ler-line (nth (1- count) line-err-info-list))))
          (message "[%s] %s" line text)))
      (setq count (1- count)))))

;; http://unknownplace.org/memo/2007/12/21#e001
(defvar flymake-perl-err-line-patterns
  '(("\\(.*\\) at \\([^ \n]+\\) line \\([0-9]+\\)[,.\n]" 2 3 nil 1)))

(defconst flymake-allowed-perl-file-name-masks
  '(("\\.pl$" flymake-perl-init)
    ("\\.cgi$" flymake-perl-init)
    ("\\.pm$" flymake-perl-init)
    ("\\.t$" flymake-perl-init)))

(defun flymake-perl-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "perl" (list "-wc" local-file))))

(defun flymake-perl-load ()
  (interactive)
  (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
    (setq flymake-check-was-interrupted t))
  (ad-activate 'flymake-post-syntax-check)
  (setq flymake-allowed-file-name-masks (append flymake-allowed-file-name-masks flymake-allowed-perl-file-name-masks))
  (setq flymake-err-line-patterns flymake-perl-err-line-patterns)
  (set-perl5lib)
  (flymake-mode t))

;;(add-hook 'cperl-mode-hook 'flymake-perl-load)
(add-hook 'perl-mode-hook 'flymake-perl-load)

;;error avoidance
(defadvice flymake-post-syntax-check
    (before flymake-force-check-was-interrupted)
    (setq flymake-check-was-interrupted t))
  (ad-activate 'flymake-post-syntax-check)
  ;; option
  (setq flymake-gui-warnings-enabled nil)
  (load-library "flymake-cursor")

;;(custom-set-faces
;; '(flymake-errline ((((class color)) (:background "#ffffd7"))))
;; '(flymake-warnline ((((class color)) (:background "#0a2832")))))

)
;;; end flymake mode

;;; SCSS-mode
;;; scss-mode.el --- Major mode for editing SCSS files
;;
;; Author: Anton Johansson <anton.johansson@gmail.com> - http://antonj.se
;; URL: https://github.com/antonj/scss-mode
;; Created: Sep 1 23:11:26 2010
;; Version: 0.5.0
;; Keywords: scss css mode
;; Command line utility sass is required, see http://sass-lang.com/
;; To install sass (haml):
;; gem install haml
;;
;; Also make sure sass location is in emacs PATH, example:
;; (setq exec-path (cons (expand-file-name "~/.gem/ruby/1.8/bin") exec-path))
;; (setq exec-path (cons (expand-file-name "~/.rvm/gems/ruby-1.9.3-p194/bin") exec-path))


;; js2-mode
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.\\(js\\|js.erb\\)\\'" . js2-mode))
(add-hook 'js2-mode-hook
          #'(lambda ()
              (require 'js)
              (setq js2-basic-offset 2
                    indent-tabs-mode nil)
              (define-key js2-mode-map (kbd "C-j") 'newline-and-indent)
              (define-key js2-mode-map (kbd "<return>") 'newline-and-indent)
              ))
(require 'js2-refactor)
(require 'inline-string-rectangle)
(global-set-key (kbd "C-x r t") 'inline-string-rectangle)
(require 'mark-more-like-this)
(global-set-key (kbd "C-<") 'mark-previous-like-this)
(global-set-key (kbd "C->") 'mark-next-like-this)
(global-set-key (kbd "C-M-m") 'mark-more-like-this)
(global-set-key (kbd "C-*") 'mark-all-like-this)
(add-hook 'sgml-mode-hook
          (lambda ()
            (require 'rename-sgml-tag)
            (define-key sgml-mode-map (kbd "C-c C-r") 'rename-sgml-tag)))
(add-hook 'js2-mode-hook 'ac-js2-mode)

;;js-doc
(require 'js-doc)

(add-hook 'js2-mode-hook
          '(lambda ()
             (local-set-key "\C-ci" 'js-doc-insert-function-doc)
             (local-set-key "@" 'js-doc-insert-tag)
             ))

;; ruby-electric.el
(require 'ruby-electric)
(add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))
;; ruby-block.el
(require 'ruby-block)
(ruby-block-mode t)
(setq ruby-block-highlight-toggle t)

;;Android mode
(require 'android-mode)
(setq android-mode-sdk-dir "~/android-sdks")

;; C-z new prefix key
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "S-e"))

;; elscreen
;;; プレフィクスキーはC-z
(setq elscreen-prefix-key (kbd "C-z"))
(elscreen-start)
(elscreen-persist-mode 1)
;;; タブの先頭に[X]を表示しない

(setq elscreen-tab-display-kill-screen nil)
;;; header-lineの先頭に[<->]を表示しない
(setq elscreen-tab-display-control nil)
;;; バッファ名・モード名からタブに表示させる内容を決定する(デフォルト設定)
(setq elscreen-buffer-to-nickname-alist
      '(("^dired-mode$" .
         (lambda ()
           (format "Dired(%s)" dired-directory)))
        ("^Info-mode$" .
         (lambda ()
           (format "Info(%s)" (file-name-nondirectory Info-current-file))))
        ("^mew-draft-mode$" .
         (lambda ()
           (format "Mew(%s)" (buffer-name (current-buffer)))))
        ("^mew-" . "Mew")
        ("^irchat-" . "IRChat")
        ("^liece-" . "Liece")
        ("^lookup-" . "Lookup")))
(setq elscreen-mode-to-nickname-alist
      '(("[Ss]hell" . "shell")
        ("compilation" . "compile")
        ("-telnet" . "telnet")
        ("dict" . "OnlineDict")
        ("*WL:Message*" . "Wanderlust")))

;; buffer iserch C-r
(require 'minibuf-isearch)

;; ctags
(require 'ctags nil t)
(setq tags-revert-without-query t)
;;(setq ctags-command "/usr/local/bin/ctags -e -R ")
(setq ctags-command "/usr/bin/ctags -R --fields=\"+afikKlmnsSzt\" ")
(global-set-key (kbd "<f5>") 'ctags-create-or-update-tags-table)

;; auto-install
(load "~/.emacs.d/auto-install")
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/auto-install/")
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)

(setq ac-js2-evaluate-calls t)

(autoload 'riece "riece" "Start Riece" t)

;; yaml
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode)
(setq tab-width 2))

;; autopair
(require 'autopair)
(autopair-global-mode)

;; scala
(autoload 'scala-mode2 "scala-mode" nil t)
(autoload 'sbt-mode "sbt-mode" nil t)

;;volatile-highlights
(require 'volatile-highlights)
(volatile-highlights-mode t)

;; ;; helm
;; (require 'helm-config)
;; (helm-mode 1)
;; (require 'helm-ag)
;; ;;(require 'helm-descbinds)
;; ;;(require 'helm-migemo)
;; (require 'helm-swoop)
;; (require 'helm-dash)
;; (require 'helm-ls-git)
;; (require 'helm-ls-svn)
;; (require 'helm-flymake)
;; (projectile-global-mode)
;; (setq projectile-completion-system 'helm)
;; (helm-projectile-on)
;; (autoload 'dash-at-point "dash-at-point"
;;           "Search the word at point with Dash." t nil)
;; ;;(helm-descbinds-mode)
;; (with-eval-after-load "helm-regexp.el"
;;   (setq helm-source-occur (helm-make-source "Occur" 'helm-source-multi-occur))
;;   (setq helm-source-occur (helm-make-source "Moccur" 'helm-source-multi-occur)))

;; ;;
;; ;; helm-migemo, helm-swoop連携
;; ;;
;; ;;; この修正が必要
;; (eval-after-load "helm-migemo"
;;   '(defun helm-compile-source--candidates-in-buffer (source)
;;      (helm-aif (assoc 'candidates-in-buffer source)
;;          (append source
;;                  `((candidates
;;                     . ,(or (cdr it)
;;                            (lambda ()
;;                              ;; Do not use `source' because other plugins
;;                              ;; (such as helm-migemo) may change it
;;                              (helm-candidates-in-buffer (helm-get-current-source)))))
;;                    (volatile) (match identity)))
;;        source)))
;; ;;; isearchからの連携を考えるとC-r/C-sにも割り当て推奨
;; (define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
;; (define-key helm-swoop-map (kbd "C-s") 'helm-next-line)

;; ;;; 検索結果をcycleしない、お好みで
;; (setq helm-swoop-move-to-line-cycle nil)

;; (cl-defun helm-swoop-nomigemo (&key $query ($multiline current-prefix-arg))
;;   "シンボル検索用Migemo無効版helm-swoop"
;;   (interactive)
;;   (let ((helm-swoop-pre-input-function
;;          (lambda () (format "\\_<%s\\_> " (thing-at-point 'symbol)))))
;;     (helm-swoop :$source (delete '(migemo) (copy-sequence (helm-c-source-swoop)))
;;                 :$query $query :$multiline $multiline)))
;; ;;; C-M-:に割り当て
;; (global-set-key (kbd "C-M-:") 'helm-swoop-nomigemo)

;; ;;; [2014-11-25 Tue]
;; (when (featurep 'helm-anything)
;;   (defadvice helm-resume (around helm-swoop-resume activate)
;;     "helm-anything-resumeで復元できないのでその場合に限定して無効化"
;;     ad-do-it))

;; ;;; ace-isearch
;; (global-ace-isearch-mode 1)

;; ;;; [2015-03-23 Mon]C-u C-s / C-u C-u C-s
;; (defun isearch-forward-or-helm-swoop (use-helm-swoop)
;;   (interactive "p")
;;   (let (current-prefix-arg
;;         (helm-swoop-pre-input-function 'ignore))
;;     (call-interactively
;;      (case use-helm-swoop
;;        (1 'isearch-forward)
;;        (4 'helm-swoop)
;;        (16 'helm-swoop-nomigemo)))))
;; (global-set-key (kbd "C-s") 'isearch-forward-or-helm-swoop)

;; (require 'ido-occasional)
;; (require 'ido-vertical-mode)
;; (require 'imenus)
;; (setq ido-enable-flex-matching t)
;; (ido-vertical-mode 1)
;; (setq ido-vertical-define-keys 'C-n-and-C-p-only)

;; ;;; エラー対策
;; (defun imenu-find-default--or-current-symbol (&rest them)
;;   (condition-case nil
;;       (apply them)
;;     (error (thing-at-point 'symbol))))
;; (advice-add 'imenu-find-default :around 'imenu-find-default--or-current-symbol)
;; ;;; なぜか現在のシンボルを取ってくれないから
;; (defun imenus-exit-minibuffer ()
;;   (exit-minibuffer))

;; ;;; ido化: imenus/with-ido imenus-mode-buffers/with-idoを定義
;; (with-ido-completion imenus)
;; ;; C-M-s C-M-sで現在のシンボルをhelm-multi-swoopできるよ！
;; (global-set-key (kbd "C-M-s") (with-ido-completion imenus-mode-buffers))

;; ;;; M-oでのmulti-occurをシンボル正規表現にするよう改良
;; (push '(occur . imenus-ido-multi-occur) imenus-actions)
;; (defun imenus-ido-multi-occur (buffers input)
;;   (multi-occur buffers
;;                (format "\\_<%s\\_>"
;;                        (regexp-quote (replace-regexp-in-string "^.*|" "" input)))))

;; ;;; C-M-sで関数呼び出しをhelm-multi-swoopできるようにした
;; (push '(helm-multi-swoop . imenus-helm-multi-swoop) imenus-actions)
;; (defun imenus-helm-multi-swoop (buffers input)
;;   (helm-multi-swoop (replace-regexp-in-string "^.*|" "" input)
;;                     (mapcar 'buffer-name buffers)))
;; (define-key imenus-minibuffer-map (kbd "C-M-s") 'imenus-exit-to-helm-multi-swoop)
;; (defun imenus-exit-to-helm-multi-swoop ()
;;   "Exit from imenu prompt; start `helm-multi-swoop' with the current input."
;;   (interactive)
;;   (setq imenus-exit-status 'helm-multi-swoop)
;;   (imenus-exit-minibuffer))


;; (global-set-key (kbd "C-;") 'helm-mini)
;; ;;(global-set-key (kbd "C-c b") 'helm-descbinds)
;; ;;(global-set-key (kbd "C-c o") 'helm-occur)
;; (global-set-key (kbd "C-c g") 'helm-ag)
;; (define-key global-map (kbd "M-y") 'helm-show-kill-ring)
;; (global-set-key (kbd "C-c y") 'helm-show-kill-ring)
;; (global-set-key (kbd "C-c s") 'helm-git-files)
;; (global-set-key (kbd "C-c p") 'helm-swoop)
;; (global-set-key (kbd "C-c f") 'helm-flymake)
;; (global-set-key (kbd "C-c d") 'dash-at-point)
;; (global-set-key (kbd "C-c C-d") 'helm-browse-project)

;; (define-key helm-map (kbd "C-h") 'delete-backward-char)
;; (define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)
;; (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
;; (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)



;; ;; helm-ag
;; ;;; 現在のシンボルをデフォルトのクエリにする
;; (setq helm-ag-insert-at-point 'symbol)

;; ;;; C-M-gはちょうどあいてる
;; ;;(global-set-key (kbd "C-M-g") 'helm-ag)
;; (global-set-key (kbd "C-M-g") 'helm-projectile-ag)
;; (global-set-key (kbd "C-M-k") 'backward-kill-sexp) ;推奨

;; (require 'expand-region)
;; (require 'multiple-cursors)
;; (require 'smartrep)

;; (global-set-key (kbd "C-,") 'er/expand-region)
;; (global-set-key (kbd "C-M-,") 'er/contract-region)

;; (global-set-key (kbd "<C-M-return>") 'mc/edit-lines)
;; (smartrep-define-key
;;  global-map "C-." '(("C-n" . 'mc/mark-next-like-this)
;;                     ("C-p" . 'mc/mark-previous-like-this)
;;                     ("*"   . 'mc/mark-all-like-this)))

(global-git-gutter+-mode)
(require 'git-gutter-fringe+)
(git-gutter-fr+-minimal)

(global-set-key (kbd "C-x g") 'git-gutter+-mode) ; Turn on/off in the current buffer
(global-set-key (kbd "C-x G") 'global-git-gutter+-mode) ; Turn on/off globally

(eval-after-load 'git-gutter+
  '(progn
     ;;; Jump between hunks
     (define-key git-gutter+-mode-map (kbd "C-x n") 'git-gutter+-next-hunk)
     (define-key git-gutter+-mode-map (kbd "C-x p") 'git-gutter+-previous-hunk)

     ;;; Act on hunks
     (define-key git-gutter+-mode-map (kbd "C-x v =") 'git-gutter+-show-hunk)
     (define-key git-gutter+-mode-map (kbd "C-x r") 'git-gutter+-revert-hunks)
     ;; Stage hunk at point.
     ;; If region is active, stage all hunk lines within the region.
     (define-key git-gutter+-mode-map (kbd "C-x t") 'git-gutter+-stage-hunks)
     (define-key git-gutter+-mode-map (kbd "C-x c") 'git-gutter+-commit)
     (define-key git-gutter+-mode-map (kbd "C-x C") 'git-gutter+-stage-and-commit)
     (define-key git-gutter+-mode-map (kbd "C-x C-y") 'git-gutter+-stage-and-commit-whole-buffer)
     (define-key git-gutter+-mode-map (kbd "C-x U") 'git-gutter+-unstage-whole-buffer)))

;;(require 'git-gutter)
;;(global-git-gutter-mode t)

;;markdown mode
(add-to-list 'auto-mode-alist'("\\.md\\'" . markdown-mode))

;;php-mode
(require 'php-mode)
(setq php-mode-force-pear t) ;PEAR規約のインデント設定にする
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode)) ;
;; php-mode-hook
(add-hook 'php-mode-hook
          (lambda ()
            (require 'php-completion)
            (php-completion-mode t)
            (setq tab-width 2)
            (setq indent-tabs-mode nil)
            (setq c-basic-offset 2)
            (define-key php-mode-map (kbd "C-o") 'phpcmp-complete) ;php-completionの補完実行キーバインドの設定
            (make-local-variable 'ac-sources)
            (setq ac-sources '(
                               ac-source-words-in-same-mode-buffers
                               ac-source-php-completion
                               ac-source-filename
                               ))))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

(defun web-mode-hook ()
  ;;(electric-indent-local-mode -1)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-attr-indent-offset 2)
  (setq web-mode-indent-style 2)
  (setq web-mode-style-padding 2)
  (setq web-mode-script-padding 2)
  (setq web-mode-block-padding 2)
  (add-hook 'web-mode-hook 'web-mode-hook))
;;(add-to-list 'web-mode-indentation-params '("lineup-args" . nil))
;;(add-to-list 'web-mode-indentation-params '("lineup-calls" . nil))
;;(add-to-list 'web-mode-indentation-params '("lineup-concats" . nil))
;;(add-to-list 'web-mode-indentation-params '("lineup-ternary" . nil))
;;swift
(require 'swift-mode)

;; open-junk-file
(require 'open-junk-file)
(setq open-junk-file-format "~/Documents/junk/%Y-%m%d-%H%M%S.")
(global-set-key "\C-xj" 'open-junk-file)

;; org
(require 'org)
(require 'ob-C)
(require 'ob-ruby)

(setq org-directory "~/Documents/junk")
(setq org-agenda-files (list org-directory))

(setq org-src-fontify-natively t)

(defun my-org-confirm-babel-evaluate (lang body)
  (not (or (string= lang "ditaa")
           (string= lang "emacs-lisp")
           (string= lang "ruby")
           (string= lang "C")
           (string= lang "cpp")
           )))

(setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)



;; markdown mode
;;(require 'w3m)
(require 'markdown-mode)

;; (defun w3m-browse-url-other-window (url &optional newwin)
;;   (let ((w3m-pop-up-windows t))
;;     (if (one-window-p) (split-window))
;;     (other-window 1)
;;     (w3m-browse-url url newwin)))

;; (defun markdown-render-w3m (n)
;;   (interactive "p")
;;   (message (buffer-file-name))
;;   (call-process "/usr/local/bin/grip" nil nil nil
;;                 "--gfm" "--export"
;;                 (buffer-file-name)
;;                 "/tmp/grip.html")
;;   (w3m-browse-url-other-window "file://tmp/grip.html")
;;   )
;; (define-key markdown-mode-map "\C-c \C-c" 'markdown-render-w3m)

;; rember the milk
;;(require 'simple-rtm)
;;(autoload 'simple-rtm-mode "simple-rtm" "Interactive mode for Remember The Milk" t)
;;(eval-bafter-load 'simple-rtm
;;  '(progn
;;     (display-simple-rtm-tasks-mode t)))

;; customize-theme

;;flycheck
;; (add-hook 'after-init-hook #'global-flycheck-mode)
;; (flycheck-add-next-checker 'javascript-jshint
;;                         'javascript-gjslint)

;;(define-key input-decode-map "\e[1;2A" [S-up])

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-annotation-face ((t (:inherit font-lock-constant-face))))
 '(egg-header ((t (:weight normal :height 1.6))))
 '(egg-help-header-1 ((t (:inherit egg-text-base :height 1.2))))
 '(egg-help-header-2 ((((class color) (background dark)) (:inherit egg-text-1 :foreground "LightSteelBlue"))))
 '(erc-keyword-face ((t (:foreground "pale green" :weight normal))) t)
 '(erc-notice-face ((t (:foreground "SlateBlue" :weight normal))) t)
 '(font-lock-comment-delimiter-face ((t (:inherit font-lock-comment-face :foreground "dark gray"))))
 '(font-lock-comment-face ((t (:foreground "dark gray" :slant oblique))))
 '(font-lock-constant-face ((t (:foreground "plum2" :weight normal))))
 '(font-lock-doc-face ((t (:inherit font-lock-string-face :foreground "dark gray" :slant oblique))))
 '(font-lock-function-name-face ((t (:foreground "khaki2" :weight normal :height 1.0))))
 '(font-lock-keyword-face ((t (:foreground "medium turquoise"))))
 '(font-lock-string-face ((t (:foreground "SpringGreen4"))))
 '(font-lock-variable-name-face ((t (:foreground "LightSalmon1"))))
 '(magit-blame-heading ((t (:background "RoyalBlue4" :foreground "gray90"))))
 '(magit-diff-hunk-heading-highlight ((t (:background "gray80" :foreground "OrangeRed4"))))
 '(mumamo-background-chunk-major ((((class color) (min-colors 8)) (:background "*"))) t)
 '(mumamo-background-chunk-submode ((((class color) (min-colors 8)) (:background "*"))) t))

(put 'erase-buffer 'disabled nil)
;;(load-theme 'noctilux t)
;;(load-theme 'darcula t)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
