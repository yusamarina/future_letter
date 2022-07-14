class CreateLetterSendingDates < ActiveRecord::Migration[6.1]
  def change
    create_table :letter_sending_dates do |t|
      t.integer :destination_id, null: false, index: true
      t.references :letter, null: false, foreign_key: true
      t.datetime :send_date, null: false

      t.timestamps
    end
    add_foreign_key :letter_sending_dates, :users, column: :destination_id
  end
end
