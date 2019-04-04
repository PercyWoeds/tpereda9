class AddExtIdToServiceorderServices < ActiveRecord::Migration
  def change
    add_column :serviceorder_services, :ext_id, :integer
    add_column :serviceorder_services, :name_ext, :string
  end
end
