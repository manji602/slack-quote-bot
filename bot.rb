# -*- coding: utf-8 -*-
require 'json'
require 'slack-ruby-bot'

paths = %w(
  lib/*.rb
)
Dir[*paths].each { |f| load f }

module Bot
  class App < SlackRubyBot::App
  end

  class Ping < SlackRubyBot::Commands::Base
    command 'help' do |client, data, _match|
      text = "[usage]\n(語録|goroku) : 語録をランダムにpost\n(語録|goroku) (追加|add) [追加したいpostのURL] : 語録を追加"
      client.message text: text, channel: data.channel
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
end

Bot::App.instance.run
