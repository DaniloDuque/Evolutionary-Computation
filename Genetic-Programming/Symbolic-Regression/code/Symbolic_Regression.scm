#lang racket

(require "Graphic.scm" "util.scm")

(define (reproduce gen) (cons (evaluate (mutation (caar gen))) (append gen (apply append (map (λ (i) (map (λ (j) (cross-over (car i) (car j))) gen)) gen)))))

(define (sort-gen lst) (sort lst (lambda (a b) (< (cadr a) (cadr b)))))

(define (best gen) (take (sort-gen gen) size))

(define (print-function f) 
    (cond
        ((equal? f _+_) '+)
        ((equal? f _-_) '-)
        ((equal? f _*_) '*)
        ((equal? f _/_) '/)
        (#t '^)
    )
)

(define (show exp)
    (define (show-h exp)
        (cond
            ((not (list? exp)) exp)
            ((equal? (car exp) _lg_) (list "log(" (show-h (cadr exp)) "," (show-h (caddr exp)) ")"))
            (#t (list (show-h (cadr exp)) (print-function (car exp)) (show-h (caddr exp))))
        )
    )(display (list "Function: " (show-h (car exp)) "\n" "Fitness: " (cadr exp) "\n"))
)

(define (Symbolic-Regression)
    (init)
    (define (regr-h gen i)
        (when (zero? (remainder i 8000)) (update (caar gen)) (show (car gen)))
        (regr-h (best (reproduce gen)) (+ i 1))
    )(thread (lambda () (regr-h (make-gen) 1)))
)

(Symbolic-Regression)
