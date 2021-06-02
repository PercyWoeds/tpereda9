class Contactopmdetail < ActiveRecord::Base


  attr_accessible :sucursal, :contacto, :email, :telefono ,:cargo,:celular,:observa, :contactopmdetails_attributes


   belongs_to :contactopm
end
