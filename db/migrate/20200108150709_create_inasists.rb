class CreateInasists < ActiveRecord::Migration
  def change
    create_table :inasists do |t|
      t.string :name
      t.string :code

      t.timestamps null: false
    end
  end
end
