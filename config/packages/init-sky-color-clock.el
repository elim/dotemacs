;;; init-sky-color-clock.el --- A setting of the sky-color-clock.
;;; Commentary:
;;; Code:

(defcustom elim:openweathermap-api-key ""
  "The API key of the OpenWeatherMap."
  :type 'string
  :group 'elim)

(defcustom elim:openweathermap-city-id nil
  "The city ID of OpenWeatherMap."
  :type 'integer
  :group 'elim)

(use-package sky-color-clock
  :after (smart-mode-line)

  :config
  (sky-color-clock-initialize 35)
  (sky-color-clock-initialize-openweathermap-client
   elim:openweathermap-api-key
   elim:openweathermap-city-id)
  (setq-default mode-line-format
                (add-to-list 'mode-line-format '(:eval (sky-color-clock)) t))


  :custom
  (sky-color-clock-format "")
  (sky-color-clock-enable-emoji-icon t)
  (sky-color-clock-enable-temperature-indicator t))

;;; init-sky-color-clock.el ends here
