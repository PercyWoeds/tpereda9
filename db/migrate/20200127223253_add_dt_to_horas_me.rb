class AddDtToHorasMe < ActiveRecord::Migration
  def change
    add_column :horas_mes, :otros, :integer
  end
end
