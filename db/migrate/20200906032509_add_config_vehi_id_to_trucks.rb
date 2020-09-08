class AddConfigVehiIdToTrucks < ActiveRecord::Migration
  def change
    add_column :trucks, :config_vehi_id, :integer
     add_column :trucks, :clase_cat_id, :integer
      add_column :trucks, :color_vehi_id, :integer

  end
end
