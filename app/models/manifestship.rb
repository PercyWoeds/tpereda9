class Manifestship < ActiveRecord::Base

	belongs_to :manifest
	belongs_to :tranportorder
	

  validates_uniqueness_of :manifest_id 
  validates_uniqueness_of :tranportorder_id 

	def get_customers(id)
	    customers = Customer.find(id)
	    return customers.name 
	    
	end

	def get_code(id)

	   a =  Manifest.find(id)
	   return a.code 

	end 

end
