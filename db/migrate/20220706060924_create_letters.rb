class CreateLetters < ActiveRecord::Migration[6.1]
  def change
    create_table :letters do |t|
      t.references :user, null: false, foreign_key: true
      t.references :template, null: false, foreign_key: true
      t.string :title
      t.text :body, null: false
      t.string :image

      t.timestamps
    end
  end
end
