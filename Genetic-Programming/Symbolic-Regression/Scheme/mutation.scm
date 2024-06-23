#lang racket

(require "operators.scm")
(provide mutation seed)


(define (seed)
    (define (seed-h exp)
        (cond
            ((nextBool) exp)
            (else (cond ((nextBool) (list (choose-function) exp (seed))) (else (list (choose-function) (seed) exp))))
        )
    )(seed-h (list (choose-function) (choose-consvar) (choose-consvar)))
)

(define (replace-subtree tree target replacement)
    (cond
        ((eq? tree target) replacement)
        ((not (list? tree)) tree)
        (#t (list (car tree) 
            (replace-subtree (cadr tree) target replacement) 
            (replace-subtree (caddr tree) target replacement))
        )
    )
)

(define (select-subtree tree)
    (cond
        ((or (not (list? tree)) (nextBool)) tree)
        ((nextBool) (select-subtree (cadr tree)))
        (else (select-subtree (caddr tree)))
    )
)




(define (change-point node)
    (cond
        ((number? node) (+ node (- (random 2) 1)))
        ((or (eq? node 'x) (eq? node 'y))(choose-consvar))
        (#t node)
    )
)


(define (change-function node)
    (cond
        ((and (list? node) (not (null? node))) (list (choose-function) (cadr node) (caddr node)))
        (#t node)
    )
)


(define (change-terminal node)
    (cond
        ((or (number? node) (eq? node 'x) (eq? node 'y)) (choose-consvar))
        (#t node)
    )
)


(define (mutate-terminal tree)
    (cond
        ((not (list? tree)) (change-terminal tree))
        (#t (list (car tree) (mutate-terminal (cadr tree)) (mutate-terminal (caddr tree))))
    )
)



(define (mutate-subtree tree)
    (cond
        ((or (not (list? tree)) (nextBool)) (seed))
        (#t (cond
            ((nextBool) (list (car tree) (mutate-subtree (cadr tree)) (caddr tree)))
            (#t (list (car tree) (cadr tree) (mutate-subtree (caddr tree)))))
        )
    )
)



(define (mutate-function tree)
    (cond
        ((not (list? tree)) tree)
        (#t (cond
            ((nextBool) (change-function tree))
            (#t (list (car tree) (mutate-function (cadr tree)) (mutate-function (caddr tree)))))
        )
    )
)



(define (mutate-hoist tree)
    (cond
        ((or (not (list? tree)) (nextBool)) tree)
        (#t (cond
            ((nextBool) (select-subtree (cadr tree)))
            (#t (select-subtree (caddr tree))))
        )
    )
)


(define (mutate-point tree) 
    (cond
        ((not (list? tree)) (change-point tree))
        (#t (list (car tree) (mutate-point (cadr tree)) (mutate-point (caddr tree))))
    )
)



(define (mutate-internal-crossover tree)
    (let ((subtree1 (select-subtree tree)) (subtree2 (select-subtree tree)))
        (replace-subtree (replace-subtree tree subtree1 subtree2) subtree2 subtree1)
    )
)



(define (mutation tree)
    (define (mut-h prob)
        (cond
            ((= prob 0) (mutate-internal-crossover tree))
            ((= prob 1) (mutate-terminal tree))
            ((= prob 2) (mutate-hoist tree))
            ((= prob 3) (mutate-point tree))
            ((= prob 4) (mutate-subtree tree))
            (#t (mutate-function tree))
        )
    )(mut-h (random 6))
)
