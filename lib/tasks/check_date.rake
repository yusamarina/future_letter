namespace :check_date do
  desc "push_line"

  task push_line: :environment do
    liff_id = ENV['LIFF_ID']
    letters = Letter.where('send_date <= ? and send_date > ?', Time.now, Time.now - 1.hours)
    letters.each do |letter|
      address = SendLetter.find_by(letter_id: letter.id)
      if address.present?
        message = {
          "type": 'template',
          "altText": 'お手紙が届きました。',
          "template": {
              "thumbnailImageUrl": "https://images.unsplash.com/photo-1605364850023-a917c39f8fe9?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzV8fGxldHRlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60",
              "type": 'buttons',
              "title": 'FUTURE LETTER',
              "text": 'お手紙が届いています！',
              "actions": [
                  {
                    "type": 'uri',
                    "label": 'お手紙を読む',
                    "uri": "https://liff.line.me/#{liff_id}/login?token=#{letter.token}"
                  }
              ]
          }
        }
        client = Line::Bot::Client.new { |config|
          config.channel_secret = ENV['LINE_CHANNEL_SECRET']
          config.channel_token = ENV['LINE_CHANNEL_TOKEN']
        }
        response = client.push_message(address.user.line_user_id, message)
        p response

        if letter.user != address.user
          message = {
            "type": 'template',
            "altText": '相手へお手紙が送られました。',
            "template": {
                "thumbnailImageUrl": "https://images.unsplash.com/photo-1559057287-ce0f595679a8?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80",
                "type": 'buttons',
                "title": 'FUTURE LETTER',
                "text": '相手へお手紙が送られました！',
                "actions": [
                    {
                      "type": 'uri',
                      "label": '送ったお手紙を確認する',
                      "uri": "https://liff.line.me/#{liff_id}/login?token=#{letter.token}"
                    }
                ]
            }
          }
          client = Line::Bot::Client.new { |config|
            config.channel_secret = ENV['LINE_CHANNEL_SECRET']
            config.channel_token = ENV['LINE_CHANNEL_TOKEN']
          }
          response = client.push_message(letter.user.line_user_id, message)
          p response
        end

      else
        message = {
          "type": 'template',
          "altText": '送信相手が未選択のため、送信予定時刻にお手紙を送れませんでした。',
          "template": {
              "thumbnailImageUrl": "https://images.unsplash.com/photo-1603437873662-dc1f44901825?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzV8fGNsb3VkfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60",
              "type": 'buttons',
              "title": 'FUTURE LETTER',
              "text": "送信予定時刻を過ぎました。\n送信時刻の再設定、お手紙を送る相手を選択しましょう。",
              "actions": [
                  {
                    "type": 'uri',
                    "label": 'お手紙を確認する',
                    "uri": "https://liff.line.me/#{liff_id}/confirm?id=#{letter.id}"
                  }
              ]
          }
        }
        client = Line::Bot::Client.new{ |config|
          config.channel_secret = ENV['LINE_CHANNEL_SECRET']
          config.channel_token = ENV['LINE_CHANNEL_TOKEN']
        }
        response = client.push_message(letter.user.line_user_id, message)
        p response
      end
    end
  end

  task push_remind: :environment do
    liff_id = ENV['LIFF_ID']
    letters = Letter.where('send_date <= ? and send_date > ?', Time.now.since(3.days + 3.hours), Time.now + 3.hours)
    letters.each do |letter|
      if SendLetter.where(letter_id: letter.id).blank?
        message = {
          "type": 'template',
          "altText": '送信相手が選択されていないお手紙があります。',
          "template": {
              "thumbnailImageUrl": "https://images.unsplash.com/photo-1603437873662-dc1f44901825?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzV8fGNsb3VkfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60",
              "type": 'buttons',
              "title": 'FUTURE LETTER',
              "text": "設定した送信日時が近くなりました。\nお手紙を送る相手を選択しましょう。",
              "actions": [
                  {
                    "type": 'uri',
                    "label": 'お手紙を確認する',
                    "uri": "https://liff.line.me/#{liff_id}/confirm?id=#{letter.id}"
                  }
              ]
          }
        }
        client = Line::Bot::Client.new{ |config|
          config.channel_secret = ENV['LINE_CHANNEL_SECRET']
          config.channel_token = ENV['LINE_CHANNEL_TOKEN']
        }
        response = client.push_message(letter.user.line_user_id, message)
        p response
      end
    end
  end

  task push_suggest: :environment do
    liff_id = ENV['LIFF_ID']
    anniversaries = Anniversary.where('date <= ? and date > ?', Date.today.since(30.days), Date.today.since(29.days))
    anniversaries.each do |anniversary|
      message = {
        "type": 'template',
        "altText": 'もうすぐ記念日です。',
        "template": {
            "thumbnailImageUrl": "https://images.unsplash.com/photo-1603437873662-dc1f44901825?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MzV8fGNsb3VkfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60",
            "type": 'buttons',
            "title": 'FUTURE LETTER',
            "text": "記念日の30日前になりました。\nお手紙を書きませんか?",
            "actions": [
                {
                  "type": 'uri',
                  "label": '記念日を確認する',
                  "uri": "https://liff.line.me/#{liff_id}/write?id=#{anniversary.id}"
                }
            ]
        }
      }
      client = Line::Bot::Client.new{ |config|
        config.channel_secret = ENV['LINE_CHANNEL_SECRET']
        config.channel_token = ENV['LINE_CHANNEL_TOKEN']
      }
      response = client.push_message(anniversary.user.line_user_id, message)
      p response
    end
  end
end
