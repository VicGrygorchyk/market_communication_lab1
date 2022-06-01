# encoding: utf-8
require 'rubygems'
require 'telegram/bot'
require_relative "bot_manager"


def bot_listen(bot, message)
  case message
  when Telegram::Bot::Types::CallbackQuery
    handle_callback_query(bot, message)
  when Telegram::Bot::Types::Message
    handle_msg_text(bot, message)
  when Telegram::Bot::Types::PreCheckoutQuery
    handle_precheckout_query(bot, message)
  end
end


def handle_callback_query(bot, message)
  bot_mng = BotManager.new(bot, message.from.id)
  if message.data.start_with?('end_test')
    final_score = grep_score(message.data)
    results = Result.where("min <= ?", final_score).where("max >= ?", final_score)
    final_res = results.to_a.pop
    final_res = final_res["text"]
    
    bot_mng.send_msg("Ваш підсумковий бал #{final_score}")
    bot_mng.send_msg("#{final_res}")

    text_for_payment = "Зацікавлені y здоровому харчуванні? Придбайте нову збірку простих та ефективних правил харчування на кожен день!"
    bot_mng.send_invoice(text_for_payment, 1000)

  elsif message.data.start_with?('start_test')
    questions = Question.all.to_a
    q_results = []
    current_question = message.data[/(?<=start_test )\d+/, 0].to_i
    score = grep_score(message.data)

    if current_question >= questions.length()
      kb = [
        Telegram::Bot::Types::InlineKeyboardButton.new(text: "Отримати результат", callback_data: "end_test score #{score}"),
      ]
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      bot_mng.send_msg_with_markup("Тест завершено", markup)
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
      bot_mng.send_msg_with_markup("\t\n#{question[:question]}", markup)
    end
   end
end

def handle_msg_text(bot, message)
  bot_mng = BotManager.new(bot, message.from.id)
  puts message.text
  if message.successful_payment
    bot_mng.send_msg("Дякую! Завантажте вашу книгу за посиланням www.test.ua/book/112345")
  else
  case message.text
    when '/start'
      kb = [
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Почати тест!', callback_data: 'start_test 0 score 0'),
      ]
      markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
      bot_mng.send_msg_with_markup("Ласкаво просимо, #{message.from.first_name}. Дізнайся наскільки твоє харчування здорове!", markup)
    when '/stop'
      bot_mng.send_msg("Дякуємо що були з нами, #{message.from.first_name}!")
    else
      bot_mng.send_msg("Вибачте, команда не підтримується, виберіть:
        /start
        /stop"
      )
    end
  end
end


def handle_precheckout_query(bot, message)
  bot.api.answerPreCheckoutQuery(pre_checkout_query_id: message.id, ok: true, error_message: "Error")
end

def grep_score(data)
  score = data[/(?<=score )\d+/, 0].to_i
  score
end
