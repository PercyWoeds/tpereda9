class AddDtToHorasme < ActiveRecord::Migration
  def change
    
    add_column :horas_mes, :lsg, :integer
    add_column :horas_mes, :lcg, :integer

    add_column :horas_mes, :vtavac, :integer
  end
end
