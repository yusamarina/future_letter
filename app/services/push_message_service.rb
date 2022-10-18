class PushMessageService
  def initialize(current_user)
    @current_user = current_user
  end

  def call
    message = {
      "type": 'text',
      "text": "お手紙の宛先確認メッセージを送りました$\n送信が許可されるまでお待ちください！$",
      "emojis": [
        {
          "index": 19,
          "productId": "5ac2197b040ab15980c9b43d",
          "emojiId": "027"
        },
        {
          "index": 39,
          "productId": "5ac2173d031a6752fb806d56",
          "emojiId": "202"
        }
      ]
    }
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV['LINE_CHANNEL_SECRET']
      config.channel_token = ENV['LINE_CHANNEL_TOKEN']
    }
    response = client.push_message(@current_user.line_user_id, message)
    p response
  end
end
