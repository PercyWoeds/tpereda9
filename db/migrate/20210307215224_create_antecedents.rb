class CreateAntecedents < ActiveRecord::Migration
  def change
    create_table :antecedents do |t|
      t.string :code
      t.string :name

      t.timestamps null: false
    end
  end
end
