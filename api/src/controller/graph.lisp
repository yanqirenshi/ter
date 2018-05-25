(in-package :ter.api.controller)

(defun find-graph ()
  (let ((graph ter.db:*graph*))
    (list :nodes (nconc '()
                        (find-ter-all-nodes graph)
                        (find-er-all-nodes))
          :edges (nconc '()
                        (ter:find-ter-all-edges graph)
                        (ter:find-er-all-edges graph)
                        (ter:find-mapping-all-edges graph)))))