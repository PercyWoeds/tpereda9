class AddCoutIdToViaticolgvDetails < ActiveRecord::Migration
  def change
    add_column :viaticolgv_details, :cout_id, :integer
  end
end
