(defpackage ter
  (:use #:cl
        #:ter.db)
  (:import-from :alexandria
                #:when-let
                #:make-keyword)
  (:import-from :shinra
                #:find-vertex
                #:tx-make-vertex
                #:tx-make-edge)
  (:export #:*graph-stor-dir*
           #:*campus-directory-root*
           #:*schema-directory-root*)
  (:export #:tx-create-system
           #:get-system
           #:find-systems
           #:get-to-camera
           #:find-camera
           #:get-camera
           #:find-force
           #:get-force)
  ;; er
  (:export #:get-schema
           #:find-table
           #:find-column
           #:find-column-instance
           #:find-er-all-edges
           #:find-er-cameras)
  ;; ter
  (:export #:get-campus
           #:get-campus-graph
           #:tx-update-camera-look-at
           #:tx-update-camera-magnification
           #:tx-make-relationship
           #:get-entity
           #:find-schema
           #:find-campus
           #:find-resource
           #:find-event
           #:find-correspondence
           #:find-comparative
           #:find-recursion
           #:find-entities
           #:find-attribute
           #:find-attribute-instance
           #:find-identifier
           #:find-identifier-instance
           #:find-ter-all-edges
           #:find-entity-identifiers
           #:find-identifier-ports
           #:tx-build-identifier)
  ;; modeler
  (:export #:tx-make-modeler-with-ghost
           #:get-modeler)
  (:export #:find-mapping-all-edges))
(in-package :ter)
