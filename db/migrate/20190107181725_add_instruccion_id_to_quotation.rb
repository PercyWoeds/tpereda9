class AddInstruccionIdToQuotation < ActiveRecord::Migration
  def change
  
  add_column :quotations, :instruccion_id, :integer
  end
end
