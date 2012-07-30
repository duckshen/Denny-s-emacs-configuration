;; -*- coding: utf-8 -*-
;; File: signature-motto.el
;;
;; Author: Denny Zhang(markfilebat@126.com)
;; Created: 2008-10-01
;; Updated: Time-stamp: <2012-07-30 11:15:42>
;;
;; --8<-------------------------- separator ------------------------>8--
(setq common-tail-signature "Denny Zhang(张巍)
邮箱: markfilebat@126. com
微博: http://weibo.com/1686664253
博客: http://blog.ec-ae.com/")
(defun get-mail-signature ()
  (format "%s\n\n%s" common-tail-signature (generate-mail-signature)))
(defun get-short-mail-signature ()
  (format "%s\n\n%s" "Denny Zhang(张巍)" (generate-mail-signature)))
(defun generate-mail-signature()
  (let* ((signature-string (get-motto))
         cowsay-file
         command-string)
    ;; cowsay doesn't support Unicode in release version
    ;; see http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=254557
    (if (member (detect-coding-string signature-string)
                '((undecided-unix) (undecided)))
        (progn
          (setq cowsay-file (get-random-cowsay ".*.cow"))
          (setq command-string (format "cowthink -f %s \"%s\""
                                       cowsay-file
                                       (decode-coding-string
                                        signature-string (intern
                                                          "utf-8"))
                                       ))
          (format "%s\n\n%s" common-tail-signature
                  (shell-command-to-string command-string)))
      ;; for Unicode like Chinese, just render cowsay with empty content
      (progn
        (with-temp-buffer
          (insert signature-string)
          (goto-char (point-min))
          (fill-paragraph)
          (setq signature-string
                (buffer-substring-no-properties (point-min) (point-max))))
        (setq cowsay-file (get-random-cowsay ".*.txt"))
        (format "%s\n%s" signature-string (org-get-file-contents cowsay-file))
        )
      )))

(defun get-random-cowsay (match)
  (let ((files (directory-files (concat DENNY_CONF "/emacs_conf/cowsay") t match)))
    (nth (random (length files)) files)))

(defun get-motto(&optional max-length)
  (let (signature-string (old-agenda-files org-agenda-files) signature-list)
    (setq org-agenda-files (list (concat DENNY_CONF "/org_data/org_share/motto.org")))
    (setq signature-list (org-tags-view-list "Motto"))
    ;; set default threshold
    (if (null max-length) (setq max-length 500))
    ;; remove item longer than max-length
    (setq signature-list
          (remove-if #'(lambda(x) (> (length x) max-length)) signature-list))
    (setq signature-string (random-string signature-list))
    (setq org-agenda-files old-agenda-files)
    (eval signature-string)
    ))
(defun refresh-signature()
  "auto refresh mail signature"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (if (re-search-forward common-tail-signature nil t)
        (delete-region (- (point) (length common-tail-signature)) (point-max))
      (goto-char (point-max)))
    (insert (get-mail-signature))))
(define-key message-mode-map (kbd "<f5>") 'refresh-signature)
(defun random-string (string-list)
  "get random string from a string-list"
  (let ((rn (random (length string-list))))
    (concat (nth rn string-list) "\n")))

(defun cowsay-quote-region (begin end)
  "Quote a region with a cowsay figure."
  (interactive "r")
  (let ((content (buffer-substring-no-properties begin end)))
    (if (member (detect-coding-string content) '((undecided-unix) (undecided)))
        (progn
          (setq command-string (format "cowthink -f %s -W %d \"%s\""
                                       (get-random-cowsay ".*.cow")
                                       (max-line-length begin end)
                                       content))
          (shell-command command-string))
      (message "Error: don't supported for Unicode characters")
      )))
;; (org-tags-view-list "Motto" '("Attitude"))
;; (org-tags-view-list "Attitude")
(defun org-tags-view-list (tag-name &optional filter-tag-list)
  (let (retrieve-content entry-list (orig-buffer (current-buffer)))
    (save-excursion
      (org-tags-view nil tag-name)
      (goto-char (point-min))
      (forward-line 2)
      ;; obtain and wash data
      (setq retrieve-content
            (buffer-substring-no-properties (point) (point-max)))
      (setq retrieve-content
            (replace-regexp-in-string "^ [^:]+: +" "" retrieve-content))
      (setq entry-list (split-string retrieve-content "\n"))
      ;; restore cursor location
      (kill-buffer org-agenda-buffer-name)
      (switch-to-buffer orig-buffer)
      (delete-other-windows)
      ;;(kill-buffer)
      ;; exclude entries of given tag list
      (dolist (filter-tag filter-tag-list)
        (setq entry-list
              (delq nil
                    (mapcar #'(lambda (x)
                                (if (string-match (format ":%s" filter-tag) x)
                                    nil x))
                            entry-list))))
      ;; remove tags from entry
      (setq entry-list
            (mapcar #'(lambda (x) (replace-regexp-in-string " *:[^ ]+$" "" x))
                    entry-list))
      ;; limit too short entry
      (setq entry-list
            (delq nil (mapcar #'(lambda (x)
                                  (if (> (length x ) 15)
                                      x nil))
                              entry-list)))
      )))
;; --8<-------------------------- separator ------------------------>8--
;; File: signature-motto.el ends here
