class CreateSupplierTypes < ActiveRecord::Migration
  def change
    create_table :supplier_types do |t|
      t.string :code
      t.string :name

      t.timestamps null: false
    end
  end
end
