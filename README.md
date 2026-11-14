# BAR 夜市

お客さんの注文を一瞬だけ見て覚え、同じ品を出してあげるバーの記憶ゲームです。
スマホのブラウザで開いて「ホーム画面に追加」すると、iPhone でも Android でもアプリのように遊べます。無料です。

- 遊ぶ：GitHub Pages の URL（公開後に `https://<ユーザー名>.github.io/<リポジトリ名>/`）
- ホーム画面への追加のしかた：`install.html`

## ファイル

| ファイル | 中身 |
| --- | --- |
| `yoichi.html` | ゲーム本体（ここを直す） |
| `index.html` | 公開用ページ。`tools/build.sh` で `yoichi.html` から作る |
| `install.html` | iPhone・Android でホーム画面に追加する手順 |
| `manifest.webmanifest` | ホーム画面に追加したときの名前・アイコン・色 |
| `sw.js` | 一度開けば電波がなくても遊べるようにするしくみ |
| `icons/` | アイコン画像（`tools/make-icons.ps1` で作り直せる） |

## ゲームを直したとき

1. `yoichi.html` を直す（広告・お祝いの花・お問い合わせ先は、スクリプト冒頭の `ADS` にまとまっています）
2. `sh tools/build.sh` を実行して `index.html` を作り直す
3. GitHub に上げる。数分で公開ページに反映されます

## 公開のしかた（GitHub Pages）

1. GitHub で新しい公開リポジトリを作り、このフォルダの中身を上げる
2. リポジトリの **Settings → Pages** で、Source を **Deploy from a branch**、Branch を **main / (root)** にして保存
3. 数分後、表示される URL でゲームが開けます

## お問い合わせ

アプリゲームと広告のお問い合わせ：appstudyjapan@gmail.com
