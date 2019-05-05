
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