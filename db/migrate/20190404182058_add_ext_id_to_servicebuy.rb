class AddExtIdToServicebuy < ActiveRecord::Migration
  def change
    add_column :servicebuys, :ext_id, :integer
    add_column :servicebuys, :name_ext, :string
  end
end
