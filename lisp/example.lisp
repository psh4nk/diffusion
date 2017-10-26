#!/usr/bin/sbcl --script

;;; Define a name to be used as a variable
(defvar A)

;;; Set up the variable to hold a 5x5 matrix
(setf A(make-array'(5 5 5)))

;;; Start the process of filling the matrix
(dotimes(i 5)
  (dotimes(j 5)
    (dotimes(k 5)
    (setf(aref A i j k) (list i 'x j 'x k '= (* i j k)))
    )
  )
  )

;; Now print out the whole thing
(dotimes(i 5)
  (dotimes(j 5)
    (dotimes(k 5)
        (print(aref A i j k ))
    )
  )
)
(write-line " ")
