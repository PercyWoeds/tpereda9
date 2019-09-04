class AddTipocarIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :tipocar_id, :integer
  end
end
