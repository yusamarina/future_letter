class RemoveSendDateFromLetterSendingDates < ActiveRecord::Migration[6.1]
  def change
    remove_column :letter_sending_dates, :send_date, :datetime
  end
end
