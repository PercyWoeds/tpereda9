class AddHoraEfectivo2ToAssistances < ActiveRecord::Migration
  def change
    add_column :assistances, :hora_efectivo2, :datetime
  end
end
