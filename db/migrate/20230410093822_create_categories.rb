class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :parent_id
      t.integer :products_count, default: 0

      t.timestamps
    end

    add_foreign_key :categories, :categories, column: :parent_id
  end
end
