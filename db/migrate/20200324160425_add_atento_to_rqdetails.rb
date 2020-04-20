class AddAtentoToRqdetails < ActiveRecord::Migration
  def change
    add_column :rqdetails, :atento, :string
  end
end
