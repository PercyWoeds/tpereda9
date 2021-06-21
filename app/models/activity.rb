class Activity < ActiveRecord::Base

   

   has_many :mnto_details 

	 def self.import(file)



          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1') do |row|
          Activity.create! row.to_hash 
        end
     end     


end
