class CreateQuotationDetails < ActiveRecord::Migration
  def change
    create_table :quotation_details do |t|
      t.string :item
      t.string :descrip
      t.float :costo1
      t.float :costo2
      t.float :total
      
      t.timestamps null: false
    end
  end
end
