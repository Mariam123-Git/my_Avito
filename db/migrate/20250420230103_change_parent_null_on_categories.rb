class ChangeParentNullOnCategories < ActiveRecord::Migration[7.2]
  def change
    change_column_null :categories, :parent_id, true
  end
end
