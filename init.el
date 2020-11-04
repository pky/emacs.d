
;;; Code:
(require 'package)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/") t)
;;(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
;;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(unless package--initialized (package-initialize))


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
 ;; 英語
 (set-face-attribute 'default nil
             :family "Andale Mono"
             :height 110)
;; 日本語
(set-fontset-font
 nil 'japanese-jisx0208
  (font-spec :family "MigMix 1M"))
(setq face-font-rescale-alist
      '((".*MigMix 1M.*" . 1.2)))

;; frame size
;;(set-frame-height (next-frame) 115)
;;(set-frame-width (next-frame) 138)
))

(setq default-frame-alist
      (append '((width                . 140)  ; フレーム幅
                (height               . 80 ) ; フレーム高
                (left                 . 0 ) ; 配置左位置
                (top                  . 0 ) ; 配置上位置
                (line-spacing         . 0  ) ; 文字間隔
                (left-fringe          . 12 ) ; 左フリンジ幅
                (right-fringe         . 12 ) ; 右フリンジ幅
                (menu-bar-lines       . 1  ) ; メニューバー
                (cursor-type          . box) ; カーソル種別
                (alpha                . 90) ; 透明度
                )
              default-frame-alist))
(setq initial-frame-alist default-frame-alist)


;;frame,bufferの保存
;;(desktop-save-mode t)
(setq browse-url-mosaic-program nil)

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
(setq auto-save-default nil)
(setq make-backup-files nil)
(menu-bar-mode -1)
(tool-bar-mode 0)
(add-to-list 'load-path "~/.emacs.d/elpa/dash-at-point")
(autoload 'dash-at-point "dash-at-point"
          "Search the word at point with Dash." t nil)
(global-set-key "\C-cd" 'dash-at-point)
(global-set-key "\C-ce" 'dash-at-point-with-docset)

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
 '(comment-style 'extra-line)
 '(custom-enabled-themes '(manoj-dark))
 '(dash-at-point-legacy-mode t)
 '(helm-delete-minibuffer-contents-from-point t)
 '(helm-ls-git-show-abs-or-relative 'relative)
 '(helm-mini-default-sources
   '(helm-source-buffers-list helm-source-files-in-current-dir helm-source-ls-git helm-source-recentf))
 '(helm-truncate-lines t t)
 '(js-doc-author (format "your name <%s>" js-doc-mail-address))
 '(js-doc-license "The MIT License")
 '(js-doc-mail-address "your email address")
 '(js-doc-url "your url")
 '(package-selected-packages
   '(web-mode package-build shut-up epl git commander f dash s use-package add-node-modules-path prettier-js tide ng2-mode find-file-in-project counsel sws-mode adjust-parens kotlin-mode elscreen go package-utils 0xc wgrep-helm 0blayout wgrep-pt w3m volatile-highlights smartrep shorten scss-mode psvn php-mode php-completion packed osx-browse org open-junk-file noctilux-theme markdown-mode mark-multiple magit lui let-alist lcs js2-refactor js-doc js-comint imenus ido-vertical-mode ido-occasional helm-projectile helm-migemo helm-ls-svn helm-ls-hg helm-git-grep helm-git-files helm-git helm-gist helm-descbinds helm-dash helm-ag haml-mode google-maps git-gutter-fringe+ git-gutter fuzzy full-ack expand-region esqlite epc ensime dash-at-point darcula-theme ctags company-web company-inf-ruby company-ansible color-moccur coffee-mode citrus-mode circe autopair auto-save-buffers-enhanced auto-install auto-complete-clang ansible ag ace-jump-mode ace-jump-helm-line ace-isearch ac-math ac-js2 ac-helm))
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

(require 'coffee-mode)
(defun coffee-custom ()
  "coffee-mode-hook"
  (and (set (make-local-variable 'tab-width) 2)
       (set (make-local-variable 'coffee-tab-width) 2))
  )

(add-hook 'coffee-mode-hook
  '(lambda() (coffee-custom)))

;; set-perl5lib
;; http://svn.coderepos.org/share/lang/elisp/set-perl5lib/set-perl5lib.el
(require 'set-perl5lib)


;; http://unknownplace.org/memo/2007/12/21#e001

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

;; js tide
(add-hook 'js2-mode-hook #'setup-tide-mode)

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

(require 'elscreen)
(elscreen-start)
(setq elscreen-prefix-key (kbd "C-z"))
;;; タブの先頭に[X]を表示しない

(setq elscreen-tab-display-kill-screen nil)
;; header-lineの先頭に[<->]を表示しない
(setq elscreen-tab-display-control nil)
;; バッファ名・モード名からタブに表示させる内容を決定する(デフォルト設定)
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

;;volatile-highlights
(require 'volatile-highlights)
(volatile-highlights-mode t)

;; helm
(require 'helm-config)
(require 'helm-descbinds)
(require 'helm-ag)
(require 'helm-swoop)
(require 'helm-ls-git)

(helm-mode 1)
(helm-migemo-mode 1)

(global-set-key (kbd "C-x C-d") ''helm-ls-git-ls)


  (with-eval-after-load "helm-regexp.el"
    (setq helm-source-occur (helm-make-source "Occur" 'helm-source-multi-occur))
    (setq helm-source-occur (helm-make-source "Moccur" 'helm-source-multi-occur)))


;; Change the keybinds to whatever you like :)
(global-set-key (kbd "M-i") 'helm-swoop)
(global-set-key (kbd "M-I") 'helm-swoop-back-to-last-point)
(global-set-key (kbd "C-c M-i") 'helm-multi-swoop)
(global-set-key (kbd "C-x M-i") 'helm-multi-swoop-all)

;; When doing isearch, hand the word over to helm-swoop
(define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)
;; From helm-swoop to helm-multi-swoop-all
(define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)
;; When doing evil-search, hand the word over to helm-swoop
;; Instead of helm-multi-swoop-all, you can also use helm-multi-swoop-current-mode
(define-key helm-swoop-map (kbd "M-m") 'helm-multi-swoop-current-mode-from-helm-swoop)

;; Save buffer when helm-multi-swoop-edit complete
(setq helm-multi-swoop-edit-save t)

;; If this value is t, split window inside the current window
(setq helm-swoop-split-with-multiple-windows nil)

;; Split direcion. 'split-window-vertically or 'split-window-horizontally
(setq helm-swoop-split-direction 'split-window-vertically)

;; If nil, you can slightly boost invoke speed in exchange for text color
(setq helm-swoop-speed-or-color nil)

;; ;; Go to the opposite side of line from the end or beginning of line
(setq helm-swoop-move-to-line-cycle t)

;; Optional face for line numbers
;; Face name is `helm-swoop-line-number-face`
(setq helm-swoop-use-line-number-face t)

;; If you prefer fuzzy matching
(setq helm-swoop-use-fuzzy-match t)


;; 画面更新するまでのタイムラグを設定する（デフォルトは 0.01）
(setq helm-input-idle-delay 0.2)

;; 表示する最大候補数を指定する（デフォルトで 100）
;; (setq helm-candidate-number-limit 500)

;; locateコマンドのパラメータを指定する
;; デフォルト値に設定してある -e オプションは性能がでないので削除している
(setq helm-locate-command "locate %s -A --regex %s")

;; ;;; ace-isearch
 (global-ace-isearch-mode 1)

;; ;;; [2015-03-23 Mon]C-u C-s / C-u C-u C-s
 (defun isearch-forward-or-helm-swoop (use-helm-swoop)
   (interactive "p")
   (let (current-prefix-arg
         (helm-swoop-pre-input-function 'ignore))
     (call-interactively
      (case use-helm-swoop
        (1 'isearch-forward)
        (4 'helm-swoop)
        (16 'helm-swoop-nomigemo)))))
 (global-set-key (kbd "C-s") 'isearch-forward-or-helm-swoop)

;; ;;; ido化: imenus/with-ido imenus-mode-buffers/with-idoを定義
 (with-ido-completion imenus)
;; ;; C-M-s C-M-sで現在のシンボルをhelm-multi-swoopできるよ！
 (global-set-key (kbd "C-M-s") (with-ido-completion imenus-mode-buffers))

 (global-set-key (kbd "C-;") 'helm-mini)
(global-set-key (kbd "C-c b") 'helm-descbinds)
(global-set-key (kbd "C-c o") 'helm-occur)
 (global-set-key (kbd "C-c g") 'helm-ag)
 (define-key global-map (kbd "M-y") 'helm-show-kill-ring)
 (global-set-key (kbd "C-c y") 'helm-show-kill-ring)
 (global-set-key (kbd "C-c s") 'helm-git-files)
 (global-set-key (kbd "C-c p") 'helm-swoop)
 (global-set-key (kbd "C-c d") 'dash-at-point)
 (global-set-key (kbd "C-c C-d") 'helm-browse-project)

 (define-key helm-map (kbd "C-h") 'delete-backward-char)

;; ;; helm-ag
;; ;;; 現在のシンボルをデフォルトのクエリにする
 (setq helm-ag-insert-at-point 'symbol)

;; ;;; C-M-gはちょうどあいてる
 (global-set-key (kbd "C-M-g") 'helm-ag)
 (global-set-key (kbd "C-M-g") 'helm-projectile-ag)
 (global-set-key (kbd "C-M-k") 'backward-kill-sexp) ;推奨

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
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

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


;; git-complete

(require 'git-complete)
(global-unset-key (kbd "C-c C-g")) ;; 一応unbindしておきましょう
(global-set-key (kbd "C-c C-g") 'git-complete)
(add-to-list 'load-path "~/.emacs.d/git-complete") ;; お好きなように
(setq git-complete-enable-autopair t)

;; markdown mode
(require 'markdown-mode)

;; angular js ng2-mode
(require 'ng2-mode)

;; counsel
(ivy-mode 1) ;; デフォルトの入力補完がivyになる
(counsel-mode 1)
;; M-x, C-x C-fなどのEmacsの基本的な組み込みコマンドをivy版にリマップする

;;; 下記は任意で有効化
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)

(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
(setq ivy-height 30) ;; minibufferのサイズを拡大！（重要）
(setq ivy-extra-directories nil)
(setq ivy-re-builders-alist
      '((t . ivy--regex-plus)))

;; counsel設定
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file) ;; find-fileもcounsel任せ！
(defvar counsel-find-file-ignore-regexp (regexp-opt '("./" "../")))


;; company
(global-company-mode)
(define-key company-active-map (kbd "M-n") nil)
(define-key company-active-map (kbd "M-p") nil)
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "C-h") nil)
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 2)
(setq company-selection-wrap-around t)

;; yasnippetとの連携
(defvar company-mode/enable-yas t
  "Enable yasnippet for all backends.")
(defun company-mode/backend-with-yas (backend)
  (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
      backend
    (append (if (consp backend) backend (list backend))
            '(:with company-yasnippet))))
(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))


(require 'find-file-in-project)
(global-set-key [(super shift i)] 'find-file-in-project)

;; Org modeの設定

; ファイルの場所
(setq org-directory "/Volumes/GoogleDrive/マイドライブ")
(setq org-default-notes-file "notes.org")
; Org-captureの設定
; Org-captureを呼び出すキーシーケンス
(define-key global-map "\C-cc" 'org-capture)
; Org-captureのテンプレート（メニュー）の設定
(setq org-capture-templates
      '(("n" "Note" entry (file+headline "/Volumes/GoogleDrive/マイドライブ/notes.org" "Notes")
         "* %?\nEntered on %U\n %i\n %a")
        ))

; メモをC-M-^一発で見るための設定
; https://qiita.com/takaxp/items/0b717ad1d0488b74429d から拝借
(defun show-org-buffer (file)
  "Show an org-file FILE on the current buffer."
  (interactive)
  (if (get-buffer file)
      (let ((buffer (get-buffer file)))
        (switch-to-buffer buffer)
        (message "%s" file))
    (find-file (concat "/Volumes/GoogleDrive/マイドライブ/" file))))
(global-set-key (kbd "C-M-^") '(lambda () (interactive)
                                 (show-org-buffer "notes.org")))

(global-flycheck-mode)
(flycheck-add-mode 'javascript-eslint 'js2-mode)
(flycheck-add-mode 'javascript-eslint 'web-mode)
;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)


(eval-after-load 'js-mode
  '(add-hook 'js-mode-hook #'add-node-modules-path))

;; prettifer

(require 'prettier-js)
(eval-after-load 'web-mode
    '(progn
       (add-hook 'web-mode-hook #'add-node-modules-path)
       (add-hook 'web-mode-hook #'prettier-js-mode)))
(eval-after-load 'js2-mode
    '(progn
       (add-hook 'js2-mode-hook #'add-node-modules-path)
       (add-hook 'js2-mode-hook #'prettier-js-mode)))
(eval-after-load 'typescript-mode
    '(progn
       (add-hook 'typescript-mode-hook #'add-node-modules-path)
       (add-hook 'typescript-mode-hook #'prettier-js-mode)))
(eval-after-load 'vue-mode
    '(progn
       (add-hook 'vue-mode-hook #'add-node-modules-path)
       (add-hook 'vue-mode-hook #'prettier-js-mode)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-annotation-face ((t (:inherit font-lock-constant-face))))
 '(egg-header ((t (:weight normal :height 1.6))))
 '(egg-help-header-1 ((t (:inherit egg-text-base :height 1.2))))
 '(egg-help-header-2 ((((class color) (background dark)) (:inherit egg-text-1 :foreground "LightSteelBlue"))))
 '(erc-keyword-face ((t (:foreground "RoyalBlue" :weight normal))) t)
 '(erc-notice-face ((t (:foreground "SlateBlue" :weight normal))) t)
 '(font-lock-comment-delimiter-face ((t (:inherit font-lock-comment-face :foreground "lavender"))))
 '(font-lock-comment-face ((t (:foreground "OliveDrab3" :slant oblique))))
 '(font-lock-constant-face ((t (:foreground "LightPink1" :weight normal))))
 '(font-lock-doc-face ((t (:inherit font-lock-string-face :foreground "lavender" :slant oblique))))
 '(font-lock-function-name-face ((t (:foreground "khaki2" :weight normal :height 1.0))))
 '(font-lock-keyword-face ((t (:foreground "CornflowerBlue"))))
 '(font-lock-string-face ((t (:foreground "LightSalmon"))))
 '(font-lock-variable-name-face ((t (:foreground "LightSkyBlue"))))
 '(js2-external-variable ((t (:foreground "PaleTurquoise"))))
 '(magit-blame-heading ((t (:background "SteelBlue1" :foreground "gray90"))))
 '(magit-diff-hunk-heading-highlight ((t (:background "gray80" :foreground "OrangeRed4"))))
 '(mumamo-background-chunk-major ((((class color) (min-colors 8)) (:background "*"))) t)
 '(mumamo-background-chunk-submode ((((class color) (min-colors 8)) (:background "*"))) t)
 '(web-mode-html-attr-name-face ((t (:foreground "LightSkyBlue"))))
 '(web-mode-html-tag-face ((t (:foreground "MediumAquamarine")))))


(put 'erase-buffer 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

;; cask
;;(require 'cask "/usr/local/opt/cask/cask.el")
;;(cask-initialize)

;; typescript
(require 'typescript-mode)
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
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
  (company-mode +1))
;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)
;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

;; jsx
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "jsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
;; configure jsx-tide checker to run after your default jsx checker
(flycheck-add-mode 'javascript-eslint 'web-mode)

(defun vue-mode/init-vue-mode ()
  "Initialize my package"
  (use-package vue-mode))


;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
