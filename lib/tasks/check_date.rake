namespace :check_date do
  desc "push_line"

  task push_line: :environment do
    liff_id = ENV['LIFF_ID']
    letters = Letter.where('send_date <= ? and send_date > ?', Time.now, Time.now - 1.hours)
    letters.each do |letter|
      if SendLetter.find_by(letter_id: letter.id).present?
        message = {
          "type": "template",
          "altText": "相手へお手紙が送られました。",
          "template": {
              "thumbnailImageUrl": "https://cdn.pixabay.com/photo/2016/09/10/17/17/letters-1659715_1280.jpg",
              "type": "buttons",
              "title": "FUTURE LETTER",
              "text": "相手へお手紙が送られました！",
              "actions": [
                  {
                    "type": "uri",
                    "label": "送ったお手紙を確認する",
                    "uri": "https://liff.line.me/#{liff_id}/send_letters/#{letter.token}"
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

        message = {
          "type": "template",
          "altText": "お手紙が届きました。",
          "template": {
              "thumbnailImageUrl": "https://cdn.pixabay.com/photo/2016/09/10/17/17/letters-1659715_1280.jpg",
              "type": "buttons",
              "title": "FUTURE LETTER",
              "text": "お手紙が届いています！",
              "actions": [
                  {
                    "type": "uri",
                    "label": "お手紙を読む",
                    "uri": "https://liff.line.me/#{liff_id}/send_letters/#{letter.token}"
                  }
              ]
          }
        }
        client = Line::Bot::Client.new { |config|
            config.channel_secret = ENV['LINE_CHANNEL_SECRET']
            config.channel_token = ENV['LINE_CHANNEL_TOKEN']
        }
        address = SendLetter.find_by(letter_id: letter.id)
        destination = User.find(address.destination_id)
        response = client.push_message(destination.line_user_id, message)
        p response
      else
        message = {
        "type": "template",
          "altText": "送信相手が未選択のため、送信予定時刻にお手紙を送れませんでした。",
          "template": {
              "thumbnailImageUrl": "https://cdn.pixabay.com/photo/2016/09/10/17/17/letters-1659715_1280.jpg",
              "type": "buttons",
              "title": "FUTURE LETTER",
              "text": "送信予定時刻を過ぎました。\n送信時刻の再設定、お手紙を送る相手を選択しましょう。",
              "actions": [
                  {
                    "type": "uri",
                    "label": "お手紙を確認する",
                    "uri": "https://liff.line.me/#{liff_id}/letters/#{letter.id}/edit"
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
    letters = Letter.where('send_date <= ? and send_date > ?', Time.now.since(3.days), Time.now)
    letters.each do |letter|
      if SendLetter.where(letter_id: letter.id).blank?
        message = {
          "type": "template",
            "altText": "送信相手が選択されていないお手紙があります。",
            "template": {
                "thumbnailImageUrl": "https://cdn.pixabay.com/photo/2016/09/10/17/17/letters-1659715_1280.jpg",
                "type": "buttons",
                "title": "FUTURE LETTER",
                "text": "設定した送信日時が近くなりました。\nお手紙を送る相手を選択しましょう。",
                "actions": [
                    {
                      "type": "uri",
                      "label": "お手紙を確認する",
                      "uri": "https://liff.line.me/#{liff_id}/letters/#{letter.id}/edit"
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
end
