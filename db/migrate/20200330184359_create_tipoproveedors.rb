class CreateTipoproveedors < ActiveRecord::Migration
  def change
    create_table :tipoproveedors do |t|
      t.string :code
      t.string :name

      t.timestamps null: false
    end
  end
end
