class Contactopmdetail < ActiveRecord::Base



  attr_accessible :contacto, :telefono , :contactopmdetails_attributes

   belongs_to :contactopm
end
