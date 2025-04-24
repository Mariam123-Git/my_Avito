class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :phone_number
      t.text :bio
      t.boolean :admin

      t.timestamps
    end
  end
end
