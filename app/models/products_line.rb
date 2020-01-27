class ProductsLine < ActiveRecord::Base
	validates_presence_of :code, :name
  
  belongs_to :company
  has_many :products

end
