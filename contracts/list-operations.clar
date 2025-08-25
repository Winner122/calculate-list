;; Calculate List: List Manipulation and Computation Smart Contract
;; A flexible Clarity smart contract for performing computations on lists of unsigned integers
;; Provides utility functions for list transformations and statistical calculations

;; Error codes
(define-constant ERR-EMPTY-LIST (err u100))
(define-constant ERR-INDEX-OUT-OF-BOUNDS (err u101))
(define-constant ERR-DIVISION-BY-ZERO (err u102))
(define-constant ERR-LIST-TOO-LONG (err u103))

;; Configuration constants
(define-constant MAX-LIST-LENGTH u100)

;; Pure helper functions

;; Calculate the sum of a list of unsigned integers
(define-private (list-sum (lst (list 100 uint)))
  (fold + lst u0)
)

;; Calculate the average of a list of unsigned integers
(define-read-only (list-average (lst (list 100 uint)))
  (let (
    (list-length (len lst))
    (total-sum (list-sum lst))
  )
    (asserts! (> list-length u0) ERR-EMPTY-LIST)
    (ok (/ total-sum list-length))
  )
)

;; Find the maximum value in a list
(define-read-only (list-max (lst (list 100 uint)))
  (begin
    (asserts! (> (len lst) u0) ERR-EMPTY-LIST)
    (ok (fold max lst (unwrap-panic (element-at lst u0))))
  )
)

;; Find the minimum value in a list
(define-read-only (list-min (lst (list 100 uint)))
  (begin
    (asserts! (> (len lst) u0) ERR-EMPTY-LIST)
    (ok (fold min lst (unwrap-panic (element-at lst u0))))
  )
)

;; Public functions for list manipulations

;; Filter a list based on a predicate condition
(define-public (filter-list 
  (lst (list 100 uint)) 
  (threshold uint)
  (comparison-type (string-ascii 2))
)
  (let (
    (filtered-list 
      (if (is-eq comparison-type "gt")
        (filter (lambda (x) (> x threshold)) lst)
        (if (is-eq comparison-type "lt")
          (filter (lambda (x) (< x threshold)) lst)
          (filter (lambda (x) (is-eq x threshold)) lst)
        )
      )
    )
  )
    (ok filtered-list)
)

;; Validate the length of a list before performing computations
(define-read-only (validate-list-length (lst (list 100 uint)))
  (let (
    (list-length (len lst))
  )
    (asserts! (<= list-length MAX-LIST-LENGTH) ERR-LIST-TOO-LONG)
    (ok true)
  )
)

;; Safe element retrieval with bounds checking
(define-read-only (safe-list-get (lst (list 100 uint)) (index uint))
  (let (
    (list-length (len lst))
  )
    (asserts! (< index list-length) ERR-INDEX-OUT-OF-BOUNDS)
    (ok (unwrap-panic (element-at lst index)))
  )
)