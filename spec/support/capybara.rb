RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium, using: :chrome
    # ブラウザを非表示にする場合
    # driven_by :selenium, using: :headless_chrome
  end
end
