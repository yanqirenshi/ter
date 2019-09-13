(in-package :ter.api.controller)

(defclass campus ()
  ((%id         :accessor %id         :initarg :%id         :initform nil)
   (code        :accessor code        :initarg :code        :initform nil)
   (name        :accessor name        :initarg :name        :initform nil)
   (description :accessor description :initarg :description :initform nil)
   (cameras     :accessor cameras     :initarg :cameras     :initform nil)))

(defmethod jojo:%to-json ((obj campus))
  (jojo:with-object
    (jojo:write-key-value "_id"             (slot-value obj '%id))
    (jojo:write-key-value "code"            (slot-value obj 'code))
    (jojo:write-key-value "name"            (slot-value obj 'name))
    (jojo:write-key-value "description"     (or (slot-value obj 'description) ""))
    (jojo:write-key-value "cameras"         (or (slot-value obj 'cameras) nil))
    (jojo:write-key-value "_class"          "CAMPUS")))

(defun campus2campus (campus &key graph modeler)
  (let ((new-campus (make-instance 'campus)))
    (setf (%id new-campus)         (up:%id campus))
    (setf (name new-campus)        (ter::name campus))
    (setf (code new-campus)        (ter::code campus))
    (setf (description new-campus) (ter::description campus))
    (when (and graph modeler)
      (setf (cameras new-campus)
            (mapcar #'(lambda (camera)
                        (list :|owner| (modeler2modeler modeler)
                              :|camera| camera))
                    (ter:find-ter-cameras graph :campus campus :modeler modeler))))
    new-campus))
