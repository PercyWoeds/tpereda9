class CreateConfigVehis < ActiveRecord::Migration
  def change
    create_table :config_vehis do |t|
      t.string :code
      t.string :name
      t.integer :user_id
      t.integer :company_id

      t.timestamps null: false
    end
  end
end
