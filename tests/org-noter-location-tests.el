(add-to-list 'load-path "modules")
(require 'org-noter-test-utils)

(defvar mock-contents-simple-notes-file-with-locations
  "
:PROPERTIES:
:ID:       FAKE_1
:END:
#+TITLE: Test book notes (simple)
* solove-nothing-to-hide
:PROPERTIES:
:NOTER_DOCUMENT: pubs/solove-nothing-to-hide.pdf
:END:
** Heading1
:PROPERTIES:
:NOTER_PAGE: 40
:END:
** Heading2
:PROPERTIES:
:NOTER_PAGE: (41 0.09 . 0.16)
:HIGHLIGHT: #s(pdf-highlight 41 ((0.18050847457627117 0.09406231628453851 0.6957627118644067 0.12110523221634333)))
:END:
#+BEGIN_QUOTE
Test
#+END_QUOTE

")




(describe "org-noter locations"
          (before-each
           (create-org-noter-test-session)
           )

          (describe "basic location parsing works"
                    (describe "page locations"
                              (it "can parse a page location"
                                  (with-mock-contents
                                   mock-contents-simple-notes-file-with-locations
                                   '(lambda ()
                                      (org-noter-core-test-create-session)
                                      (search-forward "Heading2")
                                      (expect (org-noter--get-containing-heading) :not :to-be nil)
                                      (expect (org-noter--parse-location-property (org-noter--get-containing-element)) :to-equal (read "(41 0.09 . 0.16)"))
                                      )

                                   ))

                              )

                    )

          (describe "navigation functions"
                    (before-each
                     (add-to-list 'org-noter--doc-goto-location-hook #'org-noter-location-test-goto-location)
                     (spy-on 'org-noter-location-test-goto-location :and-return-value t)
                     )

                    (it "goto-location-hook works"
                        (with-mock-contents
                         mock-contents-simple-notes-file-with-locations
                         '(lambda ()
                            (org-noter-core-test-create-session)
                            (search-forward "Heading2")
                            (org-noter-sync-current-note)
                            ;; (expect 'org-noter-location-test-goto-location :to-have-been-called)
                            )

                         ))




                    )
          )
