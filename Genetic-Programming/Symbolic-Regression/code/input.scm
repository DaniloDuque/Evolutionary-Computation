#lang racket

(provide read-file)

(define (read-lines input-port)
    (let ((line (read-line input-port)))
        (cond
            ((eof-object? line) '())
            (else (cons (read (open-input-string line)) (read-lines input-port)))
        )
    )
)

(define (read-file name) (call-with-input-file name (lambda (input-port) (read-lines input-port))))
