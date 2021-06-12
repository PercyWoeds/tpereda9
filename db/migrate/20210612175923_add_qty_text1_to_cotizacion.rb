class AddQtyText1ToCotizacion < ActiveRecord::Migration
  def change
    add_column :cotizacions, :qty_text1, :string
    add_column :cotizacions, :qty_text2, :string
    add_column :cotizacions, :qty_text3, :string
    add_column :cotizacions, :qty_text4, :string
    add_column :cotizacions, :qty_text5, :string
    add_column :cotizacions, :qty_text6, :string
  end
end
