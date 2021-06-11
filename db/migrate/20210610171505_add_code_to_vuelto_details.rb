class AddCodeToVueltoDetails < ActiveRecord::Migration
  def change
    add_column :vuelto_details, :code, :string
  end
end
