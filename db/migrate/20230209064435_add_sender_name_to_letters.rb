class AddSenderNameToLetters < ActiveRecord::Migration[6.1]
  def change
    add_column :letters, :sender_name, :string
  end
end
