class AddCvToConductors < ActiveRecord::Migration
  def change
    add_column :conductors, :cv, :string
    add_column :conductors, :cv1, :string
    add_column :conductors, :cv2, :string
    add_column :conductors, :cv3, :string
    add_column :conductors, :niveleducativo, :string
  end
end
