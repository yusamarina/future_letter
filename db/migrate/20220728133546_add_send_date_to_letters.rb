class AddSendDateToLetters < ActiveRecord::Migration[6.1]
  def change
    add_column :letters, :send_date, :datetime, null: false
  end
end
