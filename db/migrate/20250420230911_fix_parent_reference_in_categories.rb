class FixParentReferenceInCategories < ActiveRecord::Migration[7.2]
  def change
    # Supprimer l'ancienne contrainte s'il y en a une
    remove_foreign_key :categories, column: :parent_id rescue nil

    # Ajouter la bonne clé étrangère
    add_foreign_key :categories, :categories, column: :parent_id
  end
end
