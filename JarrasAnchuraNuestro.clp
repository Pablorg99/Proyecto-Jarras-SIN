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
      assert(Global_level 0)
      assert(Global_iteration 0)
      retract ?aux_fact
)


; This rule will be the last to be activated
; It 

