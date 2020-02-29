(define-module (mnd services irssi)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu packages wireguard)
  #:use-module (gnu packages screen)
  #:use-module (guix gexp)
  #:use-module (guix records)
  #:use-module (ice-9 match)
  #:export (wireguard-service))

(define-record-type* <wireguard-configuration>
  wireguard-configuration
  make-wireguard-configuration
  wireguard-configuration?
  (package wireguard-configuration-package
           (default wireguard))
  (ruleset wireguard-configuration-ruleset ; file-like object
           ))

define wireguard-shepherd-service
  (match-lambda
    (($ <wireguard-configuration> package ruleset)
     (let ((wireguard (file-append package "/bin/wg-quick")))
       (shepherd-service
        (documentation "Wireguard VPN service")
        (provision '(wireguard))
        (start #~(lambda _
                   (invoke #$wireguard "up" #$ruleset)))
        (stop #~(lambda _
                  (invoke #$wireguard "down" #$ruleset))))))))

(define wireguard-service-type
  (service-type
   (name 'wireguard)
   (description
    "Run @command{wireguard}, setting up the specified ruleset.")
   (extensions
    (list (service-extension shepherd-root-service-type
                             (compose list wireguard-shepherd-service))
          (service-extension profile-service-type
                             (compose list wireguard-configuration-package))))
   ))
