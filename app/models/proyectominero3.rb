class Proyectominero3 < ActiveRecord::Base

	 validates_presence_of :name
	 validates_uniqueness_of :code

	 has_many :proyecto_minero_exams
	 
	 

end
