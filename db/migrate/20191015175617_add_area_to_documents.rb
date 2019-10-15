class AddAreaToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :area, :string
  end
end
