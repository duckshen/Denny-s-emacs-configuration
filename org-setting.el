;; -*- coding: utf-8 -*-
;; File: org-setting.el
;;
;; Author: Denny Zhang(markfilebat@126.com)
;; Created: 2009-08-01
;; Updated: Time-stamp: <2012-03-17 23:15:56>
;;
;; --8<-------------------------- §separator§ ------------------------>8--
(add-to-list 'load-path (concat EMACS_VENDOR "/org-7.8/lisp"))
(add-to-list 'load-path (concat EMACS_VENDOR "/org-7.8/contrib/lisp"))
(require 'org)
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; set org-agenda-files
(dolist (org-agenda-file-var (list
                              (concat DENNY_CONF "/org_data/wish.org")
                              (concat DENNY_CONF "/org_data/current.org")
                              (concat DENNY_CONF "/org_data/diary.org")
                              (concat DENNY_CONF "/org_data/learn.org")
                              (concat DENNY_CONF "/org_data/project.org")
                              ))
  (add-to-list 'org-agenda-files org-agenda-file-var))
;; --8<-------------------------- §separator§ ------------------------>8--
;; log the time of the things I have done
(setq-default org-log-done t)
;; write diary in org-mode
(setq org-agenda-diary-file (concat DENNY_CONF "/org_data/diary.org"))
(global-set-key "\C-cl" 'org-store-link) ;; define global keys
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(add-hook 'org-mode-hook 'turn-on-font-lock) ;; activate font-lock-mode
(setq org-todo-keyword-faces
      '(("TODO" . org-warning)
        ("DEFERRED" . shadow)
        ("CANCELED" . (:foreground "blue" :weight bold))))
(setq org-export-headline-levels 5);;set export headline level
;;set export css
;; (setq org-export-table-row-tags '("<tr onMouseOver = \"this.className = 'highlight'\" onMouseOut = \"this.className = 'initial'\">" . "</tr>"))
;;set table
;; (setq org-export-html-table-tag "<table border = \"2\" bgcolor = \"#DDDDDD\" >" )
(setq org-time-stamp-custom-formats (quote ("<%Y-%m-%d>" . "<%Y-%m-%d %H:%M>")))
;; Erase all reminders and rebuilt reminders for today from the agenda
(defun bh/org-agenda-to-appt ()
  (interactive)
  (setq appt-time-msg-list nil)
  (org-agenda-to-appt))
;; Rebuild the reminders everytime the agenda is displayed
(add-hook 'org-finalize-agenda-hook 'bh/org-agenda-to-appt)
;; Activate appointments so we get notifications
;;(appt-activate t)
;; If we leave Emacs running overnight - reset the appointments one minute after midnight
(run-at-time "24:01" nil 'bh/org-agenda-to-appt)
(setq org-agenda-custom-commands
      '(("h" "Daily habits"
         ((agenda ""))
         ((org-agenda-show-log t)
          (org-agenda-ndays 7)
          (org-agenda-log-mode-items '(state))
          (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp ":Habit:"))))
        ;; other commands here
        ))
;; --8<-------------------------- §separator§ ------------------------>8--
(require 'org-habit)
(setq org-habit-graph-column 80)
;; --8<-------------------------- §separator§ ------------------------>8--
(setq org-todo-keyword-faces
      '(("TODO" . org-warning)
        ("DEFERRED" . shadow)
        ("CANCELED" . (:foreground "CornflowerBlue" :weight bold))))
;; --8<-------------------------- §separator§ ------------------------>8--
(setq org-agenda-custom-commands
      '(("X" agenda ""
         ((ps-number-of-columns 2)
          (ps-landscape-mode t)
          (org-agenda-prefix-format " [ ] ")
          (org-agenda-with-colors nil)
          (org-agenda-remove-tags t))
         ("theagenda.ps"))))
;; --8<-------------------------- §separator§ ------------------------>8--
;; set css for html export in org-mode
(setq user-full-name "张巍")
(setq user-mail-address "markfilebat@126.com")
(load-file (concat DENNY_CONF "/emacs_conf/org-css-setting.el"))
;; --8<-------------------------- §separator§ ------------------------>8--
(load-file (concat DENNY_CONF "/emacs_conf/org-publish/org-publish-to-wordpress.el"))
(load-file (concat DENNY_CONF "/emacs_conf/org-publish/wordpress-post.el"))
;; --8<-------------------------- §separator§ ------------------------>8--
;;TODO: need to be enhanced
(require 'org-mobile)
(setq org-mobile-directory (concat DENNY_CONF "../MobileOrg"))
(setq org-mobile-files (list (concat DENNY_CONF "/org_data/tomobile.org")))
(setq org-directory (concat DENNY_CONF "/org_data/"))
;; pulling from MobileOrg
(setq org-mobile-inbox-for-pull (concat DENNY_CONF "../emacs_stuff/org_data/frommobile.org"))
;; --8<-------------------------- §separator§ ------------------------>8--
;; (load-file (concat EMACS_VENDOR "/org-contacts/org-contacts.el"))
;; (require 'org-contacts)
;; (setq contact-file (concat DENNY_CONF "/org_data/contacts_tmp.org"))
;; (add-to-list 'org-contacts-files contact-file)
;; ;; ledger org-capture to add new contact
;; (setq org-capture-templates
;; '(("c" "Contacts" entry (file contact-file)
;; "* %(org-contacts-template-name)
;; :PROPERTIES:
;; :EMAIL: %(org-contacts-template-email)
;; :END:")
;; ))
;; --8<-------------------------- §separator§ ------------------------>8--
;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (perl . t)
   (python . t)
   (sh . t)
   (ditaa . t)
   (ledger . t)
   (ruby . t)
   ))
;; --8<-------------------------- §separator§ ------------------------>8--
(setq org-agenda-include-diary t) ;集成日历
;; --8<-------------------------- §separator§ ------------------------>8--
(defun jump-to-org-agenda ()
  (interactive)
  (unless (featurep 'org-agenda)
    (load ".org"))
  (let ((buf (get-buffer "*Org Agenda*"))
        wind)
    (if buf
        (if (setq wind (get-buffer-window buf))
            (when (called-interactively-p 'any)
              (select-window wind)
              (org-fit-window-to-buffer))
          (if (called-interactively-p 'any)
              (progn
                (select-window (display-buffer buf t t))
                (org-fit-window-to-buffer))
            (with-selected-window (display-buffer buf)
              (org-fit-window-to-buffer))))
      (call-interactively 'org-agenda-list))))
;;(run-with-idle-timer 3600 t 'jump-to-org-agenda) ;; TODO, enhance the usage
(setq org-agenda-repeating-timestamp-show-all nil)
(setq org-agenda-restore-windows-after-quit t)
;; --8<-------------------------- §separator§ ------------------------>8--
;; change org local key
(org-defkey org-mode-map (kbd "C-M-.") 'org-shiftmetaright)
(org-defkey org-mode-map (kbd "C-M-,") 'org-shiftmetaleft)
(org-defkey org-mode-map [(control return)] 'switch-to-mode-nex-buffer)
(org-defkey org-mode-map [(control shift up)] 'enlarge-window)
(org-defkey org-mode-map [(control shift down)] 'shrink-window)
(org-defkey org-mode-map [(meta .)] 'occur-org-title)
;; (org-defkey org-mode-map [(meta return)] 'my-org-meta-return)
(defun my-org-meta-return(&optional arg)
  (interactive "P")
  (if (org-in-item-p)
      (org-meta-return)
    (org-meta-return)
    (insert "\n#+BEGIN_EXAMPLE\n\n#+END_EXAMPLE")
    (forward-line -3)
    (org-end-of-line)
    )
  )
(defun occur-org-title()
  "when regexp search, only search title of org-mode entries"
  (interactive)
  (let (regexp)
    (setq regexp (read-string "Search org entries whose title matching regexp: " "^\\\*+ .*"))
    (occur-1 regexp 0 (list (current-buffer)))))

(defun replace-entry(entry_title)
  ;; filter entries whose title contains entry_title, then quote
  ;; content by #+BEGIN_EXAMPLE and #+END_EXAMPLE
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward-regexp (format "^\\*.*%s" entry_title) nil t)
      (if (search-forward-regexp "\n" nil t)
          ;; make sure the code is re-entrant
          (if (< (+ 2 (point)) (point-max))
              (unless (string= (buffer-substring-no-properties (point) (+ 2 (point))) "#+")
                (insert "#+BEGIN_EXAMPLE\n")
                (if (search-forward-regexp "^\*" nil t)
                    (backward-char 1)
                  (goto-char (point-max)))
                (insert "#+END_EXAMPLE\n")
                ))
        ))))

(defun remove-entry-quote(entry_title)
  ;; filter entries whose title contains entry_title, then remove quote
  ;; of #+BEGIN_EXAMPLE and #+END_EXAMPLE
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward-regexp (format "^\\*.*%s" entry_title) nil t)
      (if (search-forward-regexp "\n" nil t)
          ;; make sure the code is re-entrant
          (if (< (+ 2 (point)) (point-max))
              (when (string= (buffer-substring-no-properties (point) (+ 2 (point))) "#+")
                (org-narrow-to-subtree)
                (goto-char (point-min))
                (flush-lines "^#+")
                (widen)
                ))
        ))))
(defun url-link-quote()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "^\\( *http://[^ \\\n\"]+\\)\\\\*$" nil t)
      (replace-match (format "%s\\\\\\\\" (match-string 1)) nil nil))
    )
  )

;; --8<-------------------------- §separator§ ------------------------>8--
(load-file (concat EMACS_VENDOR "/graphviz-dot-mode/graphviz-dot-mode.el"))
;; --8<-------------------------- §separator§ ------------------------>8--
(setq org-directory (concat DENNY_CONF "/org_data/"))
(setq org-default-notes-file "current.org")
(define-key global-map "\C-cr" 'org-capture)
(setq org-capture-templates
      '(("p" "Period" entry (file+headline "contacts.org" "秀秀--周期") "** %t\n")
        ("d" "Diary" entry (file "diary.org") "* %T %?\n\n")
        ))
;; (org-remember-insinuate)
;; (setq org-directory (concat DENNY_CONF "/org_data/"))
;; (setq org-default-notes-file "current.org")
;; (define-key global-map "\C-cr" 'org-remember)
;; (setq org-remember-templates
;; '(("Todo" ?t "* TODO %?\n %i\n" "current.org" bottom)
;; ("Remind" ?r "** TODO %?\n %i\n" "current.org" "Remind")
;; ("Period" ?p "- %t\n" "contacts.org" "秀秀--周期")
;; ("Diary" ?d "* %T %?\n# 今日所学\n %i\n# 今日趣闻\n %i\n# 今日杂记\n %i\n" "diary.org" bottom)
;; ))
;; --8<-------------------------- §separator§ ------------------------>8--
;; auto add "TODO " for top task
(defadvice org-meta-return (after cond activate)
  (when (= 1 (org-current-level))
    (insert "TODO "))
  )
;; (defadvice get-page-title (after insert activate)
;; (when (string= "Org" mode-name)
;; (let ((link-str "useful link"))
;; (unless (string= link-str (org-no-properties (org-get-heading)))
;; (move-beginning-of-line nil)
;; (insert (make-string (org-current-level) ?*) " " link-str "\n")
;; ))))
;; --8<-------------------------- §separator§ ------------------------>8--
(setq org-src-fontify-natively t)
;; --8<-------------------------- §separator§ ------------------------>8--
;; (setq org-drawers (quote ("PROPERTIES" "CLOCK" "LOGBOOK" "NOTES" "COMMENTS" "LINKS")))

;; (setq org-todo-keywords (quote ((sequence "TODO(t)" "STARTED(s)" "|" "DONE(d!/!)")
;; (sequence "WAITING(w@/!)" "SOMEDAY(S!)" "PROJECT(P@)" "OPEN(O@)" "|" "CANCELLED(c@/!)")
;; (sequence "QUOTE(q!)" "QUOTED(Q!)" "|" "APPROVED(A@)" "EXPIRED(E@)" "REJECTED(R@)"))))

;; (setq org-todo-keyword-faces (quote (("TODO" :foreground "red" :weight bold)
;; ("STARTED" :foreground "blue" :weight bold)
;; ("DONE" :foreground "forest green" :weight bold)
;; ("WAITING" :foreground "orange" :weight bold)
;; ("SOMEDAY" :foreground "magenta" :weight bold)
;; ("CANCELLED" :foreground "forest green" :weight bold)
;; ("PROJECT" :foreground "red" :weight bold))))
;; --8<-------------------------- §separator§ ------------------------>8--
(setq org-completion-use-ido t)
;; --8<-------------------------- §separator§ ------------------------>8--
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-checkbox ((t (:inherit bold))))
 '(org-checkbox-statistics-todo ((t (:inherit org-todo :foreground "DarkKhaki"))) t)
 '(org-level-1 ((t (:inherit outline-1 :foreground "LimeGreen"))))
 '(org-level-2 ((t (:inherit outline-2 :foreground "YellowGreen"))))
 '(org-level-3 ((t (:inherit outline-3 :foreground "SeaGreen3"))))
 '(org-todo ((t (:weight bold))))
 '(org-warning ((t (:inherit font-lock-warning-face :foreground "LightGoldenrod")))))
;; ;; --8<-------------------------- §separator§ ------------------------>8--
(add-hook 'org-mode-hook 'visual-line-mode)
;; --8<-------------------------- §separator§ ------------------------>8--
;; File: org-setting.el ends here