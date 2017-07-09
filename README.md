# slack-quote-bot

語録を発言するbot for slack

## Usage

* [Slack Web API](https://api.slack.com/web) から、`OAuth 2.0` を利用したアプリを作成する。アプリに必要なパーミッションは最低でも `chat:write:bot` だけあればOK。

* [OAuth & Permissions](https://api.slack.com/apps/XXX/oauth) から `OAuth Access Token` をコピーしておく

* 語録を管理しているGoogle Spreadsheetのメニューから、「スクリプトエディタ」を選択する

* [bot.gs](https://github.com/manji602/slack-quote-bot/blob/master/bot.gs) の内容をコピペする

* スクリプトエディタの「ファイル -> プロジェクトのプロパティ」から「スクリプトのプロパティ」を選択し、下記の値を設定する
  * `BOT_NAME` : botの表示名
  * `CURRENT_SHEET_NAME` : 語録の記載されたシート名
  * `BOT_ICON` : botの表示アイコン
  * `SLACK_ACCESS_TZOKEN` : Slack AppのOAuth Access Token

* スクリプトエディタの「公開 -> ウェブアプリケーションとして導入」を実行し、ウェブアプリケーションのURLを取得する

* [Custom Integerations](https://your.slack.com/apps/manage/custom-integrations) から `outgoing-webhook` を選択した上で、上で設定したアプリケーションのURLを `URL(s)` に設定する。 `Trigger Word(s)` はよしなに設定。

## License

MIT

## Author

[Jun Hashimoto](https://github.com/manji602)
