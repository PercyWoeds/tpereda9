class AddFactuToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :factu, :string
  end
end
