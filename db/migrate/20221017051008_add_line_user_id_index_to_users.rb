class AddLineUserIdIndexToUsers < ActiveRecord::Migration[6.1]
  def change
    add_index :users, :line_user_id, unique: true
  end
end
