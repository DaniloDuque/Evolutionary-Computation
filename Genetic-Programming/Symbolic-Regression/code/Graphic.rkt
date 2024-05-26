#lang racket

(require "util.rkt" "input.rkt" plot racket/gui)
(provide init update)

(define exp '())
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

(define (init) (send frame_ show #t))

(define (update new) 
    (set! exp new)
    (send canvas_ refresh)
)
