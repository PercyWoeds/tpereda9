class AddOstExistToCouts < ActiveRecord::Migration
  def change
    add_column :couts, :ost_exist, :string
  end
end
