class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.integer :line_id, null: false
      t.timestamps
    end
  end
end
