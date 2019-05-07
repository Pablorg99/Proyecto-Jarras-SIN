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


; Initial jars (Two empty jars)
(defrule initial
      ?aux_fact <- (initial-fact)
=>
      (assert(node (jars j3 0 j4 0) (father none) (level 0) (iteration 0)))
      (assert(globalLevel 0))
      (assert(globalIteration 0))
      (assert(final 0))
      (retract ?aux_fact)
)

; This rule will be the last to be activated when a level is completed
(defrule increaseLevel
      (declare (salience 100))
      ?level <- (globalLevel ?l)
      (final 0)
=>
      (retract ?level)
      (assert(globalLevel (+ ?l 1)))
)

; Generate state
(defrule fillJar3L
      (declare (salience 300))
      ?node <- (node (jars j3 ?j3 j4 ?j4) (level ?nodeLevel))
      (globalLevel ?globalLevel)
      (test(eq ?nodeLevel ?globalLevel))
      (test(< ?j3 3))
=>
      (assert(node (jars j3 3 j4 ?j4) (father ?node) (level (+ ?nodeLevel 1) )))
)

; Generate state
(defrule fillJar4L
      (declare (salience 300))
      ?node <- (node (jars j3 ?j3 j4 ?j4) (level ?l))
      (globalLevel ?gl)
      (test (eq ?gl ?l))
      (test (< ?j4 4))
=>
      (assert(node (jars j3 ?j3 j4 4) (father ?node) (level (+ 1 ?l))))
)

; Generate state
(defrule emptyJar4L
      (declare (salience 300))
      ?node <- (node (jars j3 ?j3 j4 ?j4) (level ?l))
      ?level <- (globalLevel ?gl)
      (test (eq ?gl ?l))
      (test (neq ?j4 0))
=>
      (assert(node (jars j3 ?j3 j4 0) (father ?node) (level (+ 1 ?l)))) 
)

; Generate state
(defrule emptyJar3L
      (declare (salience 300))
      ?node <- (node (jars j3 ?j3 j4 ?j4) (level ?l))
      (globalLevel ?gl)
      (test (eq ?gl ?l))
      (test (neq ?j3 0))  
=>
      (assert(node (jars j3 0 j4 ?j4) (level (+ 1 ?l)) (father ?node)))
)

; Generate state
(defrule pourJ4InJ3
      (declare (salience 300))
      ?node <- (node (jars j3 ?j3 j4 ?j4) (level ?l))
      (globalLevel ?gl)
      (test (eq ?gl ?l))
      (test (neq ?j3 3))
      (test (neq ?j4 0))
      (test (<= (- (+ ?j4 ?j3) 3) 0))
=>
      (assert(node (jars j3 (+ ?j3 ?j4) j4 0) (level (+ 1 ?l)) (father ?node)))
)

; Generate state
(defrule pourJ4InJ3Spill
      (declare (salience 300))
      ?node <- (node (jars j3 ?j3 j4 ?j4) (level ?l))
      (globalLevel ?gl)
      (test (eq ?gl ?l))
      (test (neq ?j3 3))
      (test (neq ?j4 0))
      (test (> (- (+ ?j4 ?j3) 3) 0))
=>
      (assert(node (jars j3 3 j4 (- (+ ?j4 ?j3) 3)) (level (+ 1 ?l)) (father ?node)))
)

; Generate state
(defrule pourJ3InJ4
      (declare (salience 300))
      ?node <- (node (jars j3 ?j3 j4 ?j4) (level ?l))
      (globalLevel ?gl)
      (test (eq ?gl ?l))
      (test (neq ?j3 0))
      (test (neq ?j4 4))
      (test (<= (- (+ ?j4 ?j3) 3) 0))
=>
      (assert(node (jars j3 0 j4 (+ ?j3 ?j4)) (level (+ 1 ?l)) (father ?node)))
)

; Generate state
(defrule pourJ3InJ4Spill
      (declare (salience 300))
      ?node <- (node (jars j3 ?j3 j4 ?j4) (level ?l))
      (globalLevel ?gl)
      (test (eq ?gl ?l))
      (test (neq ?j3 0))
      (test (neq ?j4 4))
      (test (> (- (+ ?j4 ?j3) 3) 0))
=>
      (assert(node (jars j3 (- (+ ?j4 ?j3) 3) j4 4) (level (+ 1 ?l)) (father ?node)))
)

; Eliminate Twins
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