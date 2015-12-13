# -*- coding: utf-8 -*-
require 'slack-ruby-bot'
require 'google/api_client'
require 'google/api_client/auth/file_storage'
require 'google/api_client/auth/installed_app'
require 'google_drive'

module Bot
  SPREADSHEET_ID = ""

  class App < SlackRubyBot::App
  end

  class Ping < SlackRubyBot::Commands::Base
    command 'help' do |client, data, _match|
      client.message text: 'ヘルプだよ', channel: data.channel
    end

    match /\A(語録|goroku)\z/ do |client, data, match|
        message = SpreadsheetUtil.fetch_random
        send_message client, data.channel, "#{message}"
    end

    match /(語録|goroku)\p{blank}(add|追加)\p{blank}(?<url>.*)/ do |client, data, match|
      url = match[:url]
      plain_url = url.match(/\A<(.*)>\z/)

      if plain_url.nil?
        send_message client, data.channel, "( ˘ω˘)urlをｵｸﾚ…"
      else
        SpreadsheetUtil.insert(plain_url[1])
        send_message client, data.channel, "語録追加done"
      end
    end
  end

  class SpreadsheetUtil
    def self.login
      client_id     = ""
      client_secret = ""
      refresh_token = ""
      client = OAuth2::Client.new(
        client_id,
        client_secret,
        site: "https://accounts.google.com",
        token_url: "/o/oauth2/token",
        authorize_url: "/o/oauth2/auth")

      auth_token = OAuth2::AccessToken.from_hash(client,{:refresh_token => refresh_token, :expires_at => 3600})
      auth_token = auth_token.refresh!
      session = GoogleDrive.login_with_oauth(auth_token.token)  
    end

    def self.fetch_random
      session = self.login
      ws = session.spreadsheet_by_key(SPREADSHEET_ID).worksheets[0]
      fetch_row = [*1..ws.num_rows].sample
      return ws[fetch_row, 1]
    end

    def self.insert(message)
      session = self.login
      ws = session.spreadsheet_by_key(SPREADSHEET_ID).worksheets[0]
      insert_row = ws.num_rows + 1
      ws[insert_row, 1] = message
      ws.save
    end
  end
end

Bot::App.instance.run
