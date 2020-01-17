class AddEgresoIdToViaticoDetails < ActiveRecord::Migration
  def change
    add_column :viatico_details, :egreso_id, :integer
  end
end
