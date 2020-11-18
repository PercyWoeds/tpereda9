class AddDocumento2ToInvoicesunat < ActiveRecord::Migration
  def change
    add_column :invoicesunats, :documento2, :string
  end
end
