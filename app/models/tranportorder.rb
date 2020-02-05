class Tranportorder < ActiveRecord::Base
self.per_page = 20

	validates_presence_of :location_id,:division_id,:code,:employee_id,:employee2_id,:ubication_id,:ubication2_id,:truck_id,:truck2_id
	validates_presence_of :fecha1,:fecha2 	
     validates_uniqueness_of :code

	belongs_to :company
  	belongs_to :location
  	belongs_to :division 
  	belongs_to :user  
	belongs_to :customer
	belongs_to :employee
	belongs_to :punto 
	belongs_to :truck
	belongs_to :delivery
	belongs_to :punto 

	belongs_to :manifestship 
	

 TABLE_HEADERS = ["ITEM",
                     "CODIGO",
                     "EMPLEADO",
                     "PLACA",
                     "DESDE",
                     "HASTA",
                     "FEC.INICIO",
                     "FEC.FIN",                     
                     "ESTADO"]
TABLE_HEADERS2 = ["ITEM",
                     "NRO.OST.",
                     "FEC.
                     GUIA",
                     "DIAS",
                     "GUIA",
                     "FEC.
                     INICIO",
                     "FEC.
                     TRASLADO",
                     "FEC.
                     RECEP.",
                     "C L I E N T E",
                     "PLACA",
                     "CONDUCTOR",                     
                     "DESTINO",
                     "TOTAL",
                     "DIA",
                     "FACTURA",
                     "FEC.FACTURA
                     /FEC.PAGO",
                     "DIAS CREDITO"
                     ]
 TABLE_HEADERS_OST = ["EMPRESA",
                     "NRO.GUIA",
                     "DESCRIPCION",
                     "PESO",
                     "PRECIO FACTURA"
                     ]

	def self.search(search)
		  where("code LIKE ?", "%#{search}%") 
  		  
	end


	 def identifier
	    return "#{self.code} - #{self.employee.full_name}"
	 end
	 	
     def get_delivery(id)
     	if id != nil || id !="" || id.blank? ==false || id.empty? == false 
		  	guia = Delivery.where("tranportorder_id = ? and processed <> ? ",id,"2")
		  	return guia
		end	
     end 
    
	  def get_empleado(id)
	  	if id != nil || id !="" || id.blank? ==false || id.empty? == false 
		  	empleado = Employee.find_by(id: id)
		  	begin 
				return empleado.full_name
		  		rescue
		  			return ""
		  	end 
	  else
			return ""  	
	  	end	
	  end 	

	  def get_placa(id)
	  	placa = Truck.find(id)
	  	return placa.placa

	  end 	
	  def get_punto(id)
	  	punto = Punto.find(id)
	  	return punto.name 

	  end 	

	  def get_customers()
	    customers = Customer.all
	    return customers
	  end
	 

	  def get_puntos()
	    puntos = Punto.all.order(:name)
	    return puntos
	  end

	  def get_employees()
	    empleados = Employee.where(:active =>"1").order(:full_name)
	    return empleados
	  end


		def correlativo		
			numero=Voided.find(8).numero.to_i + 1
			lcnumero=numero.to_s
			Voided.where(:id=>'8').update_all(:numero =>lcnumero)        
		end


	  def get_processed
	    if(self.processed == "1")
	      return "Aprobado "
	    elsif (self.processed == "2")      
	      return "**Anulado **"
	    elsif (self.processed == "3")      
	      return "* Cerrado **"
	    elsif (self.processed == "4")        
	      return "* Facturado **"
	    else 
	      return "No Aprobado"
	    end



	  
    end



  def add_guias(items)
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        
        begin
          @guia = Manifest.find(id.to_i) 
          
          new_invoice_guia = Manifestship.new(:tranportorder_id => self.id, :manifest_id => @guia.id)          
          new_invoice_guia.save
           
        rescue
          
        end
      end
    end
  end

   def get_sts
    @itemguias = Manifestship.find_by_sql(['Select manifests.id,manifests.code,manifests.customer_id ,manifests.solicitante,manifests.fecha1 
     from manifestships INNER JOIN manifests ON manifestships.manifest_id =  manifests.id where  manifestships.tranportorder_id = ?', self.id ])
    return @itemguias
  end

end
