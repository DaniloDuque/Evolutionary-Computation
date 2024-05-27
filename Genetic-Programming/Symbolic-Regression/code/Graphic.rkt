#lang racket

(require "util.rkt" plot racket/gui)
(provide init update)

(define exp '())
(define frame_ (new frame% [label "Aproximated Function"] [width 800] [height 600]))

(define (match fun x y)
    (cond
        ((eq? fun '_+_) (+ x y))
        ((eq? fun '_-_) (- x y))
        ((eq? fun '_*_) (* x y))
        ((eq? fun '_/_) (/ x y))
        ((eq? fun '_^_) (expt x y))
        (#t (log y x))
    )
)

(define (eval-parse fun x y)
    (cond
        ((not (list? fun)) (cond ((eq? fun 'x) x) ((eq? fun 'y) y) (#t fun)))
        (#t (match (car fun) (eval-parse (cadr fun) x y) (eval-parse (caddr fun) x y)))
    )
)

(define canvas_
    (new canvas%
        [parent frame_]
        [paint-callback
            (lambda (canvas dc)
                (send dc draw-bitmap
                (plot3d-bitmap (list
                (surface3d (λ (x y) (eval-parse exp x y)) -10 25 -10 25)
                (points3d entry #:sym 'dot #:size 30 #:color 0))
                #:width 800
                #:height 600)
                0 0)
            )
        ]
    )
)

(define (init) (send frame_ show #t))

(define (update new) 
    (set! exp new)
    (send canvas_ refresh)
)
