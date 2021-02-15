class AddLugarToSupplier < ActiveRecord::Migration
  def change
    add_column :suppliers, :lugar, :text
  end
end
