class CreatePaymentNotices < ActiveRecord::Migration
  def change
    create_table :payment_notices do |t|
      t.string :code
      t.integer :employee_id
      t.string :asunto
      t.datetime :fecha
      t.string :concepto
      t.float :total
      t.string :processed
      t.datetime :date_processed

      t.timestamps null: false
    end
  end
end
