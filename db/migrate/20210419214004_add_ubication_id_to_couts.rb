class AddUbicationIdToCouts < ActiveRecord::Migration
  def change
    add_column :couts, :ubication_id, :integer
    add_column :couts, :ubication2_id, :integer

  end
end
