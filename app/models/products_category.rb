class ProductsCategory < ActiveRecord::Base
  self.per_page = 20
  
  validates_presence_of :company_id, :category
  
  belongs_to :company
  has_many :products
  before_destroy :check_for_products, prepend: true

  def self.import(file)
          CSV.foreach(file.path, headers: true) do |row|
          ProductsCategory.create! row.to_hash 
     end
  end 

  def check_for_products

        if  Product.where(products_category_id: self.id).any? 

       
            
              errors[:base] << "no puede eliminar categoria tiene productos asignados "
              return false
        
        end 
   end


end
