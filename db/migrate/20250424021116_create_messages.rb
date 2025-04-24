class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.references :sender, null: false, foreign_key: true
      t.references :recipient, null: false, foreign_key: true
      t.text :content
      t.boolean :read
      t.references :listing, null: false, foreign_key: true

      t.timestamps
    end
  end
end
