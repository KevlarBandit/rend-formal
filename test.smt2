(set-logic QF_LIA)
(assert (not (= (+ x y) (+ y x))))
(check-sat)
