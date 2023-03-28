class AddColumnsToProducts < ActiveRecord::Migration[7.0]
  def change
    change_table :products do |t|
      t.boolean :enabled
      t.decimal :discount_price
      t.string :permalink
    end
  end
end
