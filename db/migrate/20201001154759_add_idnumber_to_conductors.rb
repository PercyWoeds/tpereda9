class AddIdnumberToConductors < ActiveRecord::Migration
  def change
    add_column :conductors, :idnumber, :string
  end
end
