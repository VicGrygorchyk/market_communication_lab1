# encoding: utf-8
require 'rubygems'
require 'telegram/bot'
require_relative "helper"

def run_telegram_bot
  token = ENV["TOKEN"]

  Telegram::Bot::Client.run(token) do |bot|
    bot.listen do |message|
      puts "Message is #{message}"
      bot_listen(bot, message)
    end
  end
end