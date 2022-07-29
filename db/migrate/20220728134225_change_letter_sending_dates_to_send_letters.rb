class ChangeLetterSendingDatesToSendLetters < ActiveRecord::Migration[6.1]
  def change
    rename_table :letter_sending_dates, :send_letters
  end
end
