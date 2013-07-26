#lang racket

(require net/base64)
(require racket/runtime-path)

; Clean up output files from past runs.
(define (cleanup fn)
  (when (file-exists? fn) (delete-file fn)))

; Declare testdata.txt as a mandatory file for things to continue,
; give it a symbolic name.  Read the file.
(define-runtime-path data-file "testdata.txt")
(define istr (with-input-from-file data-file
               (λ () (read-bytes (file-size data-file)))))

; Base64-encode the input string (bytes, really), write them out to
; testdata2.txt after deleting it if necessary.
(define ostr (base64-encode istr))
(cleanup "testdata2.txt")
(with-output-to-file "testdata2.txt"
  (λ () (write-bytes ostr)))

; Read in testdata2.txt.
(define-runtime-path data-file2 "testdata2.txt")
(define istr2 (with-input-from-file data-file2
               (λ () (read-bytes (file-size data-file2)))))

; Base64-decode the bytes from testdata2.txt, writing the decoded bytes
; to testdata3.txt after ensuring any previous versions are deleted.
(define ostr2 (base64-decode istr2))
(cleanup "testdata3.txt")
(with-output-to-file "testdata3.txt"
  (λ () (write-bytes ostr2)))
