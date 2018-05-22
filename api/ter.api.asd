#|
  This file is a part of ter.api project.
|#

(defsystem "ter.api"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "package")
                 (:file "render")
                 (:file "router")
                 (:module "controller" :components ((:file "package"))))))
  :description ""
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "ter.api-test"))))
