class AddTbkDocumentoToCouts < ActiveRecord::Migration
  def change
    add_column :couts, :tbk_documento, :string
  end
end
