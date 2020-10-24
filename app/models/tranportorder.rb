class Tranportorder < ActiveRecord::Base
self.per_page = 20

	validates_presence_of :location_id,:division_id,:code,:employee_id,:employee2_id,:employee3_id,:ubication_id,:ubication2_id,:truck_id,:truck2_id, :truck3_id
	validates_presence_of :fecha1,:fecha2 ,:customer_id 	
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

TABLE_HEADERS2 = ["NRO.COTIZACION",
                     "FECHA 
                     ST.",
                     "NRO.
                     ST",
                     "CLIENTE",
                     "CARGA",
                     "TIPO DE CARGA ",
                     "ORIGEN",
                  
                     "DESTINO",
                     "USD ",
                     "S/.FLETE",
                     "FECHA 
                     DE OST",
                     "NRO.
                     OST",
                     "CONDUCTOR 
                     INICIAL 
                     SERVICIO",
                     "CONDUCTOR 
                     FINAL DEL 
                     SERVICIO ",
                     "PLACA 
                  	   TRACTO ",
                     "PLACA
                     CAMION",
                     "PLACA 
                     SEMIREMOLQUE",                     
                     "TIPO 
                       UNIDAD ",
                     "PESO",
                     "ESCOLTA",
                     "NRO.ORDEN
                     SERVICIO",
                     "PLACA",
                     "CONDUCTOR",
                     "G.TRANSPORTISTA
                     PEREDA ",
                     "G.REMITENTE
                     CLIENTE ",
                     "FECHA LLEGADA
                     LIMA ",
                     "FECHA 
                     RECEPCION 
                     DE GUIAS",
                     "COMENTARIOS",
                     "CONFORMIDAD 
                     DEL SERVIIO",
                     "ESTATUS 
                     SERVICIO",
                     "FECHA DE 
                     CULMINO",
                     "OBSERVACIONES",
                     "NRO.OST
                       CLIENTE",
                       "NRO.FACTURA",
                       "FECHA 
                       FACTURA",
                       "TOTAL 
                       MONTO $",
                       "TOTAL 
                       MONTO USD",
                       "FECHA
                       RECEPCION 
                       CLIENTE ",
                       "FECHA 
                       COBRANZA
                       CLIENTE ",
                       "FECHA 
                       PAGO",
                       "IMPORTE"
                   
                     ]


 TABLE_HEADERS_OST = ["EMPRESA",
                     "NRO.GUIA",
                     "DESCRIPCION",
                     "PESO",
                     "PRECIO FACTURA"
                     ]


                     
 TABLE_HEADERS_OST2 = ["DATOS",
                     "PLACA",
                     "TIPO UNIDAD",
                     "CONFIGURACION",
                     "CLASE/CATEGORIA",
                     "COLOR",
                     "AÑO",
                     "MODELO",
                     "MARCA",
                     "CHV",
                     "N.EJES"
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

	  def get_propio(id)
	  	placa = Truck.find(id)
	  	return placa.propio

	  end 	

      def get_tipounidad(id)
	  	@tipounidad = Truck.find(id)
	  	return @tipounidad.tipo_unidad.name 
	  end 	

	  def get_configura(id)
	  	puts id 
	  	@tipounidad = Truck.find(id)
	  	return @tipounidad.config_vehi.name 

	  end 

	
	  def get_clase_cat(id)
	  	@tipounidad = Truck.find(id)
	  	return @tipounidad.clase_cat.name 
	  end 

	  def get_color_unid(id)
	  	@tipounidad = Truck.find(id)
	  	return @tipounidad.color_vehi.name 
	  end 

	    def get_anio(id)
	  	@tipounidad = Truck.find(id)
	  	return @tipounidad.anio  
	  end 
      def get_modelo(id)
	  	@tipounidad = Truck.find(id)
	  	return @tipounidad.modelo.descrip
	  end 
      def get_marca(id)
	  	@tipounidad = Truck.find(id)
	  	return @tipounidad.marca.descrip 
	  end 


	   def get_chv(id)
	  	@tipounidad = Truck.find(id)
	  	return @tipounidad.certificado
	  end 

    def get_ejes(id)
	  	@tipounidad = Truck.find(id)
	  	return @tipounidad.ejes 
	  end 




	  def get_dni(id)
	  	@tipounidad = Employee.find(id)
	  	return @tipounidad.idnumber
	  end 
      def get_licencia(id)
      	ret = " "

      	if Conductor.exists?(employee_id: id )

	  			@tipounidad = Conductor.find_by(employee_id: id)
	  			ret = @tipounidad.licencia 
	  	end

	  	return ret 
	  end 


       def get_tipocarga(id)
	  	@tipounidad = Tipocargue.find(id)
	  	return @tipounidad.name 
	  end 



	  def get_punto(id)
	  	punto = Punto.find(id)
	  	return punto.name 

	  end 	

	  def get_customers()
	    customers = Customer.order(:name)
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

    def get_facturas(id)


      if Manifestship.exists?(tranportorder_id: id )

    	   @dato = Manifestship.where(tranportorder_id: id )
         if @dato 
          @facturas = Factura.where(manifest_id: @dato.last.manifest_id )
         end 
         return @facturas 
      else
        return nil 
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


 def generate_ost_number(serie)
    if Tranportorder.where("cast(substring(code,1,3)  as int) = ? and fecha1 >?",serie,"2020-08-01 00:00:00").maximum("cast(substring(code,5,10)  as int)") == nil 
      self.code = serie.to_s.rjust(3, '0') +"-000001"
    else
    self.code = serie.to_s.rjust(3, '0')+"-"+Tranportorder.where("cast(substring(code,1,3)  as int) = ? and fecha1 >?",serie,"2020-08-01 00:00:00").maximum("cast(substring(code,5,10)  as int)").next.to_s.rjust(6, '0') 
          
    end 
    
  end

def add_catalogo(st)

	 merge = Manifestship.new(tranportorder_id:self.id, manifest_id: st)


	 if merge.save 

	 st = Manifest.find(st)
	 st.processed = "4"
	 st.save

	 end 


end 


def get_ejes2(id)
		ret   = 0
		ejes1 = 0
		ejes2 = 0

		a  = Tranportorder.find(id)


		 ejes1 = a.truck.ejes.to_i 

		b = Truck.find(a.truck2_id)
		if Truck.where(id: a.truck2_id).exists?

			d = Truck.find(a.truck2_id)

			ejes2 = d.ejes.to_i 


		else 
			ejes2 = 0 
		end 

		ret = ejes1 + ejes2 

		return ret.to_s 

		puts "ejees"
		puts ret
end 

end
