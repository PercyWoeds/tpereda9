class CreateServiceExtensions < ActiveRecord::Migration
  def change
    create_table :service_extensions do |t|
      t.string :code
      t.string :name
      t.references :servicebuy, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
