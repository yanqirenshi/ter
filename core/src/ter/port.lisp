(in-package :ter)

(defun find-port (graph)
  (shinra:find-vertex graph 'port-ter))

(defun get-port (graph &key code)
  (car (shinra:find-vertex graph 'port-ter :slot 'code :value code)))

(defun tx-make-port (graph)
  (shinra:tx-make-vertex graph 'port-ter '()))

(defun %add-port (graph from)
  (let ((port (tx-make-port graph)))
    (shinra:tx-make-edge graph 'edge-ter from port :have)
    port))

(defgeneric add-port (graph from)
  (:method (graph (from resource))       (%add-port graph from))
  (:method (graph (from event))          (%add-port graph from))
  (:method (graph (from comparative))    (%add-port graph from))
  (:method (graph (from correspondence)) (%add-port graph from))
  (:method (graph (from recursion))      (%add-port graph from))
  (:method (graph (from recursion))      (%add-port graph from)))
