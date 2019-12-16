class Assistance < ActiveRecord::Base

    def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          	
          	str = row['fecha']

        
          	 if str.include?"a. m."		
          		row['fecha'] = Time.zone.parse(str.sub('a. m.','a.m.'))
          	else
				row['fecha'] = Time.zone.parse(str.sub('p. m.','p.m.'))
          	end
          	
          	puts "fecha **"
          	puts str	
          	puts row['fecha'] 

            Assistance.create! row.to_hash 

        end
    end     

end
