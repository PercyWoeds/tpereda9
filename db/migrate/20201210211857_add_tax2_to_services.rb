class AddTax2ToServices < ActiveRecord::Migration
  def change
    add_column :services, :tax2, :float 
    add_column :services, :tax2_name, :string
  end
end
