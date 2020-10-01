class Manifestship < ActiveRecord::Base

	has_many :manifests 

	has_many :tranportorders 
	

  validates_uniqueness_of :manifest_id 
  validates_uniqueness_of :tranportorder_id 

	def get_customers(id)
	    customers = Customer.find(id)
	    return customers.name 
	    
	end
end
