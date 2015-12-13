# -*- coding: utf-8 -*-
require 'google_drive'

class SpreadsheetUtil
  CONFIG_JSON_PATH = 'config.json'

  def self.config
    json_data = open(CONFIG_JSON_PATH) do |io|
      JSON.load(io)
    end
  end

  def self.login
    @config = self.config

    client_id     = @config["client_id"]
    client_secret = @config["client_secret"]
    refresh_token = @config["refresh_token"]

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
    ws = session.spreadsheet_by_key(@config["spreadsheet_id"]).worksheets[0]
    fetch_row = [*1..ws.num_rows].sample
    return ws[fetch_row, 1]
  end

  def self.insert(message)
    session = self.login
    ws = session.spreadsheet_by_key(@config["spreadsheet_id"]).worksheets[0]
    insert_row = ws.num_rows + 1
    ws[insert_row, 1] = message
    ws.save
  end
end
