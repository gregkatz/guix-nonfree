(use-modules (guix packages)
	     (guix build utils)
	     (gnu packages vpn)
	     (guix build gnu-build-system)
	     )
(package (inherit wireguard-tools)
;	 (arguments
;	  `(#:phases
;	    (modify-phases %standard-phases
;			   (delete 'configure)
;			   (add-after 'unpack 'fix
;				      (lambda _
;					(substitute* "./src/wg-quick/linux.bash"
;						     ((" ") "L"))
					;					#t)))))

	 (arguments
     `(#:make-flags
       (list "CC=gcc"
             "--directory=src"
             "WITH_BASHCOMPLETION=yes"
             ;; Install the ‘simple and dirty’ helper script wg-quick(8).
             "WITH_WGQUICK=yes"
             (string-append "PREFIX=" (assoc-ref %outputs "out"))
             ;; Currently used only to create an empty /etc/wireguard directory.
             (string-append "SYSCONFDIR=no-thanks"))
       ;; The test suite is meant to be run interactively.  It runs Clang's
       ;; scan-build static analyzer and then starts a web server to display the
       ;; results.
       #:tests? #f
       #:phases
       (modify-phases %standard-phases
		      ;; No configure script
		      (add-after 'unpack 'fix
				 (lambda _
				   (substitute* "./src/wg-quick/linux.bash"
						((" ") "L"))
				   #t))
		      (delete 'configure))))
	 )
