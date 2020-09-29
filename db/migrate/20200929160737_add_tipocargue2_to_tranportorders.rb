class AddTipocargue2ToTranportorders < ActiveRecord::Migration
  def change
    add_column :tranportorders, :tipocargue_id, :integer
    add_column :tranportorders, :carga , :string
    
  end
end
