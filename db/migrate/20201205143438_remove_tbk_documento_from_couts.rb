class RemoveTbkDocumentoFromCouts < ActiveRecord::Migration
  def change
    remove_column :couts, :tbk_documento, :string
  end
end
