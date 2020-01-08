class AddInasistToAssistances < ActiveRecord::Migration
  def change
    add_reference :assistances, :inasist, index: true, foreign_key: true
  end
end
