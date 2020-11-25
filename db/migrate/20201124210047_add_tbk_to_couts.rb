class AddTbkToCouts < ActiveRecord::Migration
  def change
    add_column :couts, :tbk, :float
    add_column :couts, :tbk_documento , :float
  end
end
