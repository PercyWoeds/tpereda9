class Punto < ActiveRecord::Base
   belongs_to :quotation 
   belongs_to :manifest 
   
   
       
end
