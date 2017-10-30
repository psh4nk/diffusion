#!/usr/bin/sbcl --script

;;; Define names to be used as variables
(defvar cube)
(defvar diff_coeff)
(defvar dimension)
(defvar gas_speed)
(defvar step_count)
(defvar dist)
(defvar change)
(defvar dterm)
(defvar clock)
(defvar rat)
(defvar N)

;;; Set up the variable to hold a 5x5 matrix
(setf cube(make-array'(10 10 10)))

; set variable values
(setq N 10)
(setq diff_coeff 0.175)
(setq dimension 5)
(setq gas_speed 250.0)
(setq step_count   (/ (/ dimension gas_speed) N))
(setq dist (/ dimension N))
(setq change 0.0)
(setq dterm   (* ( / step_count (* dist dist)) diff_coeff))
(setq clock 0.0)
(setq rat 0.0)

;;; Start the process of filling the matrix
(dotimes(i 10)
  (dotimes(j 10)
    (dotimes(k 10)
    (setf(aref cube i j k) (list i 'x j 'x k '= (* 0 0 0)))
    )
  )
)
  (loop do 
         (dotimes(i 10)
            (dotimes(j 10)
                (dotimes(k 10)
                    if(> ( - i 1 ) 1 )
                        (setf change (* ( - (aref cube i j k) (aref cube ( -  i 1  ) j k) ) dterm)))))
                         


                    
        
    while(< rat 0.99))
     
      












;; Now print out the whole thing
;(dotimes(i 5)
;  (dotimes(j 5)
;    (dotimes(k 5)
;        (print(aref cube i j k ))
;    )
;  )
;)
;(write-line " ")
