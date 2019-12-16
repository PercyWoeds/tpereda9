class AddHora1ToAssistances < ActiveRecord::Migration
  def change
    add_column :assistances, :hora1, :datetime
    add_column :assistances, :hora2, :datetime
    
  end
end
