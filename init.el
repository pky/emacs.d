;;; init.el  -*- lexical-binding: nil -*-
;;; Code:
(require 'package)
;; 現在、標準的で推奨される設定はこの2つです
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)


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

(require 'doom-themes)
(load-theme 'doom-tokyo-night t)

(defun set-frame-size-to-left-half ()
  (interactive)
  (when (display-graphic-p)
    (let* ((display-attrs (car (display-monitor-attributes-list)))
           (workarea (alist-get 'workarea display-attrs))
           (width (- (nth 2 workarea) (nth 0 workarea)))
           (height (- (nth 3 workarea) (nth 1 workarea)))
           (frame-width (floor (* 0.495 width)))
           (frame-height height))
      (set-frame-position (selected-frame) 0 0)
      (set-frame-size (selected-frame)
                      (floor (* 0.495 (/ width (frame-char-width))))
                      (floor (/ height (frame-char-height)))
                      nil))))

;; 起動時にフレームサイズを設定
(add-hook 'window-setup-hook 'set-frame-size-to-left-half)
(add-hook 'after-init-hook 'set-frame-size-to-left-half)
(run-with-idle-timer 0.5 nil 'set-frame-size-to-left-half)
(run-with-idle-timer 1.0 nil 'set-frame-size-to-left-half)

;; 既存のdefault-frame-alistとinitial-frame-alistの設定を無効化
(setq default-frame-alist nil)
(setq initial-frame-alist nil)


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
             :height 140)
;; 日本語
(set-fontset-font
 nil 'japanese-jisx0208
  (font-spec :family "MigMix 1M"))
(setq face-font-rescale-alist
      '((".*MigMix 1M.*" . 1.4)))
))

;;GUIで起動するときはサーバーも起動するようにする．
(if window-system (progn
    (require 'server)
    (unless (server-running-p)
         (server-start) )))

;;close-all-buffers
(defun close-all-buffers ()
  (interactive)
  (mapc 'kill-buffer (buffer-list)))

;;svn
(setq process-coding-system-alist '(("svn" . utf-8)))
(setq svn-status-svn-process-coding-system 'utf-8)

;; Apple Silicon の Homebrew は /opt/homebrew。GUI 起動では PATH に入らないため明示する。
(dolist (dir '("/usr/local/bin" "/opt/homebrew/bin"))
  (add-to-list 'exec-path dir)
  (setenv "PATH" (concat dir ":" (getenv "PATH"))))

(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\e[3~" 'delete-char)
(global-set-key "\C-xa" 'recentf-open-files)
(global-set-key (kbd "C-j") 'newline-and-indent)
(setq mac-option-modifier 'meta)

;; shell zsh
(setq shell-file-name "/usr/local/bin/zsh")

;; Don't show the startup splash screen
(setq inhibit-startup-message t)
(setq blink-matching-paren nil)
(setq blink-matching-delay 0.1)
(setq truncate-lines nil)
(setq truncate-partial-width-windows nil)

;; uc dc
(setq read-file-name-completion-ignore-case t)

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
(setq whitespace-display-mappings
      '((space-mark ?\x3000 [?\□])
        (space-mark   ?\    [?\xB7]     [183])
        (space-mark   ?\xA0 [?\xA4]     [?_])
        (tab-mark   ?\t   [?\xBB ?\t])
        ))
(global-whitespace-mode 1)
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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auth-source-save-behavior nil)
 '(comment-style 'extra-line)
 '(dash-at-point-legacy-mode t)
 '(helm-delete-minibuffer-contents-from-point t)
 '(helm-ls-git-show-abs-or-relative 'relative)
 '(helm-mini-default-sources
   '(helm-source-buffers-list helm-source-files-in-current-dir helm-source-ls-git helm-source-recentf))
 '(helm-truncate-lines t)
 '(js-doc-author (format "your name <%s>" js-doc-mail-address))
 '(js-doc-license "The MIT License")
 '(js-doc-mail-address "your email address")
 '(js-doc-url "your url")
 '(package-selected-packages
   '(doom-themes which-key tokyo-night kotlin-mode markdown-mode js2-mode projectile migemo wgrep-ag yaml-mode helm-ls-git web-mode typescript-mode olivetti exec-path-from-shell vmd-mode grip-mode magit package-build shut-up epl git commander f dash s use-package add-node-modules-path prettier-js tide find-file-in-project counsel adjust-parens elscreen package-utils 0xc wgrep-helm 0blayout wgrep-pt w3m volatile-highlights smartrep shorten scss-mode php-mode packed osx-browse org noctilux-theme multiple-cursors let-alist lcs js2-refactor js-doc js-comint imenus ido-vertical-mode ido-occasional helm-projectile helm-migemo helm-ls-svn helm-ls-hg helm-git-grep helm-git-files helm-git helm-gist helm-descbinds helm-dash helm-ag haml-mode git-gutter-fringe git-gutter fuzzy expand-region epc dash-at-point darcula-theme ctags company-web color-moccur coffee-mode citrus-mode circe auto-save-buffers-enhanced auto-install auto-complete-clang ag ace-jump-mode ace-jump-helm-line ace-isearch ac-math ac-js2 ac-helm))
 '(standard-indent 2))

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
(require 'moccur-edit nil t)
;; moccur-edit-finisi-edit and save
(defadvice moccur-edit-change-file
  (after save-after-moccur-edit-buffer activate)
  (when ad-return-value
    (save-buffer)))

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
(setq migemo-dictionary "/opt/homebrew/share/migemo/utf-8/migemo-dict")

(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(setq migemo-coding-system 'utf-8-unix)
(load-library "migemo")
(migemo-init)

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
(require 'multiple-cursors)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-M-m") 'mc/mark-more-like-this-extended)
(global-set-key (kbd "C-*") 'mc/mark-all-like-this)
(add-hook 'js2-mode-hook 'ac-js2-mode)

;; js tide
(add-hook 'js2-mode-hook #'setup-tide-mode)
(add-hook 'typescript-mode-hook #'setup-tide-mode)

;;js-doc
(require 'js-doc)

(add-hook 'js2-mode-hook
          '(lambda ()
             (local-set-key "\C-ci" 'js-doc-insert-function-doc)
             (local-set-key "@" 'js-doc-insert-tag)
             ))

;; ruby-block.el
(require 'ruby-block)
(ruby-block-mode t)
(setq ruby-block-highlight-toggle t)

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
(setq ctags-command "/usr/bin/ctags -R --fields=\"+afikKlmnsSzt\" ")
(global-set-key (kbd "<f5>") 'ctags-create-or-update-tags-table)

(setq ac-js2-evaluate-calls t)

;; yaml
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(setq tab-width 2)

;; autopair
(electric-pair-mode 1) ; 組み込み。autopair は MELPA から消えたため置き換え

;;volatile-highlights
(require 'volatile-highlights)
(volatile-highlights-mode t)

;; helm
(require 'helm-core)
(require 'helm-descbinds)
(require 'helm-ag)
(require 'helm-swoop)
(require 'helm-ls-git)

(helm-mode 1)
(helm-migemo-mode 1)

(global-set-key (kbd "C-x C-d") 'helm-ls-git-ls)



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

;; ;;; ido化: imenus/with-ido imenus-mode-buffers/with-idoを定義
 (with-ido-completion imenus)
;; ;; C-M-s C-M-sで現在のシンボルをhelm-multi-swoopできるよ！
 (global-set-key (kbd "C-M-s") (with-ido-completion imenus-mode-buffers))

 (global-set-key (kbd "C-;") 'helm-mini)
(global-set-key (kbd "C-c b") 'helm-descbinds)
(global-set-key (kbd "C-c o") 'helm-occur)
 (define-key global-map (kbd "M-y") 'helm-show-kill-ring)
 (global-set-key (kbd "C-c y") 'helm-show-kill-ring)
 (global-set-key (kbd "C-c p") 'helm-swoop)
 (global-set-key (kbd "C-c C-d") 'helm-browse-project)

 (define-key helm-map (kbd "C-h") 'delete-backward-char)

;; ;; helm-ag
;; ;;; 現在のシンボルをデフォルトのクエリにする
 (setq helm-ag-insert-at-point 'symbol)

 (global-set-key (kbd "C-M-g") 'helm-projectile-ag)
 (global-set-key (kbd "C-M-k") 'backward-kill-sexp) ;推奨

;; git-gutter (git-gutter+ は MELPA から消えたため置き換え)
(require 'git-gutter)
(require 'git-gutter-fringe nil t) ; 未導入ならマージン表示になる
(global-git-gutter-mode 1)

(global-set-key (kbd "C-x g") 'git-gutter-mode) ; Turn on/off in the current buffer
(global-set-key (kbd "C-x G") 'global-git-gutter-mode) ; Turn on/off globally

;; hunk間の移動と操作。コミット系は magit に任せる
;; git-gutter にはキーマップがないため、標準の C-x n/p/r/t を潰さないよう C-x v 配下に置く
(global-set-key (kbd "C-x v n") 'git-gutter:next-hunk)
(global-set-key (kbd "C-x v p") 'git-gutter:previous-hunk)
(global-set-key (kbd "C-x v h") 'git-gutter:popup-hunk)
(global-set-key (kbd "C-x v R") 'git-gutter:revert-hunk)
(global-set-key (kbd "C-x v s") 'git-gutter:stage-hunk)

;;php-mode
(require 'php-mode)
(setq php-mode-force-pear t) ;PEAR規約のインデント設定にする
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode)) ;
;; php-mode-hook
(add-hook 'php-mode-hook
          (lambda ()
            (setq tab-width 2)
            (setq indent-tabs-mode nil)
            (setq c-basic-offset 2)
            (make-local-variable 'ac-sources)
            (setq ac-sources '(
                               ac-source-words-in-same-mode-buffers
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

(defun my/web-mode-setup ()
  ;;(electric-indent-local-mode -1)
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-attr-indent-offset 2)
  (setq web-mode-indent-style 2)
  (setq web-mode-style-padding 2)
  (setq web-mode-script-padding 2)
  (setq web-mode-block-padding 2))
(add-hook 'web-mode-hook #'my/web-mode-setup)

;; git-complete

(require 'git-complete)
(global-unset-key (kbd "C-c C-g")) ;; 一応unbindしておきましょう
(global-set-key (kbd "C-c C-g") 'git-complete)
(setq git-complete-enable-autopair t)


;; --- Markdown Mode Beautification ---

;; 可変幅フォントのために必要
(require 'cl-lib)

;; カラーテーマを読み込んだ「後」にフォント設定を行う
(add-hook 'after-init-hook
          (lambda ()
            (set-face-attribute 'variable-pitch nil
                                :font "Hiragino Kaku Gothic ProN-15" :height 1.1)
            (set-face-attribute 'fixed-pitch nil
                                :font "Menlo-14")
            (set-face-attribute 'markdown-code-face nil
                                :inherit 'fixed-pitch)
            (dolist (face '((markdown-header-face-1 . 1.4)
                            (markdown-header-face-2 . 1.3)
                            (markdown-header-face-3 . 1.2)
                            (markdown-header-face-4 . 1.1)
                            (markdown-header-face-5 . 1.0)
                            (markdown-header-face-6 . 1.0)))
              (set-face-attribute (car face) nil :weight 'bold :height (cdr face) :inherit 'variable-pitch))))

;; olivetti-mode の設定
(use-package olivetti
  :ensure t)

;; markdown-mode の設定
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . gfm-mode))
  :hook ((markdown-mode . (lambda ()
                            ;; 公式ドキュメントで確認された正しいコマンド
                            (markdown-toggle-markup-hiding)
                            ;; 可変幅フォントを有効にする
                            (variable-pitch-mode 1))))
  :config
  ;; ヘッダーの大きさをスケールさせる
  (setq markdown-header-scaling t))

;; after-init-hook の markdown-code-face 設定は、フェイスが定義済みであることが前提
(require 'markdown-mode)

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

(global-flycheck-mode)
(flycheck-add-mode 'javascript-eslint 'js2-mode)
(flycheck-add-mode 'javascript-eslint 'web-mode)
(flycheck-add-mode 'javascript-eslint 'typescript-mode)


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
 '(web-mode-html-attr-name-face ((t (:foreground "LightSkyBlue"))))
 '(web-mode-html-tag-face ((t (:foreground "MediumAquamarine")))))


(put 'erase-buffer 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

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

;; jsx
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "jsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

;; 自動再読み込み
(global-auto-revert-mode 1)

;; org
(require 'org)
(require 'ob-C)
(require 'ob-ruby)
(setq org-directory (expand-file-name "~/Documents/org/"))
;; org-directory がない環境でも起動できるようにする
(setq org-agenda-files (when (file-directory-p org-directory)
                         (append
                          (list (concat org-directory "todo.org"))
                          (directory-files org-directory t "^todo_.*\\.org$"))))
(setq org-src-fontify-natively t)
(defun my-org-confirm-babel-evaluate (lang body)
  (not (or (string= lang "ditaa")
           (string= lang "emacs-lisp")
           (string= lang "ruby")
           (string= lang "C")
           (string= lang "cpp")
           )))
(setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)

;; org-todo設定
(require 'org-agenda)

;; TODOキーワード設定
(setq org-todo-keywords
  '((sequence "TODO(t)" "DOIN(n)" "WAIT(w)" "SOMEDAY(s)" "REMD(r)"
       "|" "DONE(d)" "SKIP(x)")))
(setq org-todo-keyword-faces
  '(
    ("WAIT"  . (:foreground "CadetBlue3"      :weight bold))
    ("TODO"  . (:foreground "LightGoldenrod3" :weight bold))
    ("REMD"  . (:foreground "PaleGreen3"      :weight bold))
    ("SOMEDAY"  . (:foreground "dark gray"       :weight bold))
    ))

;; DONEとなった時間を記録しない
(setq org-log-done nil)

;; DONEステータス時の見出しの色を変えない
(setq org-fontify-done-headline nil)

;; 日次ダッシュボード(Dashboard/*.org)の表示設定
;; todo.org など他のorgファイルには影響させず、パスで絞る
(defun my/org-dashboard-setup ()
  (when (and buffer-file-name
             (string-match-p "/Dashboard/" buffer-file-name))
    (setq-local org-hide-emphasis-markers t)
    (org-restart-font-lock)
    (org-indent-mode 1)))
(add-hook 'org-mode-hook #'my/org-dashboard-setup)

;; 覚えなくて済む仕組み
;; 見出しの先頭で ? を押すと一文字コマンドの一覧が出る
;; org-indent で * が隠れても効くよう、* と空白の後ろ(見出し文字の頭)まで有効にする
(setq org-use-speed-commands
      (lambda ()
        (and (org-at-heading-p)
             (<= (point)
                 (save-excursion
                   (beginning-of-line)
                   (skip-chars-forward "*")
                   (skip-chars-forward " \t")
                   (point))))))
;; ? は英語の組み込みヘルプではなく、日本語の早見表を開く
(add-to-list 'org-speed-commands '("?" . my/org-cheatsheet))

;; which-key: キーを途中まで押して止まると続きの候補を出す(未導入なら何もしない)
(when (require 'which-key nil t)
  (setq which-key-idle-delay 0.5)
  (which-key-mode 1))

;; 早見表を C-c h で開く(C-h は delete-backward-char に割り当て済みのため使えない)
(defvar my/org-cheatsheet-file (expand-file-name "~/.emacs.d/org-cheatsheet.org"))
(defun my/org-cheatsheet ()
  (interactive)
  (view-file my/org-cheatsheet-file))
(global-set-key (kbd "C-c h") 'my/org-cheatsheet)

;; アーカイブファイル名を生成する関数
(defun get-archive-filename (date)
  (let ((archive-dir (concat org-directory "archive/")))
    (unless (file-exists-p archive-dir)
      (make-directory archive-dir t))
    (concat archive-dir "archive_" date ".org")))

;; アーカイブファイルを作成する関数
(defun create-archive-file (date)
  (let ((filename (get-archive-filename date)))
    (unless (file-exists-p filename)
      (with-temp-file filename
        (insert (format "#+TITLE: Archive %s\n\n" date))
        (insert "* DONE\n\n")))
    filename))

;; 完了したタスクをアーカイブする関数
(defun archive-done-tasks ()
  (interactive)
  (let* ((today (format-time-string "%Y%m%d"))
         (archive-file (create-archive-file today))
         (current-file (buffer-file-name)))
    (when (and current-file 
               (or (string= current-file (concat org-directory "todo.org"))
                   (string-match "todo_.*\\.org$" current-file)))
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward "^\\* DONE " nil t)
          (let* ((task-start (match-beginning 0))
                 (next-task-start (save-excursion
                                  (forward-line)
                                  (re-search-forward "^\\* " nil t)
                                  (match-beginning 0)))
                 (task-end (if next-task-start
                              next-task-start
                            (point-max)))
                 (task-content (buffer-substring-no-properties task-start task-end)))
            (when task-start
              (with-temp-buffer
                (insert-file-contents archive-file)
                (goto-char (point-min))
                (re-search-forward "\\* DONE")
                (forward-line)
                (insert task-content)
                (write-file archive-file))
              (delete-region task-start task-end)
              (save-buffer))))))))

;; org-agendaの設定
(setq org-agenda-custom-commands
      '(("s" "検索" search ""
         ((org-agenda-text-search-extra-files
           (directory-files org-directory t "todo_.*\\.org$"))
          (org-agenda-files
           (directory-files org-directory t "archive_.*\\.org$"))))))


;; キーバインドの設定（最後にまとめて設定）
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c A") 'archive-done-tasks)
(global-set-key (kbd "C-c s") 'org-agenda-search)
