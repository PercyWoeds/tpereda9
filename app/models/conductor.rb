class Conductor < ActiveRecord::Base
  belongs_to :employee


  validates_presence_of :employee_id
  validates_uniqueness_of :employee_id


    def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|

	          if Employee.where(idnumber: row["idnumber"]).exists? 

	          		  a = Employee.find_by(idnumber: row["idnumber"])	
	          	     row["employee_id"] = a.id 

	          		 Conductor.create! row.to_hash 
	          		 puts a.id 
	          		 puts row['licencia']
	          		 puts row['idnumber']

	         end


          end     

    end 
end
