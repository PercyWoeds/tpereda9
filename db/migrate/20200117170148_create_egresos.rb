class CreateEgresos < ActiveRecord::Migration
  def change
    create_table :egresos do |t|
      t.string :code
      t.string :name
	  t.string :extension 


      t.timestamps null: false
    end
  end
end
