class AddNumparteToProducts < ActiveRecord::Migration
  def change
    add_column :products, :numparte, :string
    add_column :products, :active, :string
    
  end
end
