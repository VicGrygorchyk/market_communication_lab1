# encoding: utf-8
require 'rubygems'
require 'telegram/bot'


def run_telegram_bot
  token = ENV["TOKEN"]

  Telegram::Bot::Client.run(token) do |bot|
    bot.listen do |message|
      case message
        when Telegram::Bot::Types::CallbackQuery
          # Here you can handle your callbacks from inline buttons
          if message.data == 'drinks'
            drinks = Drink.all.to_a
            res = []
            drinks.each do |item|
              res.push("Напій #{item.name}, Ціна #{item.price}")
            end
            kb = [
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Замовити напій', callback_data: 'order_drink'),
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Замовити страву', callback_data: 'order_meal'),
            ]
            markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
            bot.api.send_message(chat_id: message.from.id, text: "#{res.join("\n")}", reply_markup: markup)
          elsif message.data == 'start_test'
            # meals = Meal.all.to_a
            # res = []
            # meals.each do |item|
              # res.push("Страва #{item.name}, Ціна #{item.price}")
            # end
            kb = [
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Замовити напій', callback_data: 'order_drink'),
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Замовити страву', callback_data: 'order_meal'),
            ]
            markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
            bot.api.send_message(chat_id: message.from.id, text: "#{res.join("\n")}", reply_markup: markup)
          end
        when Telegram::Bot::Types::Message
          case message.text
            when '/start'
              kb = [
                Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Почати тест!', callback_data: 'start_test'),
              ]
              markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
              bot.api.send_message(chat_id: message.chat.id, text: "Ласкаво просимо, #{message.from.first_name}. Дізнайся наскільки твоє харчування здорове!", reply_markup: markup)
            when '/stop'
              order.clear
                bot.api.send_message(chat_id: message.chat.id, text: "Дякуємо що були з нами, #{message.from.first_name}!")
            else
              bot.api.send_message(chat_id: message.chat.id, text: "Вибачте, команда не підтримується, виберіть:
                /start
                /stop")
            end
      end
    end
  end
end