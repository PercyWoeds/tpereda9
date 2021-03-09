class CreateTecnicRevisions < ActiveRecord::Migration
  def change
    create_table :tecnic_revisions do |t|
      t.string :code
      t.string :name

      t.timestamps null: false
    end
  end
end
