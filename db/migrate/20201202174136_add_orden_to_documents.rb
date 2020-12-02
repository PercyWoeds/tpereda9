class AddOrdenToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :orden, :string
  end
end
