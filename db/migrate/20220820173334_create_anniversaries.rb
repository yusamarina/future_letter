class CreateAnniversaries < ActiveRecord::Migration[6.1]
  def change
    create_table :anniversaries do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.datetime :date, null: false
      t.text :description

      t.timestamps
    end
  end
end
