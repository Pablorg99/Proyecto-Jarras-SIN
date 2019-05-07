(deftemplate nodo
      (multislot estado
            (type INTEGER)
            (default 0 0))
      (slot padre
            (type FACT-ADDRESS SYMBOL)
            (allowed-symbols sin-padre)
            (default sin-padre))
      (slot nivel
            (type INTEGER)
            (default 0))
      (slot iteracion
            (type INTEGER)
            (default 0))
)


; Initial state (Two empty jars)
(defrule initial
      ?aux_fact <- (initial-fact)
=>
      assert(node (state 0 0) (father none) (level 0) (iteration 0))
      assert(globalLevel 0)
      assert(globalIteration 0)
      assert(final 0)
      retract ?aux_fact
)


; This rule will be the last to be activated when a level is completed
(defrule increaseLevel
      (declare (salience 100))
      ?level <- (globalLevel ?l)
=>
      retract ?level
      assert(globalLevel (+ ?l 1))
)


; Generate state
(defrule fillJar4L
      (declare (salience 300))
      ?node <- node (state j3 ?j3 j4 ?j4) (level ?l))
      ?level <- (globalLevel ?gl)
      (test (eq ?gl ?l))
      (test (< ?j4 4))
=>
      assert(node (state j3 ?j3 j4 4) (level (+ 1 ?l)) (father ?node))
)






