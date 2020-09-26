class Truck < ActiveRecord::Base

validates_uniqueness_of :placa 


has_many :outputs,:dependent => :destroy 
has_many :tipo_unidads 


 before_destroy :check_for_trucks, prepend: true


    def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
            puts "placa21"
            puts row['placa']

            if a = Truck.find_by(placa: row['placa'].upcase.strip)

             
              puts row['placa']

            else
              puts "placa......"
              puts row['placa']


              Truck.create! row.to_hash 

              
            end 



        end
    end  



  def get_marcas()
   @marcas = Marca.all
    
    return @marcas
  end 


  def get_modelos()
     @modelos = Modelo.all
    
    return @modelos
  end  


 
  def get_tipos()
     @modelos = TipoUnidad.all
    
    return @modelos
  end  


 
  def get_config()
     @modelos = ConfigVehi.all
    
    return @modelos
  end  


 
  def get_clase()
     @modelos = ClaseCat.all
    
    return @modelos
  end  


 
  def get_color()
     @modelos = ColorVehi.all
    
    return @modelos
  end  



  

  def self.search(search)
      # Title is for the above case, the OP incorrectly had 'name'
      where("placa ilike ? OR certificado ilike ? OR licencia ilike ?", "%#{search}%","%#{search}%","%#{search}%")
  end
    
   def check_for_trucks

        if  Tranportorder.where(truck_id: self.id).any? || Serviceorder.where(truck_id: self.id).any? || Purchaseorder.where(self.id).any?
             Output.where(truck_id: self.id).any? 
            
              errors[:base] << "no puede eliminar marca porque esta siendo usado "
              return false
        
        end 
    end


  def generate_truck_number(serie)
    if Truck.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)") == nil 
      self.code = serie.to_s.rjust(3, '0') +"-000001"
    else
    self.code = serie.to_s.rjust(3, '0')+"-"+Truck.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)").next.to_s.rjust(6, '0') 
          
    end 
    
  end

end
