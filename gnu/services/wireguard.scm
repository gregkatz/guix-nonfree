(define-module (gnu services wireguard)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu packages screen)
  #:use-module (guix gexp)
  #:use-module (guix records)
  #:use-module (ice-9 match)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services shepherd)
  #:use-module (gnu services dbus)
  #:use-module (gnu system shadow)
  #:use-module (gnu system pam)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages connman)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages tor)
  #:use-module (gnu packages usb-modeswitch)
  #:use-module (gnu packages messaging)
  #:use-module (gnu packages networking)
  #:use-module (gnu packages ntp)
  #:use-module (gnu packages wicd)
  #:use-module (gnu packages gnome)
  #:use-module (guix gexp)
  #:use-module (guix records)
  #:use-module (guix modules)
  #:use-module (guix packages)
  #:use-module (guix deprecation)
  #:use-module (rnrs enums)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-26)
  #:use-module (ice-9 match)
  #:export (wireguard-service-type
	    wireguard-configuration
	    wireguard-configuraation-package
	    wireguard-configuraation-ruleset
	    ))

(define-record-type* <wireguard-configuration> wireguard-configuration make-wireguard-configuration
  wireguard-configuration?
  (package wireguard-configuration-package
           (default wireguard))
  (ruleset wireguard-configuration-ruleset ; file-like object
           ))

(define wireguard-shepherd-service
  (match-lambda
   (($ <wireguard-configuration> package ruleset)
    (display package)
    (let ((wireguard "/bin/wg-quick"))
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
