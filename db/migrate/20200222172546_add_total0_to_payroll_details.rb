class AddTotal0ToPayrollDetails < ActiveRecord::Migration
  def change
    add_column :payroll_details, :total0, :float
	add_column :payroll_details, :xdia, :float
	add_column :payroll_details, :hesab, :float
	add_column :payroll_details, :hedom, :float
	add_column :payroll_details, :he25, :float
	add_column :payroll_details, :he35, :float
	add_column :payroll_details, :he100, :float
	add_column :payroll_details, :prestamo, :float




  end
end
