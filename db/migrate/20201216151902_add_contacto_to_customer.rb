class AddContactoToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :contacto, :string
    add_column :customers, :sr,   :string 

  end
end
