class SupplierDetail < ActiveRecord::Base
  belongs_to :supplier
   validates_presence_of :supplier_id , :name, :telefono,:area,:cargo
 validates_format_of :correo, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

end
