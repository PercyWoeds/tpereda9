class AddInstruccion6ToInstruccions < ActiveRecord::Migration
  def change
    add_column :instruccions, :instruccion6, :text
    add_column :instruccions, :instruccion7, :text
    add_column :instruccions, :instruccion8, :text
    add_column :instruccions, :instruccion9, :text
    add_column :instruccions, :instruccion10, :text



  end
end
