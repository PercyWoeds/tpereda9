class AddCodeToAutoviatics < ActiveRecord::Migration
  def change
    add_column :autoviatics, :code, :string
  end
end
