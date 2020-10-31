class AddStanfByPenToManifest < ActiveRecord::Migration
  def change
    add_column :manifests, :stand_by_pen, :float
    add_column :manifests, :escolta_pen, :float
  end
end
