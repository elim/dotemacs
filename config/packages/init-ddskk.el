;;; init-ddskk.el --- A setting of the ddskk.
;;; Commentary:
;;; Code:

;; このファイル自体を SKK の初期設定ファイルにする
;; skk-restart 時に読み直す対象になる
(set-variable 'skk-init-file load-file-name)

(global-set-key "\C-x\C-j" 'skk-mode)
(global-set-key "\C-xt" nil)
(global-set-key "\C-xj" nil)

(set-variable 'skk-jisyo-code 'utf-8)
(set-variable 'skk-count-private-jisyo-candidates-exactly t)

;; 複数の Emacsen を起動して個人辞書を共有する
(set-variable 'skk-share-private-jisyo t)

;; サーバを使うための設定
(set-variable 'skk-server-host "localhost")
(set-variable 'skk-server-portnum 1178)

(condition-case nil
    (skk-server-version)
  (error
   (let
       ((dic-file "/usr/share/skk/SKK-JISYO.L"))
     (and (file-exists-p dic-file)
          (set-variable 'skk-jisyo-code nil)
          (set-variable 'skk-large-jisyo dic-file)))))

;; メッセージを日本語で通知する
(set-variable 'skk-japanese-message-and-error t)

;; 変換時に註釈 (annotation) を表示する
(set-variable 'skk-show-annotation t)

;; 句読点
(set-default 'skk-kutouten-type 'jp)

;; @@ 変換動作の調整

;; 送り仮名が厳密に正しい候補を優先して表示する
(set-variable 'skk-henkan-strict-okuri-precedence t)

;; 辞書登録のとき、余計な送り仮名を送らないようにする
(set-variable 'skk-check-okurigana-on-touroku 'auto)

;; サ行変格活用の動詞も送りあり変換出来るようにする
(with-eval-after-load-feature 'ddskk
  (set-variable 'skk-search-prog-list
        (skk-nunionx skk-search-prog-list
                    '((skk-search-sagyo-henkaku)))))

;; SKK を Emacs の input method として使用する
(set-variable 'default-input-method "japanese-skk")

;; migemo を使うから skk-isearch にはおとなしくしていて欲しい
(set-variable 'skk-isearch-start-mode 'latin)

;; 辞書を 10 分毎に自動保存
(with-eval-after-load-feature 'ddskk
  (let
      ((skk-auto-save-jisyo-interval 6))
    (run-with-idle-timer
     skk-auto-save-jisyo-interval t
     #'skk-save-jisyo)))

;; ロードしておく
(skk-mode -1)

;;; init-ddskk.el ends here
