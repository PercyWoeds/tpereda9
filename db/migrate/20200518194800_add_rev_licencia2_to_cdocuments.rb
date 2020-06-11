class AddRevLicencia2ToCdocuments < ActiveRecord::Migration
  def change
    add_column :cdocuments, :rev_licencia2, :string
  end
end
