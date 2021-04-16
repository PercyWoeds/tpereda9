class AddCvUrlToConductors < ActiveRecord::Migration
  def change
	add_column :conductors, :cv_url, :string
	add_column :conductors, :cv1_url, :string
	add_column :conductors, :cv2_url, :string
	add_column :conductors, :cv3_url, :string
  end
end
