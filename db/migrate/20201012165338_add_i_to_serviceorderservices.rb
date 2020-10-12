class AddIToServiceorderservices < ActiveRecord::Migration
  def change
    add_column :serviceorder_services, :i, :integer
  end
end
