(in-package :ter)

;;;;;
;;;;; column
;;;;;
(defun get-entity-column-at-code (graph entity column-class code)
  (find-if #'(lambda (r)
               (let ((vertex (getf r :vertex)))
                 (string= code (code vertex))))
           (shinra:find-r graph 'edge-ter
                          :from entity
                          :vertex-class column-class
                          :edge-type :have-to)))

;;;;;
;;;;; identifier
;;;;;
(defun get-entity-identifier-at-code (graph entity code)
  (get-entity-column-at-code graph entity 'identifier-instance code))

(defun assert-not-exist-entity-identifier (graph entity &key code)
  (when (get-entity-identifier-at-code graph entity code)
    (error "aledy exist relationship of entity to identifier")))

(defun find-entity-identifiers (graph entity &key edge-type)
  (shinra:find-r-vertex graph
                        'edge-ter
                        :from entity
                        :edge-type edge-type
                        :vertex-class 'identifier-instance))

(defun get-native-identifier (graph entity)
  (assert graph)
  (assert entity)
  (car (find-entity-identifiers graph entity
                                :edge-type :have-to-native)))

(defun assert-not-exist-native-identifier (graph entity type)
  (when (eq :native type)
    (when (get-native-identifier graph entity)
      (error "Aledy have native identifier."))))

(defun get-identifier-edge-type (type)
  (cond ((eq :native    type) :have-to-native)
        ((eq :foreigner type) :have-to-foreigner)
        (t (error "Not supported yet. type=~S" type))))

(defgeneric assert-entity-identifier-type (entity type)
  (:method ((entity resource) type)
    (unless (eq :native type)
      (error "Invalid type. entity=~S, type=~S" entity type)))
  (:method ((entity event) type)
    (unless (or (eq :native type) (eq :foreigner type))
      (error "Invalid type. entity=~S, type=~S" entity type)))
  (:method ((entity correspondence) type)
    (unless (eq :foreigner type)
      (error "Invalid type. entity=~S, type=~S" entity type)))
  (:method ((entity recursion) type)
    (unless (eq :foreigner type)
      (error "Invalid type. entity=~S, type=~S" entity type)))
  (:method ((entity comparative) type)
    (unless (eq :foreigner type)
      (error "Invalid type. entity=~S, type=~S" entity type)))
  (:method (entity type)
    (error "Invalid entity. entity=~S, type=~S" entity type)))

(defgeneric tx-add-identifier (graph entity identifier &key type)
  (:method (graph (entity entity) (identifier identifier-instance) &key (type :native))
    (assert-entity-identifier-type entity type)
    (assert-not-exist-native-identifier graph entity type)
    (assert-not-exist-entity-identifier graph entity :code (code identifier))
    (let ((edge-type (get-identifier-edge-type type)))
      (values identifier
              entity
              (shinra:tx-make-edge graph 'edge-ter entity identifier edge-type))))

  (:method (graph (entity entity) (params list) &key (type :native))
    (let ((code (getf params :code))
          (name (getf params :name))
          (data-type (getf params :data-type)))
      (assert-not-exist-entity-identifier graph entity :code code)
      (tx-add-identifier graph
                         entity
                         (tx-make-identifier-instance graph code name data-type)
                         :type type))))


;;;;;
;;;;; attribute
;;;;;
(defun get-entity-attribute-at-code (graph entity code)
  (get-entity-column-at-code graph entity 'attribute-instance code))

(defun assert-not-exist-entity-attribute (graph entity &key code)
  (when (get-entity-attribute-at-code graph entity code)
    (error "aledy exist relationship of entity to attribute")))

(defgeneric tx-add-attribute (graph entity attribute)
  (:method (graph (entity entity) (attribute attribute-instance))
    (assert-not-exist-entity-attribute graph entity :code (code attribute))
    (values attribute
            entity
            (shinra:tx-make-edge graph 'edge-ter entity attribute :have-to-native)))

  (:method (graph (entity entity) (attribute attribute))
    (assert-not-exist-entity-attribute graph entity :code (code attribute))
    (tx-add-attribute graph entity (list :code      (code attribute)
                                         :name      (name attribute)
                                         :data-type (data-type attribute))))

  (:method (graph (entity entity) (params list))
    (let ((code (getf params :code))
          (name (getf params :name))
          (data-type (getf params :data-type)))
      (assert-not-exist-entity-attribute graph entity :code code)
      (tx-add-attribute graph entity
                        (tx-make-attribute-instance graph code name data-type)))))


;;;;;
;;;;; port-ter
;;;;;
(defgeneric tx-add-port-ter (entity port-ter)
  (:method ((entity entity) (port-ter port-ter))
    (list entity port-ter)))


;;;;;
;;;;;
;;;;;
(defgeneric tx-build-identifier (graph type code name)
  (:method (graph (type symbol) (code symbol) (name string))
    (assert (and graph type code name))
    (assert (or (eq :ev type) (eq :rs type)))
    (flet ((str2keyword (str)
             (alexandria:make-keyword (string-upcase str))))
      (let* ((identifier-code-str (concatenate 'string (symbol-name code) "-id"))
             (identifier-code     (str2keyword identifier-code-str))
             (identifier-name     (concatenate 'string name "ID"))
             (identifier-data-type :integer)
             (identifier-instance-code :id)
             (entity-code code))
        (let ((identifier          (tx-make-identifier graph
                                                       identifier-code
                                                       identifier-name
                                                       identifier-data-type))
              (identifier-instance (tx-make-identifier-instance graph
                                                                identifier-instance-code
                                                                identifier-name
                                                                identifier-data-type))
              (entity (if (eq :rs type)
                          (tx-make-resource graph entity-code name)
                          (tx-make-event    graph entity-code name))))
          (declare (ignore identifier)) ;; TODO; create identifier to identifier-instance
          (tx-add-identifier graph entity identifier-instance :type :native))))))

;; (let ((graph (get-campus-graph (get-campus ter.db:*graph* :code "MANAGEMENT"))))
;;   (mapcar #'(lambda (data)
;;               (tx-build-identifier graph
;;                                    (getf data :type)
;;                                    (getf data :code)
;;                                    (getf data :name)))
;;           '((:type :rs :code :company                          :name "会社")
;;             (:type :rs :code :project                          :name "プロジェクト")
;;             (:type :rs :code :proposition                      :name "案件")
;;             (:type :rs :code :resource                         :name "リソース")
;;             (:type :rs :code :duty                             :name "職責")
;;             (:type :rs :code :manage-order-proposition-item    :name "案件の発注管理項目")
;;             (:type :rs :code :manage-plan-proposition-item     :name "案件の予定管理項目")
;;             (:type :rs :code :manage-resource-proposition-item :name "案件のリソース管理項目")
;;             (:type :ev :code :assign-project                   :name "プロジェクトへの担当者割当")
;;             (:type :ev :code :assign-proposition               :name "案件への担当者割当")
;;             (:type :ev :code :manage-order-proposition         :name "案件の発注管理")
;;             (:type :ev :code :manage-order-proposition-dtl     :name "案件の発注管理明細")
;;             (:type :ev :code :manage-plan-proposition          :name "案件の予定管理")
;;             (:type :ev :code :manage-plan-proposition-dtl      :name "案件の予定管理明細")
;;             (:type :ev :code :manage-resouce-proposition       :name "案件のリソース管理")
;;             (:type :ev :code :manage-resouce-proposition-dtl   :name "案件のリソース管理明細")
;;             (:type :ev :code :proposition-estimate             :name "案件の見積")
;;             (:type :ev :code :proposition-estimate-dtl         :name "案件の見積明細")
;;             (:type :ev :code :resource-estimate                :name "リソースの見積"))))


;;;;;
;;;;; 
;;;;;
(defgeneric tx-add-attributes (graph entity attr-data-list)
  (:method (graph (entity entity) (attr-data-list list))
    (dolist (attr-data attr-data-list)
      (let* ((code (getf attr-data :code))
             (attribute (or (get-attribute graph :code code)
                            (tx-make-attribute graph
                                               code
                                               (getf attr-data :name)
                                               (getf attr-data :data-type)))))
        (tx-add-attribute graph entity attribute)))))


;; (let ((graph (get-campus-graph (get-campus ter.db:*graph* :code "GLPGS"))))
;;   (tx-add-attributes graph
;;                      (get-event graph :code :resource-estimate)
;;                      '((:code :amount             :name "数量"           :data-type :integer)
;;                        (:code :unit               :name "単位"           :data-type :string)
;;                        (:code :valid-period-start :name "有効期間(開始)" :data-type :timestamp)
;;                        (:code :valid-period-end   :name "有効期間(終了)" :data-type :timestamp)
;;                        (:code :description        :name "備考"           :data-type :text))))
