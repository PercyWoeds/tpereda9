class Contactopmdetail < ActiveRecord::Base


  attr_accessible :sucursal, :contacto, :email, :telefono ,:cargo,:celular,:observa, :contactopmdetails_attributes

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  

   belongs_to :contactopm
end
