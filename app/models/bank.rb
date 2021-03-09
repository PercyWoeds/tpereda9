class Bank < ActiveRecord::Base

	has_many :bank_acounts 
	has_many :monedas  
   has_many :suppliers 
   
end
