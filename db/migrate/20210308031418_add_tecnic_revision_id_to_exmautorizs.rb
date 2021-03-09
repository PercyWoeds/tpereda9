class AddTecnicRevisionIdToExmautorizs < ActiveRecord::Migration
  def change
    add_column :exmautorizs, :tecnic_revision_id, :integer
  end
end
