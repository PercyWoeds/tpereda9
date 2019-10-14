class Manifestship < ActiveRecord::Base

	has_many :manifests 

	has_many :tranportorders 
	

	def get_customers(id)
	    customers = Customer.find(id)
	    return customers.name 
	    
	end
end
