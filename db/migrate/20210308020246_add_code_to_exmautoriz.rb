class AddCodeToExmautoriz < ActiveRecord::Migration
  def change
    add_column :exmautorizs, :code, :string
  end
end
