(deftemplate node
      (multislot jars 
            (type INTEGER)
            (default j3 0 j4 0))
      (slot father
            (type FACT-ADDRESS SYMBOL)
            (allowed-symbols sin-padre)
            (default sin-padre))
      (slot level
            (type INTEGER)
            (default 0))
      (slot iteration
            (type INTEGER)
            (default 0))
)

(defrule inicial
      ?aux_fact <- (initial-fact)
=>
      assert(nodo)
      retract ?aux_fact
)

(defrule fillJar3L
      ?node <- (node (jars (j3 ?j3 j4 ?j4) (level ?nodeLevel))
      (globalLevel ?globalLevel)
      test(eq(?nodeLevel ?globalLevel))
      test(< ?j3 3)
=>
      assert(node (jars (j3 3 j4 ?j4) (father ?node) (level (+ ?nodeLevel 1) )))
)