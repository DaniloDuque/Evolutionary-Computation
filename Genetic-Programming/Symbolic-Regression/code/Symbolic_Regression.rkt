#lang racket

(require "Graphic.rkt" "util.rkt")

(define (reproduce gen) (cons (evaluate (mutation (caar gen))) (append gen (apply append (map (λ (i) (map (λ (j) (cross-over (car i) (car j))) gen)) gen)))))

(define (sort-gen lst) (sort lst (lambda (a b) (< (cadr a) (cadr b)))))

(define (best gen) (take (sort-gen gen) size))
 
(define (Symbolic-Regression)
    (init)
    (define (regr-h gen i)
        (when (zero? (remainder i 8000)) (update (caar gen)) (display (list "Function: " (caar gen) "\n")))
        (when (<= (cadar gen) 10) (update (caar gen)) (sleep 10) (exit))
        (regr-h (best (reproduce gen)) (+ i 1))
    )(thread (lambda () (regr-h (make-gen) 1)))
)

(Symbolic-Regression)
