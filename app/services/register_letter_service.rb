class RegisterLetterService
  def initialize(letter, current_user)
    @letter = letter
    @current_user = current_user
  end

  def call
    if @letter.user == @current_user
      message = {
        "type": 'text',
        "text": "お手紙が登録されました！\nお届けまでお楽しみに$$",
        "emojis": [
          {
            "index": 23,
            "productId": "5ac22bad031a6752fb806d67",
            "emojiId": "070"
          },
          {
            "index": 24,
            "productId": "5ac22bad031a6752fb806d67",
            "emojiId": "189"
          }
        ]
      }
      client = Line::Bot::Client.new { |config|
        config.channel_secret = ENV['LINE_CHANNEL_SECRET']
        config.channel_token = ENV['LINE_CHANNEL_TOKEN']
      }
      response = client.push_message(@current_user.line_user_id, message)
      p response
    else
      message = {
        "type": 'text',
        "text": "お手紙の宛先が確認されました$\n設定日時に相手へお手紙が届きます！お楽しみに$",
        "emojis": [
          {
            "index": 14,
            "productId": "5ac22bad031a6752fb806d67",
            "emojiId": "186"
          },
          {
            "index": 38,
            "productId": "5ac22bad031a6752fb806d67",
            "emojiId": "143"
          }
        ]
      }
      client = Line::Bot::Client.new { |config|
        config.channel_secret = ENV['LINE_CHANNEL_SECRET']
        config.channel_token = ENV['LINE_CHANNEL_TOKEN']
      }
      response = client.push_message(@letter.user.line_user_id, message)
      p response
      message = {
        "type": 'text',
        "text": "お手紙はサプライズで届きます！\nお届けまでお楽しみに$$",
        "emojis": [
          {
            "index": 26,
            "productId": "5ac22bad031a6752fb806d67",
            "emojiId": "070"
          },
          {
            "index": 27,
            "productId": "5ac22bad031a6752fb806d67",
            "emojiId": "189"
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
end
