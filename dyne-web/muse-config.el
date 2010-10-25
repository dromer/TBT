;; Emacs MUSE

(provide 'muse-web-tbt)


;; Initialize
;(require 'outline)       ; If you like outline-style faces
(require 'muse)          ; load generic module

(require 'muse-mode)     ; load authoring mode
(require 'muse-colors)   ; load coloring/font-lock module
(require 'muse-project)  ; load support for projects
(require 'muse-book)
(require 'muse-context)  ; texlive publishing
(require 'muse-journal)   ; load journal publishing style
(require 'muse-docbook)   ; load DocBook publishing style
(require 'muse-html)      ; load (X)HTML publishing style
(require 'muse-xml)      ; load XML support
(require 'muse-latex)     ; load LaTeX/PDF publishing styles
(require 'muse-latex2png) ; publish <latex> tags
(require 'muse-texinfo)   ; load Info publishing style


(require 'muse-wiki)     ; load Wiki support
;(require 'muse-ikiwiki)  ; load ikiwiki export support

;;(require 'muse-message)  ; load message support (experimental)
;;(require 'atom-api) ; atom api for muse

;; -----------
;; Styles


;; ---- jaromil's musings

(muse-derive-style "tbt-webpage-html" "html"
		   :author "Jaromil"
		   :header "~/devel/tbt/dyne-web/templates/header.html"
		   :footer "~/devel/tbt/dyne-web/templates/footer.html"
		   :base-url "http://tbt.dyne.org")

(muse-derive-style "tbt-webpage-pdf" "pdf"
		   :author "Jaromil"
		   :header "~/devel/tbt/dyne-web/templates/header.tex"
		   :footer "~/devel/tbt/dyne-web/templates/footer.tex"
		   :base-url "http://tbt.dyne.org")



(setq muse-project-alist
      `(

	("TBT"
	 (,@(muse-project-alist-dirs "pages")
	  )
         ;; Publish this directory and its subdirectories.  Arguments
         ;; are as follows.  The above `muse-project-alist-dirs' part
         ;; is also needed.
         ;;   1. Source directory
         ;;   2. Output directory
         ;;   3. Publishing style
         ;;   remainder: Other things to put in every generated style

         ,@(muse-project-alist-styles "pages"
                                      "pub"
                                      "tbt-webpage-html")

         ,@(muse-project-alist-styles "pages"
                                      "pub"
                                      "tbt-webpage-pdf")

	 )
	
	)
      )


;; Wiki settings
(setq muse-wiki-interwiki-alist
      '(("Lab.Dyne" . "http://lab.dyne.org/")
        ("EmacsWiki" . "http://www.emacswiki.org/cgi-bin/wiki/")
	))

;;; Functions


;; Turn relative links into absolute ones
(defun cb-make-links-absolute (str &rest ignored)
  "Make relative links absolute."
  (when str
    (save-match-data
      (if (string-match "\\`[/.]+" str)
          (replace-match "http://jaromil.dyne.org/journal/" nil t str)
        str))))
(defun make-links-absolute ()
  (set (make-local-variable 'muse-publish-url-transforms)
       (cons 'cb-make-links-absolute muse-publish-url-transforms)))

;; Use hires images in documents
(defun cb-make-images-hires (str &res ignored)
  "Make images hi resulution."
  (when str
    (save-match-data
      (if (string-match "fotos/.*" str)
	  (replace-match "fotos/hires/" nil t str)
	str))))
(defun make-images-hires()
  (set (make-local-variable 'muse-publish-url-transforms)
       (cons 'cb-make-images-hires muse-publish-url-transforms)))
       
(defun muse-insert-reset-chapter ()
  (insert "\n\\setcounter{chapter}{1}\n"))


;; Turn a word or phrase into a clickable Wikipedia link
(defun my-muse-dictize (beg end)
  (interactive "r")
  (let* ((text (buffer-substring-no-properties beg end))
         (link (concat "dict:" (replace-regexp-in-string " " "_" text t t))))
    (delete-region beg end)
    (insert "[[" link "][" text "]]")))

;;; turn urls into html
(defun url-convert-muse-to-html ()
  (interactive)
  "Convert urls in documents from Muse format to HTML"
  (replace-string "[[" "<a href=\"")
  (replace-string "][" "\">")
  (replace-string "]]" "</a>")
)


;;; Skinning my Muse

(custom-set-faces
 '(muse-bad-link ((t (:foreground "DeepPink" :underline "DeepPink" :weight bold)))))

(custom-set-variables
 '(muse-latex-permit-contents-tag t)
 '(muse-colors-autogen-headings (quote outline))
 '(muse-colors-inline-image-method (quote muse-colors-use-publishing-directory))
 '(muse-mode-hook (quote (flyspell-mode footnote-mode)))
 '(muse-publish-comments-p nil)

; LINKS
 ;; '(muse-publish-desc-transforms
 ;;   (quote (muse-wiki-publish-pretty-title
 ;; 	   muse-wiki-publish-pretty-interwiki
 ;; 	   muse-publish-strip-URL)))
 ;; '(muse-wiki-publish-small-title-words
 ;;   (quote ("the" "and" "at" "on" "of" "for" "in" "an" "a" "page")))

; HTML
 '(muse-html-charset-default "utf-8")
 '(muse-html-encoding-default (quote utf-8))
 '(muse-html-meta-content-encoding (quote utf-8))
 '(muse-html-footer "templates/footer.html")
 '(muse-html-header "templates/header.html")
 '(muse-html-style-sheet
   "<link rel=\"stylesheet\" type=\"text/css\" charset=\"utf-8\" media=\"all\"
          href=\"stylesheet/dyne.css\" />
    <link rel=\"stylesheet\" type=\"text/css\" charset=\"utf-8\" media=\"screen\"
          href=\"stylesheet/screen.css\" />
    <link rel=\"stylesheet\" type=\"text/css\" charset=\"utf-8\" media=\"print\"
          href=\"stylesheet/print.css\" />")
 '(muse-html-table-attributes " class=\"muse-table\" border=\"0\" cellpadding=\"5\"")

 ;; RSS should not summarize but include the whole entry
 '(muse-journal-rss-summarize-entries nil)

; RSS feed
;  '(muse-journal-rss-entry-template "
;     <item>
;;       <title>%title%</title>
;       <link>%link%#%anchor%</link>
;       <author>Jaromil</author>
;       <pubDate>%date%</pubDate>
;       <guid>%link%#%anchor%</guid>
;       %enclosure%
;     </item>
; ")

; LATEX
 '(muse-latex-footer "templates/footer.tex")
 '(muse-latex-header "templates/header.tex")
 '(muse-latex-permit-contents-tag t)
 '(muse-latex-twocolumn t)

; XHTML
 '(muse-xhtml-footer "templates/footer.html")
 '(muse-xhtml-header "templates/header.html")
 '(muse-xhtml-meta-content-encoding (quote utf-8))
 '(muse-xhtml-style-sheet
   "<link rel=\"stylesheet\" type=\"text/css\" charset=\"utf-8\" media=\"all\"
          href=\"css/common.css\" />
    <link rel=\"stylesheet\" type=\"text/css\" charset=\"utf-8\" media=\"screen\"
          href=\"css/screen.css\" />
    <link rel=\"stylesheet\" type=\"text/css\" charset=\"utf-8\" media=\"print\"
          href=\"css/print.css\" />")


)

;;;; fixes to markup?
;(defvar muse-latex-markup-strings
;  '((url-and-desc    . "\\url{%s}")
;    (link            . "\\url{%s}")
;    (link-and-anchor . "\\url{%s}"))
;    )
