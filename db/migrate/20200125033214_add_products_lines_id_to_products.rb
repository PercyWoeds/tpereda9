class AddProductsLinesIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :products_lines_id, :integer
  end
end
