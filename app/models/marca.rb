class Marca < ActiveRecord::Base

		validates_presence_of :company_id, :descrip
    validates_uniqueness_of :descrip 
  
	  belongs_to :company
	  
	  has_many :trucks ,:dependent => :destroy 
	  has_many :products,:dependent => :destroy 
   
 before_destroy :check_for_trucks, prepend: true


    def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|

            if a = Marca.find_by(descrip: row['descrip'].upcase.strip)

             
              puts row['descrip']

            else

               new_hash = {}
                row.to_hash.each_pair do |k,v|
                  new_hash.merge!({k => v.upcase}) 
                end

               Marca.create!(new_hash)

              
            end 

        end
    end     

    def self.to_csv(options = {})
      CSV.generate(options) do |csv|
      csv << column_names
      all.each do |marca|
        csv << marca.attributes.values_at(*column_names)
      end
  	  end   
    end 


     def check_for_trucks
          if Truck.where(marca_id: self.id).any? || Product.where(marca_id: self.id).any?
            errors[:base] << "no puede eliminar marca porque esta siendo usado "
            return false
          end
      end

end
