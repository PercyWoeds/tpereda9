class Inasist < ActiveRecord::Base

	belongs_to :assistance 

	validates_uniqueness_of :code
    validates_presence_of :code, :name 
   
    
end
