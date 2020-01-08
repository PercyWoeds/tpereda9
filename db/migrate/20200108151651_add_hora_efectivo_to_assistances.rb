class AddHoraEfectivoToAssistances < ActiveRecord::Migration
  def change
    add_column :assistances, :hora_efectivo, :datetime
    add_column :assistances, :observacion, :string 
    
  end
end
