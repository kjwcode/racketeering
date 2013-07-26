#lang racket

(require net/head net/smtp openssl)

(define msgheader (standard-message-header "from@addr.ess"
                                           (list "to@addr.ess")
                                           (list "")
                                           (list "")
                                           "Test message"))
  
(validate-header msgheader)

(define (my-encode input-port output-port #:mode mode
                   #:encrypt [protocol 'tls]
                   #:close-original? [close-original? #t]
                   )
  (ports->ssl-ports input-port
                    output-port
                    #:mode mode
                    #:encrypt protocol
                    #:close-original? close-original?))

(define (report msg)
  (format "Failed: ~A" msg))

(with-handlers ([exn:fail? report])                   
  (smtp-send-message "mail.ser.ver" "from@addr.ess"
                     (list "to@addr.ess")
                     msgheader
                     (list "ohai!")
                     #:auth-user "username"
                     #:auth-passwd "password"
                     #:tls-encode my-encode
                     #:port-no 25))

