class ChangeLettersTitleNotNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :letters, :title, false
  end
end
