#lang racket

(provide entry eval-exp evaluate cross-over make-gen mutation entry size eval-exp seed)
(require "input.rkt" "mutation.rkt" "operators.rkt")
(define entry (read-file "functions/f7.txt"))
(define size 5)


(define (match fun x y)
    (cond
        ((eq? fun '_+_) (_+_ x y))
        ((eq? fun '_-_) (_-_ x y))
        ((eq? fun '_*_) (_*_ x y))
        ((eq? fun '_/_) (_/_ x y))
        ((eq? fun '_^_) (_^_ x y))
        (#t (_lg_ x y))
    )
)


(define (eval-exp fun x y)
    (cond
        ((not (list? fun)) (cond ((eq? fun 'x) x) ((eq? fun 'y) y) (#t fun)))
        (#t (match (car fun) (eval-exp (cadr fun) x y) (eval-exp (caddr fun) x y)))
    )
)


(define (evaluate exp) (list exp (+ (depth exp) (fitness exp))))



(define (fitness expression) 
    (let ((results (map (lambda (point) 
        (let* ((predicted (eval-exp expression (car point) (cadr point))) (actual (caddr point))) (nrm (- predicted actual)))) entry))) (apply + results)
    )
)



(define (depth tree)
    (cond
        ((not (list? tree)) 0)
        (#t (+ 1 (depth (cadr tree)) (depth (caddr tree))))
    )
)






(define (make-gen)
    (define (make-h i)
        (cond
            ((zero? i) '())
            (else (cons (evaluate (seed)) (make-h (- i 1))))
        )
    )(make-h size)
)





(define (cross-over f g)
    (define (select-subtree tree)
        (cond
            ((not (list? tree)) tree)
            ((nextBool) (select-subtree (cadr tree)))
            (else (select-subtree (caddr tree)))
        )
    )

    (define (combine-trees tree1 tree2)
        (cond
            ((or (not (list? tree1)) (not (list? tree2))) (list (choose-function) tree1 tree2))
            (else (cons (cond ((nextBool) (car tree1)) (else (car tree2))) (list (combine-trees (cadr tree1) (cadr tree2)) (combine-trees (caddr tree1) (caddr tree2)))))
        )
    )

    (let* ((subtree1 (select-subtree f)) (subtree2 (select-subtree g)) (new-tree (combine-trees subtree1 subtree2)))
        (cond
            ((> (random 100) 95) (evaluate new-tree))
            (else (evaluate (mutation new-tree)))
        )
    )
)



