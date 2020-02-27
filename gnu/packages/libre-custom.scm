(define-public libre-custom
  (package
   (inherit linux-libre)
   (native-inputs
    `(("kconfig" ,(local-file "libre-custom.config"))
      ,@(alist-delete "kconfig"
                      (package-native-inputs linux-libre))))))
