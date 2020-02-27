(define-module (gnu packages linux-nonfree)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages tls)
  #:use-module (guix build-system trivial)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix download))

(define-public libre-custom
  (package
   (inherit linux-libre)
   (native-inputs
    `(("kconfig" ,(local-file "libre-custom.config"))
      ,@(alist-delete "kconfig"
                      (package-native-inputs linux-libre))))))
