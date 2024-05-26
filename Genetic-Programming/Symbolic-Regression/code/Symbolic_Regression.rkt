#lang racket

(require "Graphic.rkt" "util.rkt")

(define gens 100000000000)

(define (reproduce gen) (cons (evaluate (mutation (caar gen))) (append gen (apply append (map (λ (i) (map (λ (j) (cross-over (car i) (car j))) gen)) gen)))))

(define (sort-gen lst) (sort lst (lambda (a b) (< (cadr a) (cadr b)))))

(define (best gen) (take (sort-gen gen) size))
 
(define (Symbolic-Regression)
    (init)
    (define (regr-h gen i)
        (display (list 'gen: i (caar gen) (- (cadar gen) 3))) (newline)
        (when (zero? (remainder i 8000)) (update (caar gen)))
        (when (or (= i gens) (<= (cadar gen) 3)) (update (caar gen)) (sleep 10) (exit))
        (regr-h (best (reproduce gen)) (+ i 1))
    )(thread (lambda () (regr-h (make-gen) 1)))
)

(Symbolic-Regression)
