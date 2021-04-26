class AddActivedniToConductors < ActiveRecord::Migration
  def change
    add_column :conductors, :activedni, :string
  end
end
