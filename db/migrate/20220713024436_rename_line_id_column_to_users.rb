class RenameLineIdColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :line_id, :line_user_id
  end
end
