class SupplierType < ActiveRecord::Base

  validates_presence_of :code, :name
  validates_uniqueness_of :code 
 
  belongs_to :supplier 
  

end
