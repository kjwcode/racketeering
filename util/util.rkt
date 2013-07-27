#lang racket

(provide cleanup)

; Clean up output files from past runs.
(define (cleanup . fns)
  (define (delete-files args)
    (unless (empty? args)
      (when (file-exists? (first args)) (delete-file (first args)))
      (delete-files (rest args))))
  (delete-files fns))
