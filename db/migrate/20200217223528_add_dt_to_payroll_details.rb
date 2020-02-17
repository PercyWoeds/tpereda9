class AddDtToPayrollDetails < ActiveRecord::Migration
  def change
    add_column :payroll_details, :dt, :integer
  end
end
