# slack-quote-bot

語録を発言するbot for slack

## Usage

set config.json as below:

```
{
    "spreadsheet_id" : "xxx",
    "client_id" : "xxx",
    "client_secret" : "xxx",
    "refresh_token" : "xxx"
}
```

```
$ bundle install --path vendor/bundle
$ SLACK_API_TOKEN=hogehoge bundle exec ruby bot.rb
```

## Author

[Jun Hashimoto](https://github.com/manji602)
