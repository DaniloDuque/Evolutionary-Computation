#lang racket

(require "util.scm" plot racket/gui)
(provide init update)

(define exp '())
(define frame_ (new frame% [label "Aproximated Function"] [width 800] [height 600]))

(define canvas_
    (new canvas%
        [parent frame_]
        [paint-callback
            (lambda (canvas dc)
                (send dc draw-bitmap
                (plot3d-bitmap (list
                (surface3d (λ (x y) (eval-exp exp x y)) -10 25 -10 25)
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
