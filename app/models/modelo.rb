class Modelo < ActiveRecord::Base
	validates_presence_of :company_id, :descrip
  validates_uniqueness_of :descrip 
  

  belongs_to :company
  
  has_many :trucks
  has_many :products
  

    def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|


              if a = Modelo.find_by(descrip: row['descrip'].upcase.strip)

           
              puts row['descrip']
            else

               new_hash = {}
                row.to_hash.each_pair do |k,v|
                  new_hash.merge!({k => v.upcase}) 
                end

               Modelo.create!(new_hash)
            end 

         
        end
    end     

    
    def self.to_csv(options = {})
      CSV.generate(options) do |csv|
      csv << column_names
      all.each do |customer|
        csv << customer.attributes.values_at(*column_names)
      end
    end   
  end 
  
end
