;;; moccur-edit-test.el --- moccur-edit の回帰テスト -*- lexical-binding: t; -*-

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

;;; moccur-edit-test.el ends here
