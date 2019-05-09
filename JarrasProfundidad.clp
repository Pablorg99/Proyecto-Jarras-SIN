; DFS solution for "The two Jars Problem"
; Clips 6.30
; Solution made by Pablo Rodríguez Guillén and José Márquez Doblas

; As clips will activate new rules before old rules, we dont need to control the DFS

; Define the node template that we will use for each state
(deftemplate node
      (multislot jars 
            (default j3 0 j4 0))
      (slot father
            (type FACT-ADDRESS SYMBOL)
            (allowed-symbols none)
            (default none))
      (slot level
            (type INTEGER)
            (default 0))
      (slot iteration
            (type INTEGER)
            (default 0))
)


; Initial state
; Two empty jars and Level 0
; In this case level is only used for the final print
(defrule initial
      ?aux_fact <- (initial-fact)
=>
      (assert(node (jars j3 0 j4 0) (father none) (level 0) (iteration 0)))
      (assert(globalLevel 0))
      (assert(globalIteration 0))
      (assert(final 0))
      (retract ?aux_fact)
)

; Fill 3L jar
; Generate a state with 3L in the 3L jar
; The 4L jar will remain equal
(defrule fillJar3L
      (declare (salience 300))
      ?node <- (node (jars j3 ?j3 j4 ?j4) (level ?nodeLevel))
      (test(< ?j3 3))
=>
      (assert(node (jars j3 3 j4 ?j4) (father ?node) (level (+ ?nodeLevel 1) )))
)

; Fill 4L jar
; Generate a state with 4L in the 4L jar
; The 3L jar will remain equal
(defrule fillJar4L
      (declare (salience 300))
      ?node <- (node (jars j3 ?j3 j4 ?j4) (level ?l))
      (test (< ?j4 4))
=>
      (assert(node (jars j3 ?j3 j4 4) (father ?node) (level (+ 1 ?l))))
)

; Empty 4L jar
; Generate a state with 0L in the 4L jar
; The 3L jar will reamin equal
(defrule emptyJar4L
      (declare (salience 300))
      ?node <- (node (jars j3 ?j3 j4 ?j4) (level ?l))
      (test (neq ?j4 0))
=>
      (assert(node (jars j3 ?j3 j4 0) (father ?node) (level (+ 1 ?l)))) 
)

; Empty 3L jar
; Generate a state with 0L in the 3L jar
; The 4L jar will reamin equal
(defrule emptyJar3L
      (declare (salience 300))
      ?node <- (node (jars j3 ?j3 j4 ?j4) (level ?l))
      (test (neq ?j3 0))  
=>
      (assert(node (jars j3 0 j4 ?j4) (level (+ 1 ?l)) (father ?node)))
)

; Pour 4L jar into 3L jar
; Generate a state where the 3L jar is filled with the 4L jar
; The 4L jar will be empty before this
(defrule pourJ4InJ3
      (declare (salience 300))
      ?node <- (node (jars j3 ?j3 j4 ?j4) (level ?l))
      (test (neq ?j3 3))
      (test (neq ?j4 0))
      (test (<= (- (+ ?j4 ?j3) 3) 0))
=>
      (assert(node (jars j3 (+ ?j3 ?j4) j4 0) (level (+ 1 ?l)) (father ?node)))
)

; Pour 4L jar into 3L jar
; Generate a state where the 3L jar is filled with the 4L jar
; The 4L jar will remain with the surplus
(defrule pourJ4InJ3Spill
      (declare (salience 300))
      ?node <- (node (jars j3 ?j3 j4 ?j4) (level ?l))
      (test (neq ?j3 3))
      (test (neq ?j4 0))
      (test (> (- (+ ?j4 ?j3) 3) 0))
=>
      (assert(node (jars j3 3 j4 (- (+ ?j4 ?j3) 3)) (level (+ 1 ?l)) (father ?node)))
)

; Pour 3L jar into 4L jar
; Generate a state where the 4L jar is filled with the 3L jar
; The 3L jar will be empty before this
(defrule pourJ3InJ4
      (declare (salience 300))
      ?node <- (node (jars j3 ?j3 j4 ?j4) (level ?l))
      (test (neq ?j3 0))
      (test (neq ?j4 4))
      (test (<= (- (+ ?j4 ?j3) 3) 0))
=>
      (assert(node (jars j3 0 j4 (+ ?j3 ?j4)) (level (+ 1 ?l)) (father ?node)))
)

; Pour 3L jar into 4L jar
; Generate a state where the 4L jar is filled with the 3L jar
; The 3L jar will remain with the surplus
(defrule pourJ3InJ4Spill
      (declare (salience 300))
      ?node <- (node (jars j3 ?j3 j4 ?j4) (level ?l))
      (test (neq ?j3 0))
      (test (neq ?j4 4))
      (test (> (- (+ ?j4 ?j3) 3) 0))
=>
      (assert(node (jars j3 (- (+ ?j4 ?j3) 3) j4 4) (level (+ 1 ?l)) (father ?node)))
)

; Eliminate Twins states
; Twins states are generated and have to be eliminated
(defrule eliminateTwins
      (declare (salience 2000))
      ?node <- (node (jars j3 ?j3 j4 ?j4) (level ?l) (father ?f))
      ?twinNode <- (node (jars j3 ?tj3 j4 ?tj4) (level ?tl) (father ?tf))
      (test (eq ?j4 ?tj4))
      (test (eq ?j3 ?tj3))
      (test (>= ?tl ?l))
      (test (neq ?f ?tf))
=>
      (retract ?twinNode)
)    

; Generate the Final result
; When we archieve the final state the program ends
(defrule finalResult 
      (declare (salience 3000))
      ?final <- (final 0)
      ?node <- (node (jars j3 ?j3 j4 2))
=>
      (assert(final 1))
      (retract ?final)
      (facts)
      (exit)
)