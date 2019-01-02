(in-package :ter)

(defclass edge-ter (shinra:ra) ())

(defmethod jojo:%to-json ((obj edge-ter))
  (jojo:with-object
    (jojo:write-key-value "_id"        (slot-value obj 'up:%id))
    (jojo:write-key-value "from_id"    (slot-value obj 'shinra:from-id))
    (jojo:write-key-value "from_class" (slot-value obj 'shinra:from-class))
    (jojo:write-key-value "to_id"      (slot-value obj 'shinra:to-id))
    (jojo:write-key-value "to_class"   (slot-value obj 'shinra:to-class))
    (jojo:write-key-value "data_type"  (slot-value obj 'shinra:edge-type))
    (jojo:write-key-value "_class"     'edge-er)))
