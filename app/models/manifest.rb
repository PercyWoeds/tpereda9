class Manifest < ActiveRecord::Base

belongs_to :customer 

belongs_to :company

belongs_to :location 
belongs_to :user 
belongs_to :punto 

  def get_customers()
    customers = Customer.order(:name)
    return customers
  end
 def get_puntos()
    puntos = Punto.all 
    return puntos
  end

def get_locations()

    locations = Location.where(company_id: 1).order("name ASC")
    
    return locations
  end


def get_processed
    if(self.processed == "1")
      return "Aprobado "

    elsif (self.processed == "2")
      
      return "**Anulado **"

    elsif (self.processed == "3")

      return "-Cerrado --"  
    else   
      return "Not yet processed"
        
    end
  end
  
  def get_punto(id)
        a = Punto.find(id)
        
        if a != nil 
           return a.name
        else
           return "No existe "
        end 
   end 
  
end
