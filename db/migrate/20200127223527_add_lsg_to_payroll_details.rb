class AddLsgToPayrollDetails < ActiveRecord::Migration
  def change
    add_column :payroll_details, :lsg, :integer
    add_column :payroll_details, :lcg, :integer
    add_column :payroll_details, :vtavac, :integer
  
  end
end
