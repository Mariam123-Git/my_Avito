class CreateListings < ActiveRecord::Migration[7.2]
  def change
    create_table :listings do |t|
      t.string :title
      t.text :description
      t.decimal :price
      t.boolean :active
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :city, null: false, foreign_key: true

      t.timestamps
    end
  end
end
