;; -*- mode: emacs-lisp; coding: utf-8-unix -*-
;;; dot.skk --- init file for SKK

;;; Commentary:

;; 以下は ~/.skk の設定例です。

;;; Code:

;; @@ 基本中の基本の設定

;; SKK が検索する辞書 (サーバを使わないとき)
;; (setq skk-large-jisyo "/usr/share/skk/SKK-JISYO.L")

;; サーバを使うための設定
(setq skk-server-host "localhost")
(setq skk-server-portnum 1178)

;; @@ 表示の設定

;; メッセージを日本語で通知する
(setq skk-japanese-message-and-error t)

;; 変換時に註釈 (annotation) を表示する
(setq skk-show-annotation t)

;; カーソルに色を付けない
;; (setq skk-use-color-cursor nil)

;; (when skk-use-color-cursor
;;   ;; カーソル色を変えてみる
;;   (setq skk-cursor-hiragana-color "blue"
;;	   skk-cursor-katakana-color "green"
;;	   skk-cursor-abbrev-color "red"
;;	   skk-cursor-jisx0208-latin-color "red"
;;	   skk-cursor-jisx0201-color "purple"))

;; インジケータに色を付けない
;; (setq skk-indicator-use-cursor-color nil)

;; 変換中の文字列をハイライトしない
;; (setq skk-use-face nil)

;; (when skk-use-face
;;   ;; 変換文字列の色を変えてみる
;;   (skk-make-face 'DimGray/PeachPuff1)
;;   (setq skk-henkan-face 'DimGray/PeachPuff1))

;; @@ 基本的なユーザ・インターフェース

;; Enter キーを押したときには確定する
;(setq skk-egg-like-newline t)

;; ▼モードで BS を押したときには確定しないで前候補を表示する
;(setq skk-delete-implies-kakutei nil)

;; 対応する閉括弧を自動的に挿入する
;;(setq skk-auto-insert-paren t)

;; ▽モードと▼モード時のアンドゥ情報を記録しない
;; (setq skk-undo-kakutei-word-only t)

;; 句読点は , . を使う
(setq skk-kuten-touten-alist '(
    (jp . ("。" . "、" ))
    (en . (". " . ", "))))
;; jp にすると「。、」を使います
(setq-default skk-kutouten-type 'en)

;; 動的な補完を使う
;; (setq skk-dcomp-activate t)

;; viper と組み合わせて使う
;; (setq skk-use-viper t)

;; 確定には C-j でなくで変換キーを使う
;; (setq skk-kakutei-key [henkan])
;; 注) 変換キーは、Emacs on XFree86  では [henkan]
;;                 XEmacs on XFree86 では [henkan-mode]
;;                 Meadow            では [convert]

;; 接頭・接尾辞変換のキーを設定する
;; 例 1) 標準の設定
;; (setq skk-special-midashi-char-list '(?> ?< ??))
;; 例 2) ? は普通に入力したいから外す
;; (setq skk-special-midashi-char-list '(?> ?<))
;; 例 3) 文字キーは普通に入力したいから他のキーを使う
;; (setq skk-special-midashi-char-list nil)
;; (define-key skk-j-mode-map [muhenkan] 'skk-process-prefix-or-suffix)

;; @@ 変換動作の調整

;; 送り仮名が厳密に正しい候補を優先して表示する
 (setq skk-henkan-strict-okuri-precedence t)

;; 辞書登録のとき、余計な送り仮名を送らないようにする
 (setq skk-check-okurigana-on-touroku 'auto)

;; @@ 検索に関連した設定

;; look コマンドを使った検索をする
;; (setq skk-use-look t)

;; (when skk-use-look
;;   ;; look が見つけた語を見出し語として検索する
;;   (setq skk-look-recursive-search t)
;;   ;; ispell を look と一緒に使うのはやめる
;;   (setq skk-look-use-ispell nil)
;;   ;; `skk-abbrev-mode' で skk-look を使った検索をしたときに確定情報を
;;   ;; 個人辞書に記録しないようにする
;;   (setq skk-search-excluding-word-pattern-function
;;	   ;; KAKUTEI-WORD を引数にしてコールされるので、不要でも引数を取る
;;	   ;; 必要あり
;;	   (lambda (kakutei-word)
;;	     (and skk-abbrev-mode
;;		  (save-match-data
;;		    ;; `skk-henkan-key' が "*" で終わるとき
;;		    (string-match "\\*$" skk-henkan-key))))))

;; lookup を利用した変換を行う
;; (setq skk-search-prog-list
;;       (skk-nunion skk-search-prog-list
;;		     '((skk-lookup-search))))

;; 送りあり変換を送りなし変換と同じ操作でできるようにする
;; (setq skk-auto-okuri-process t)

;; カタカナ語を変換候補に加える
;;(setq skk-search-prog-list
;;      (skk-nunion skk-search-prog-list
;;		  '((skk-search-katakana))))

;; サ行変格活用の動詞も送りあり変換出来るようにする
(setq skk-search-prog-list
      (skk-nunion skk-search-prog-list
		   '((skk-search-sagyo-henkaku))))

;; @@ かな入力関連の設定

;; 半角カナ入力メソッドを使う
;; (setq skk-use-jisx0201-input-method t)

;; かな配列キーボードで入力する
;; (setq skk-use-kana-keyboard t)

;; (when skk-use-kana-keyboard
;;   ;; 旧 JIS 配列を使う
;;   ;; (setq skk-kanagaki-keyboard-type '106-jis)
;;   ;; 親指シフトエミュレーションを使う
;;   (setq skk-kanagaki-keyboard-type 'omelet-jis)
;;   ;; OASYS 風の後退・取消キーを使う
;;   (setq skk-nicola-use-koyubi-functions t))

;; @@ その他いろいろ

;; 複数の Emacsen を起動して個人辞書を共有する
(setq skk-share-private-jisyo t)

;;; dot.skk ends here
