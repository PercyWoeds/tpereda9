class AddPatToPayrollDetails < ActiveRecord::Migration
  def change
    add_column :payroll_details, :pat, :integer
  end
end
