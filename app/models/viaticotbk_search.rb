class ViaticotbkSearch


	attr_reader :date_from,:date_to,:viaticotbk_id 


	def initialize(params)
		params ||={}

		@date_from = parsed_date(params[:date_from],7.days.ago.to_date.to_s)
		@date_to   = parsed_date(params[:date_to],Date.today.to_s)
		@viaticotbk_id = params[:viaticotbk_id]

    end

    def scope
    	 a = Cout.where('fecha BETWEEN ? AND ? and parent IS NULL ',@date_from,@date_to )


 		for detalle in a 


        if detalle.tbk > 0 

              @importe =  detalle.tbk  

         else 
             @importe =  0 

        end 
  
 		    d =	 ViaticotbkDetail.new

            d.viaticotbk_id = @viaticotbk_id 
            d.fecha         = detalle.fecha   
            d.document_id = 10 
            d.numero = detalle.code
            d.importe = @importe 
            d.detalle = " "
            d.tm = "10"
            d.tranportorder_id = detalle.tranportorder_id
            d.ruc = nil
            d.supplier_id = 2570 
            d.gasto_id = 338 
            d.employee_id = detalle.employee_id
            d.destino_id = 1 
            d.egreso_id =  18 
            d.cout_id = detalle.id 

            d.save 
            puts "grabacion....."

            detalle.update_attributes(parent: "1")


       end 


    @viaticotbk = Viaticotbk.find(@viaticotbk_id)

   begin
      @viaticotbk[:inicial] = @viaticotbk.get_total_inicial
    rescue
      @viaticotbk[:inicial] = 0
    end 
    
    begin
      @viaticotbk[:total_ing] = @viaticotbk.get_total_ing
    rescue 
      @viaticotbk[:total_ing] = 0
    end 
    begin 
      @viaticotbk[:total_egreso]=  @viaticotbk.get_total_sal
    rescue 
      @viaticotbk[:total_egreso]= 0 
    end 
  puts "+++++++++++++++++++++++++++++++++++++++++++"
  puts @viaticotbk[:inicial]
  puts @viaticotbk[:total_ing]
  puts @viaticotbk[:total_egreso]
 
    @viaticotbk[:saldo] = @viaticotbk[:inicial] +  @viaticotbk[:total_ing] - @viaticotbk[:total_egreso]

     puts @viaticotbk[:saldo]

        @viaticotbk.save
        
         if @viaticotbk.caja_id == 1 
          a = @cajas.find(1)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 
        if @viaticotbk.caja_id == 2
          a = @cajas.find(2)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 
        if @viaticotbk.caja_id == 3 
          a = @cajas.find(3)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 
        if @viaticotbk.caja_id == 4 
          a = @cajas.find(4)
          a.inicial =  @viaticotbk[:saldo]
          a.save
        end 
       

       

    end 


    private 
    def parsed_date(date_string,default)
    	 Date.parse(date_string)
    	rescue ArgumentError,TypeError
    	default 

    end 
    

    end 
