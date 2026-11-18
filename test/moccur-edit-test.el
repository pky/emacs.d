;;; moccur-edit-test.el --- moccur-edit の回帰テスト -*- lexical-binding: t; -*-

(require 'cl-lib)
(require 'ert)
(require 'moccur-edit)

(ert-deftest moccur-edit-get-info-normal-line ()
  (with-temp-buffer
    (insert "Buffer: foo.txt File: /tmp/foo.txt\n     12 hello world\n")
    (forward-line -1)
    (let ((moccur-edit-buf nil)
          (moccur-edit-line nil)
          (moccur-edit-text nil))
      (moccur-edit-get-info)
      (should (equal moccur-edit-buf "foo.txt"))
      (should (eql moccur-edit-line 12))
      (should (equal moccur-edit-text "hello world")))))

(ert-deftest moccur-edit-get-info-empty-line ()
  (with-temp-buffer
    (insert "Buffer: foo.txt File: /tmp/foo.txt\n     12 \n")
    (forward-line -1)
    (let ((moccur-edit-buf nil)
          (moccur-edit-line nil)
          (moccur-edit-text nil))
      (moccur-edit-get-info)
      (should (eql moccur-edit-line 12))
      (should (equal moccur-edit-text "")))))

(ert-deftest moccur-edit-get-info-clears-stale-state ()
  (with-temp-buffer
    (insert "Buffer: foo.txt File: /tmp/foo.txt\n     12\n")
    (forward-line -1)
    (let ((moccur-edit-buf nil)
          (moccur-edit-line 5)
          (moccur-edit-text "old"))
      (moccur-edit-get-info)
      (should-not moccur-edit-line)
      (should-not moccur-edit-text))))

(ert-deftest moccur-edit-change-file-empty-text ()
  (with-temp-buffer
    (insert "a\nb\nc")
    (let ((moccur-edit-line 2)
          (moccur-edit-text ""))
      (should (eq (moccur-edit-change-file) t))
      (should (equal (buffer-string) "a\n\nc")))))

(ert-deftest moccur-edit-change-file-normal-text ()
  (with-temp-buffer
    (insert "a\nb\nc")
    (let ((moccur-edit-line 2)
          (moccur-edit-text "B"))
      (should (eq (moccur-edit-change-file) t))
      (should (equal (buffer-string) "a\nB\nc")))))

(ert-deftest moccur-edit-change-file-unparsed-state ()
  (with-temp-buffer
    (insert "a\nb\nc")
    (let ((moccur-edit-line nil)
          (moccur-edit-text nil))
      (should-not (moccur-edit-change-file))
      (should (equal (buffer-string) "a\nb\nc")))))

(ert-deftest moccur-edit-get-info-clears-stale-buffer-without-header ()
  (with-temp-buffer
    (insert "     12 hello")
    (let ((moccur-edit-buf "other.txt")
          (moccur-edit-line nil)
          (moccur-edit-text nil))
      (moccur-edit-get-info)
      (should-not moccur-edit-buf))))

(ert-deftest moccur-edit-finish-edit-without-header-preserves-target ()
  (let ((target (generate-new-buffer "moccur-edit-test-target")))
    (unwind-protect
        (progn
          (with-current-buffer target
            (insert "a\nb\nc"))
          (with-temp-buffer
            (insert "     2 X")
            (let ((moccur-edit-overlays (list (make-overlay (point-min) (point-max))))
                  (moccur-edit-result-overlays nil)
                  (moccur-edit-buf (buffer-name target))
                  (moccur-edit-line 2)
                  (moccur-edit-text "stale")
                  (moccur-edit-highlight-edited-text nil))
              (cl-letf (((symbol-function 'moccur-edit-reset-key) #'ignore))
                (moccur-edit-finish-edit)))
            (with-current-buffer target
              (should (equal (buffer-string) "a\nb\nc")))))
      (kill-buffer target))))

(ert-deftest moccur-edit-finish-edit-rejects-only-unparsable-line ()
  (let ((target (generate-new-buffer "moccur-edit-test-target")))
    (unwind-protect
        (progn
          (with-current-buffer target
            (insert "a\nb\nc"))
          (with-temp-buffer
            (insert (format "Buffer: %s File: /tmp/x\n     1\n     2 b"
                            (buffer-name target)))
            (goto-char (point-min))
            (forward-line 1)
            (let* ((line-a-start (point))
                   (line-a-end (line-end-position))
                   (line-b-start (line-beginning-position 2))
                   (line-b-end (line-end-position 2))
                   (moccur-edit-overlays (list (make-overlay line-a-start line-a-end)))
                   (moccur-edit-result-overlays nil)
                   (moccur-edit-buf nil)
                   (moccur-edit-line nil)
                   (moccur-edit-text nil)
                   (moccur-edit-highlight-edited-text nil))
              (cl-letf (((symbol-function 'moccur-edit-reset-key) #'ignore))
                (moccur-edit-finish-edit))
              (with-current-buffer target
                (should (equal (buffer-string) "a\nb\nc")))
              (should (cl-some (lambda (overlay)
                                 (eq (overlay-get overlay 'face)
                                     'moccur-edit-reject-face))
                               moccur-edit-result-overlays))
              (dolist (overlay moccur-edit-result-overlays)
                (let ((face (overlay-get overlay 'face))
                      (start (overlay-start overlay))
                      (end (overlay-end overlay)))
                  (when (eq face 'moccur-edit-reject-face)
                    (should (<= line-a-start start end line-a-end)))
                  (when face
                    (should-not (<= line-b-start start line-b-end))))))))
      (kill-buffer target))))

(ert-deftest moccur-edit-get-info-with-result-text-narrowed-out ()
  (with-temp-buffer
    (insert "Buffer: tgt File: /tmp/x\n     2 oriXginal")
    (goto-char (point-min))
    (forward-line 1)
    (let ((narrowed-end (+ (point) (length "     2 ")))
          (moccur-edit-buf nil)
          (moccur-edit-line nil)
          (moccur-edit-text nil))
      (narrow-to-region (point-min) narrowed-end)
      (moccur-edit-get-info)
      (should (= (point-max) narrowed-end))
      (should (equal moccur-edit-buf "tgt"))
      (should (eql moccur-edit-line 2))
      (should (equal moccur-edit-text "oriXginal")))))

(ert-deftest moccur-edit-get-info-with-header-narrowed-out ()
  (with-temp-buffer
    (insert "Buffer: tgt File: /tmp/x\n     2 oriXginal")
    (goto-char (point-min))
    (forward-line 1)
    (let ((narrowed-start (point))
          (narrowed-end (point-max))
          (moccur-edit-buf nil)
          (moccur-edit-line nil)
          (moccur-edit-text nil))
      (narrow-to-region narrowed-start narrowed-end)
      (moccur-edit-get-info)
      (should (= (point-min) narrowed-start))
      (should (= (point-max) narrowed-end))
      (should (eql moccur-edit-line 2))
      (should (equal moccur-edit-text "oriXginal"))
      (should (equal moccur-edit-buf "tgt")))))

(ert-deftest moccur-edit-finish-edit-applies-overlay-outside-narrowing ()
  (let ((target-a (generate-new-buffer "moccur-edit-test-target-a"))
        (target-b (generate-new-buffer "moccur-edit-test-target-b")))
    (unwind-protect
        (progn
          (with-current-buffer target-a
            (insert "a\n")
            (set-buffer-modified-p nil))
          (with-current-buffer target-b
            (insert "b\n")
            (set-buffer-modified-p nil))
          (with-temp-buffer
            (insert (format "Buffer: %s File: /tmp/a\n     1 aX\n\nBuffer: %s File: /tmp/b\n     1 b\n"
                            (buffer-name target-a) (buffer-name target-b)))
            (goto-char (point-min))
            (forward-line 1)
            (let ((moccur-edit-overlays (list (make-overlay (point) (line-end-position))))
                  (moccur-edit-result-overlays nil)
                  (moccur-edit-buf nil)
                  (moccur-edit-line nil)
                  (moccur-edit-text nil)
                  (moccur-edit-highlight-edited-text nil))
              (forward-line 3)
              (forward-char (length "     1 "))
              (let ((narrowed-start (point))
                    (narrowed-end (point-max)))
                (narrow-to-region narrowed-start narrowed-end)
                (cl-letf (((symbol-function 'moccur-edit-reset-key) #'ignore))
                  (moccur-edit-finish-edit))
                (with-current-buffer target-a
                  (should (equal (buffer-string) "aX\n")))
                (with-current-buffer target-b
                  (should (equal (buffer-string) "b\n"))
                  (should-not (buffer-modified-p)))
                (should (= (point-min) narrowed-start))
                (should (= (point-max) narrowed-end))))))
      (kill-buffer target-a)
      (kill-buffer target-b))))

(ert-deftest moccur-edit-change-file-replaces-line-outside-narrowing ()
  (with-temp-buffer
    (insert "alpha\nbravo\ncharlie")
    (goto-char (point-min))
    (forward-line 2)
    (narrow-to-region (point) (point-max))
    (let ((widen-automatically nil)
          (moccur-edit-line 2)
          (moccur-edit-text ""))
      (should (eq (moccur-edit-change-file) t))
      (should (equal (save-restriction (widen) (buffer-string))
                     "alpha\n\ncharlie"))
      (should (equal (buffer-string) "charlie")))))

(ert-deftest moccur-edit-change-file-replaces-line-cut-off-by-narrowing ()
  (with-temp-buffer
    (insert "alpha\nbravo\ncharlie")
    (goto-char (point-min))
    (forward-line 1)
    (forward-char (length "bra"))
    (narrow-to-region (point-min) (point))
    (let ((moccur-edit-line 2)
          (moccur-edit-text "X"))
      (moccur-edit-change-file)
      (should (equal (save-restriction (widen) (buffer-string))
                     "alpha\nX\ncharlie")))))

;;; moccur-edit-test.el ends here
