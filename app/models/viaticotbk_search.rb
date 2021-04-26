class ViaticotbkSearch


	attr_reader :date_from,:date_to,:viaticotbk_id 


	def initialize(params)
		params ||={}

		@date_from = parsed_date(params[:date_from],7.days.ago.to_date.to_s)
		@date_to   = parsed_date(params[:date_to],Date.today.to_s)
		@viaticotbk_id = params[:viaticotbk_id]

    end

    def scope
    	 a = Cout.where('fecha BETWEEN ? AND ?',@date_from,@date_to)


 		for detalle in a 

  
 		    d =	 ViaticotbkDetail.new

            d.viaticotbk_id = @viaticotbk_id 
            d.fecha         = detalle.fecha   
            d.document_id = 10 
            d.numero = detalle.code
            d.importe = detalle.tbk  
            d.detalle = detalle.truck.placa + " / " + detalle.get_placa(detalle.truck2_id) +    detalle.get_placa(detalle.truck3_id)
            d.tm = "10"
            d.tranportorder_id = detalle.tranportorder_id
            d.ruc =nil
            d.supplier_id = 2570 
            d.gasto_id = 338 
            d.employee_id = detalle.employee_id
            d.destino_id = 1 
            d.egreso_id =  18 

            d.save 
            puts "grabacion....."

       end 

       

    end 


    private 
    def parsed_date(date_string,default)
    	 Date.parse(date_string)
    	rescue ArgumentError,TypeError
    	default 

    end 
    

    end 
