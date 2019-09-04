class CreateTipocargues < ActiveRecord::Migration
  def change
    create_table :tipocargues do |t|
      t.string :code
      t.string :name

      t.timestamps null: false
    end
  end
end
