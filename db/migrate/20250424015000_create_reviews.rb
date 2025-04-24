class CreateReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :reviews do |t|
      t.integer :rating
      t.text :comment
      t.references :user, null: false, foreign_key: true
      t.references :reviewer, null: false, foreign_key: true

      t.timestamps
    end
    # utilisateur ne peut laisser qu'un avis par utilisateur)
    add_index :reviews, [ :reviewer_id, :user_id ], unique: true
  end
end
