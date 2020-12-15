class AddInstruccion6ToInstruccions < ActiveRecord::Migration
  def change
    add_column :instruccions, :instruccion6, :string
  end
end
