class AddCarrToCouts < ActiveRecord::Migration
  def change
    add_column :couts, :carr, :string
  end
end
