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
        if message.data.start_with?('end_test')
          final_score = message.data[/(?<=score )\d+/, 0].to_i
          results = Result.where("min <= ?", final_score).where("max >= ?", final_score)
          final_res = results.to_a.pop
          final_res = final_res["text"]
          
          bot.api.send_message(chat_id: message.from.id, text: "Ваш підсумковий бал #{final_score}")
          bot.api.send_message(chat_id: message.from.id, text: "#{final_res}")
        
        elsif message.data.start_with?('start_test')
            questions = Question.all.to_a
            q_results = []
            current_question = message.data[/(?<=start_test )\d+/, 0].to_i
            score = message.data[/(?<=score )\d+/, 0].to_i

            if current_question >= questions.length()
              kb = [
                Telegram::Bot::Types::InlineKeyboardButton.new(text: "Отримати результат", callback_data: "end_test score #{score}"),
              ]
              markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
              bot.api.send_message(chat_id: message.from.id, text: "Тест завершено", reply_markup: markup)
            else
              question_ = questions[current_question]
              q_to_a = QuestionToAnswer.where(question_id: question_.id)
              answrs = []
              q_to_a.to_a.each do |ans|
                res = Answer.find(ans.answer_id)
                answrs.push({
                  "text": res.text,
                  "score": res.score
                })
              end
              question = {
                question: question_.text,
                answers: answrs
              }
              answers = question[:answers]
              answ_1 = answers[0]
              answ_2 = answers[1]
              answ_3 = answers[2]
              score_1 = answ_1[:score] + score
              score_2 = answ_2[:score] + score
              score_3 = answ_3[:score] + score
              current_question += 1
  
              kb = [
                Telegram::Bot::Types::InlineKeyboardButton.new(text: "#{answ_1[:text]}", callback_data: "start_test #{current_question} score #{score_1}"),
                Telegram::Bot::Types::InlineKeyboardButton.new(text: "#{answ_2[:text]}", callback_data: "start_test #{current_question} score #{score_2}"),
                Telegram::Bot::Types::InlineKeyboardButton.new(text: "#{answ_3[:text]}", callback_data: "start_test #{current_question} score #{score_3}"),
              ]
              markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
              bot.api.send_message(chat_id: message.from.id, text: "#{question[:question]}", reply_markup: markup)  
            end
           end
        when Telegram::Bot::Types::Message
          case message.text
            when '/start'
              kb = [
                Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Почати тест!', callback_data: 'start_test 0 score 0'),
              ]
              markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
              bot.api.send_message(chat_id: message.chat.id, text: "Ласкаво просимо, #{message.from.first_name}. Дізнайся наскільки твоє харчування здорове!", reply_markup: markup)
            when '/stop'
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