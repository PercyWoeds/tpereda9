class AddOp1ToQuotations < ActiveRecord::Migration
  def change
    add_column :quotations, :op1, :string
    add_column :quotations, :op2, :string
    add_column :quotations, :op3, :string
    
  end
end
