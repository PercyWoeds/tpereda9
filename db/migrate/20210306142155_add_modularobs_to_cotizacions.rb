class AddModularobsToCotizacions < ActiveRecord::Migration
  def change
    add_column :cotizacions, :modularobs, :string
  end
end
