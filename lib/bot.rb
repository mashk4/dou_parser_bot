require_relative 'dou_parser'
require 'telegram/bot'
require 'dotenv/load'

TOKEN = ENV['TELEGRAM_BOT_TOKEN']

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Hey, honey! Please write a programming language or technology you're looking for."
      )
    else
      bot.api.send_message(
        chat_id: message.chat.id,
        text: DouParser.new.result(message.text),
        parse_mode: 'HTML',
        disable_web_page_preview: true
      )
    end
  end
end

