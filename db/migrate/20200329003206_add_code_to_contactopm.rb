class AddCodeToContactopm < ActiveRecord::Migration
  def change
    add_column :contactopms, :code, :string
  end
end
