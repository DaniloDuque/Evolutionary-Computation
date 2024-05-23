#lang racket

(require "util.rkt" "operators.rkt" racket/gui plot)

(define gens 100000000000)

(define exp '())

(define (reproduce gen) (cons (evaluate (mutation (caar gen))) (append gen (apply append (map (λ (i) (map (λ (j) (cross-over (car i) (car j))) gen)) gen)))))

(define (sort-gen lst) (sort lst (lambda (a b) (< (cadr a) (cadr b)))))

(define (best gen) (take (sort-gen gen) size))

(define frame_ (new frame% [label "Aproximated Function"] [width 600] [height 420]))

(define canvas_
    (new canvas%
        [parent frame_]
        [paint-callback
            (lambda (canvas dc)
                (send dc draw-bitmap
                (plot3d-bitmap (list
                (surface3d (λ (x y) (eval-exp exp x y)) -10 25 -10 25)
                (points3d entry #:sym 'dot #:size 30 #:color 3))
                #:width 600
                #:height 420)
                0 0)
            )
        ]
    )
)

(define (Symbolic-Regression)
    (send frame_ show #t)
    (define (start-evolution) (thread (lambda () (regr-h (make-gen) 1))))
    (define (regr-h gen i)
        (display (list 'gen: i (caar gen) (- (cadar gen) 3))) (newline)
        ;(when (zero? (remainder 10 i))
            ;(set! exp (caar gen))
            ;(send canvas_ refresh))
        (when (or (= i gens) (<= (cadar gen) 3))
            ;(set! exp (caar gen))
            ;(send canvas_ refresh)
            (print "found!") (define i gens) (sleep 15) (exit))
        (let ((next-gen (best (reproduce gen))))
            (thread (lambda () (regr-h next-gen (+ i 1))))))
    (start-evolution)
)

(Symbolic-Regression)
