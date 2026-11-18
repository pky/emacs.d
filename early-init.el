;;; early-init.el --- init.el より前に読まれる設定  -*- lexical-binding: nil -*-
;; パッケージの有効化は init.el を読む前に行われるため、警告の抑制はここに置く。
;; 古いパッケージの lexical-binding クッキー欠落警告と、ネイティブコンパイルの警告を抑える。
(require 'warnings)
(add-to-list 'warning-suppress-types '(files))
(setq native-comp-async-report-warnings-errors 'silent)
