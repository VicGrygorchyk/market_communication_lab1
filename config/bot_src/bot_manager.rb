
class BotManager

    def initialize(bot, chat_id)
        @bot = bot
        @chat_id = chat_id
    end

    def send_msg(text)
        @bot.api.send_message(chat_id: @chat_id, text: text)
    end

    def send_msg_with_markup(text, markup)
        @bot.api.send_message(chat_id: @chat_id, text: text, reply_markup: markup)
    end
    
    def send_invoice(text, amount)
        @bot.api.sendInvoice(
            chat_id: @chat_id, title: "Здорове харчування: збірник порад", description: text, payload: 'payload',
            provider_token: '1661751239:TEST:667203875', currency: 'UAH', prices: [{"label": "оплатити карткою", "amount": amount}]
          )
    end
end