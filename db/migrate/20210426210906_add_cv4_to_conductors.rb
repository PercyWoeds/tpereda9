class AddCv4ToConductors < ActiveRecord::Migration
  def change
		add_column :conductors, :cv4, :string
		add_column :conductors, :cv5, :string
		add_column :conductors, :cv6, :string
		add_column :conductors, :cv7, :string
		add_column :conductors, :cv8, :string

		add_column :conductors, :cv4_url, :string
		add_column :conductors, :cv5_url, :string
		add_column :conductors, :cv6_url, :string
		add_column :conductors, :cv7_url, :string
		add_column :conductors, :cv8_url, :string

		end
end
