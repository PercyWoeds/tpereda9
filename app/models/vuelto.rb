class Vuelto < ActiveRecord::Base


    
self.per_page = 20


  validates_presence_of   :code, :user_id,:fecha,:processed 
  validates_uniqueness_of :code 

  
  
  belongs_to :user
  
  has_many   :vuelto_details , :dependent => :destroy
  
  
   TABLE_HEADERS = ["ITEM",
                      "FECHA ",
                     "DESCRIPCION",
                     "TD",
                     "NRO DOCUMENTO",
                     "IMPORTE S/.",
                     "DETALLE"
                     ]

   TABLE_HEADERS2 = ["ITEM",
                      "FECHA ",
                     "COMPRO",
                     "CONDUCTOR",
                     "PLACA",
                     "DESTINO",
                     "DESCRIPCION",

                     "VUELTO S/.",
                     "FLETE S/.",
                     "EGRESO S/.",
                     "TOTAL  S/.",
                     "VB.
                      ASISTENTE GERENCIA",
                     "VB. GERENTE ADMIN."
                     ]
  

  def self.search(search)
      where("code LIKE ?", "%#{search}%") 
        
  end



  def self.to_csv(result)
    unless result.nil?
      CSV.generate do |csv|
        csv << result[0].attributes_names
        result.each do |row|
          csv << row.attributes.values
        end
      end
    end   
  end

 

  def get_moneda(id)
    a = Moneda.find(id)

    return a.description
  end
  def get_vencido

      if(self.fecha2 < Date.today)   

        return "** Vencido ** "
      else
        return ""
      end 

  end 

  def my_deliverys
        @deliveryships = Delivery.all 
        return @deliveryships
  end 



  def generate_viatico_number
    if Vuelto.maximum("cast(code  as int)") == nil 
      self.code = "000001"
    else
    self.code = Vuelto.maximum("cast(code  as int)").next.to_s.rjust(6, '0') 
          
    end 
    return self.code 
  end



  
   def get_total_inicial
  
    subtotal = self.inicial
    
    return subtotal 
    
  end
  
  def get_total_ing
    subtotal = 0
    
    @viatico_details = ViaticoDetail.where(viatico_id: self.id)
    
    for item in  @viatico_details 
    
        if item.egreso_id  ==  1 
          total = item.importe
        else
          total = 0
        end
        
        begin
          subtotal += total
        rescue
        end
        
      end
  
    
    return subtotal
  end

   def get_viatico_suma
    subtotal = 0
    

    @viatico_suma = ViaticoDetail.select("documents.orden","documents.descripshort", "SUM(importe) as total ").
    where("viatico_id = ?  and egreso_id > 1 ",self.id).joins(:document).group("documents.orden,documents.descripshort").order("documents.orden,documents.descripshort")
  
   
    return @viatico_suma
  end
  
  
  def get_total_sal
    subtotal = 0
      
    @viatico_details = ViaticoDetail.where(viatico_id: self.id)
    
  for item in  @viatico_details 
  
    
         
        if item.egreso_id == 1
            total = 0
          else
            total = item.importe
          end 
        
        begin
          subtotal += total
        rescue
        end
        
      end
  
    return subtotal
  end


  def get_total_saldo_documento
    subtotal = 0
      
    @viatico_details = ViaticoDetail.where(viatico_id: self.id,document_id: 1 )
    
  for item in  @viatico_details 
  
    
         
        if item.egreso_id == 1
            total = 0
          else
            total = item.importe
          end 
        
        begin
          subtotal += total
        rescue
        end
        
      end
 @viatico_details = ViaticoDetail.where(viatico_id: self.id,document_id: 7 )
    
  for item in  @viatico_details 
  
    
         
        if item.egreso_id == 1
            total = 0
          else
            total = item.importe
          end 
        
        begin
          subtotal += total
        rescue
        end
        
      end

@viatico_details = ViaticoDetail.where(viatico_id: self.id,document_id: 3 )
    
  for item in  @viatico_details 
  
    
         
        if item.egreso_id == 1
            total = 0
          else
            total = item.importe
          end 
        
        begin
          subtotal += total
        rescue
        end
        
      end


@viatico_details = ViaticoDetail.where(viatico_id: self.id,document_id: 2 )
    
  for item in  @viatico_details 
  
    
         
        if item.egreso_id == 1
            total = 0
          else
            total = item.importe
          end 
        
        begin
          subtotal -= total
        rescue
        end
        
      end

    return subtotal
  end

  
  
  
  def delete_products()
    invoice_services = ViaticoDetail.where(viatico_id: self.id)
    
    for ip in invoice_services
      ip.destroy
    end
  end
  
  def add_products(items)

     items = items 
     items = items.split(",")
     total   = 0 
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id       = parts[0]
        importe  = parts[1].to_f
        fecha     = parts[2].to_date 
         
        puts "detalle...."

        
        total    +=  importe
        
       
          puts id 
        puts importe
        puts fecha 
        puts total 
        puts self.id 


          new_vuelto_product = VueltoDetail.new(fecha: fecha , cout_id: id , importe: importe, flete: 0, egreso: 0,total: total , observa: "-", vuelto_id: self.id )
          begin                       
          new_vuelto_product.save
          rescue 
          end 
          
    
      end
    end
  end

  
  def add_guias(items)
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        
        begin
          @guia = Delivery.find(id.to_i)

          @guia.processed='4'
          @guia.facturar 
          
          new_invoice_guia = Deliveryship.new(:factura_id => self.id, :delivery_id => @guia.id)          
          new_invoice_guia.save
           
        rescue
          
        end
      end
    end
  end
  

 def delete_guias()
    invoice_guias = Deliveryship.where(factura_id: self.id)
    
    for ip in invoice_guias
      ip.destroy
    end
  end

  def identifier
    return "#{self.code} "
  end
  def get_viaticos
      @viaticos = ViaticoDetail.where("viatico_id = ? ",self.id).order(:destino_id,:id,:document_id)
  end

  def get_egresos

      @viaticos_egresos = Egreso.where("id> 1 and extension <> ?","TBK")

  end 

  def get_egresos_caja

      @viaticos_egresos = Egreso.where("id> 1 and extension = ?","CAJA")

  end 

 def get_egresos_tbk

      @viaticos_egresos = Egreso.where("id> 1 and extension = ?","TBK")

  end 

 

  def get_ingresos

      @viaticos_egresos = Egreso.where(id: 1  )

  end 


  def get_egresos_tot

      @viaticos = ViaticoDetail.select("sum(importe)  as total ").where("viatico_id = ? and egreso_id > 1 ",self.id).group(:viatico_id).order(:viatico_id)

     if @viaticos

        return @viaticos.first.total 

      else
        return 0 
      end 
  end 


  def get_ingresos_tot 

      @viaticos = ViaticoDetail.select("sum(importe)  as total ").where("viatico_id = ? and egreso_id = 1 ",self.id).group(:viatico_id).order(:viatico_id)
      if @viaticos

        return @viaticos.first.total 

      else
        return 0 
      end 

  end 

 

  def get_egresos_suma

     @viaticos = ViaticoDetail.select("egreso_id,sum(importe)  as total ").where("viatico_id = ? and egreso_id > 1 ",self.id).group(:egreso_id).order(:egreso_id)

  end 

  def get_viaticos_cheque
      lcCheque = 6
      @viaticos = ViaticoDetail.where("viatico_id = ? and document_id = ?",self.id, lcCheque).order(:destino_id,:id,:document_id)
  end

  def get_viaticos_lima
      lcCheque = 6
      @viaticos = ViaticoDetail.where("viatico_id = ? and document_id <> ? and destino_id = ? ",self.id, lcCheque,1).order(:destino_id,:id,:document_id)
  end
  
  def get_viaticos_provincia
      lcCheque = 6
      @viaticos = ViaticoDetail.where("viatico_id = ? and document_id <> ? and destino_id = ?",self.id, lcCheque,2).order(:destino_id,:id,:document_id)
  end
  

  def get_invoices
    @facturas= Factura.find_by_sql(['Select facturas.*,customers.ruc,payments.descrip from facturas 
      LEFT JOIN customers on facturas.customer_id = customers.id 
      LEFT JOIN payments  on facturas.payment_id = payments.id'])
      return @facturas
  end 

  def get_facturas(id)
  
    @facturas= Factura.where(["balance > 0  and customer_id = ?",  id ])

    return @facturas
  end 


  
  def get_products2(id)    
    @itemproducts = InvoiceService.find_by_sql(['Select invoice_services.price,
      invoice_services.quantity,invoice_services.discount,invoice_services.total,services.name 
     from invoice_services INNER JOIN services ON invoice_services.service_id = services.id where invoice_services.factura_id = ?', id ])
    
    return @itemproducts
  end

  def get_products    
    @itemproducts = InvoiceService.find_by_sql(['Select invoice_services.price,
    	invoice_services.quantity,invoice_services.discount,invoice_services.total,services.name 
  	 from invoice_services INNER JOIN services ON invoice_services.service_id = services.id where invoice_services.factura_id = ?', self.id ])
    
    return @itemproducts
  end
  
  def get_guias    
    @itemguias = Deliveryship.find_by_sql(['Select deliveries.id,deliveries.code,deliveries.description 
     from deliveryships INNER JOIN deliveries ON deliveryships.delivery_id =  deliveries.id where deliveries.remision=2 and  deliveryships.factura_id = ?', self.id ])
    return @itemguias
  end

  def get_guiasremision 
    @itemguias1 = Deliveryship.find_by_sql(['Select deliveries.code 
     from deliveryships INNER JOIN deliveries ON deliveryships.delivery_id =  deliveries.id where deliveries.remision=1 and  deliveryships.factura_id = ?', self.id ])
    return @itemguias1
  end
  def get_guias2(id)    
    @itemguias = Deliveryship.find_by_sql(['Select deliveries.id,deliveries.code,deliveries.description,deliveries.processed
     from deliveryships INNER JOIN deliveries ON deliveryships.delivery_id =  deliveries.id where deliveries.remision=2 and  deliveryships.factura_id = ?', id ])
    return @itemguias
  end

  def get_guiasremision2(id)
    @itemguias1 = Deliveryship.find_by_sql(['Select deliveries.code 
     from deliveryships INNER JOIN deliveries ON deliveryships.delivery_id =  deliveries.id where deliveries.remision=1 and  deliveryships.factura_id = ?', id ])
    return @itemguias1
  end

  def get_guias_remision(id)    
        
    guias = []
    invoice_guias = Deliverymine.where(:mine_id => id)
    return invoice_guias
        
  end
  

  def get_invoice_products
    invoice_products = InvoiceService.where(factura_id:  self.id)    
    return invoice_products
  end
  
  def viaticos_lines
    services = []
    
    viatico_header = Viatico.where(id: self.id)
    
    invoice_products = ViaticoDetail.where(viatico_id:  self.id)
    
    
    viatico_header.each do  | ip |
      
      inicial = ip.inicial 
      
    end 
    
    
    
    
    ruc = ""
    gasto = 0
    i= 0  
    
      invoice_products.each do | ip |
      i +=1
      ip.tranportorder[:CurrTotal] = ip.importe
      ip.tranportorder[:detalle] = ip.detalle
      ip.tranportorder[:tm]      = ip.tm
      ip.tranportorder[:comprobante]  = ip.descrip
      ip.tranportorder[:fecha]  = ip.fecha 
      ip[:supplier_id] = ip.supplier_id
      ip[:gasto_id]    = ip.gasto_id
      
      services.push("#{ip.tranportorder.id}|BRK|#{ip.tranportorder.CurrTotal}|BRK|#{ip.tranportorder.detalle}|BRK|#{ip.tranportorder.tm}|BRK|#{inicial}|BRK|#{ip.tranportorder.comprobante}|BRK|#{ip.tranportorder.fecha}|BRK|#{ip.supplier_id}|BRK|#{ip.gasto_id} ")
    end
    
    return services.join(",")
  end
  
  def guias_lines
    guias = []
    invoice_guias = DeliveryShip.where(factura_id:  self.id)
    
    invoice_guias.each do | ip |
      guias.push("#{ip.delivery.id}|BRK|")
    end    

    return guias.join(",")
  end
  
    def get_processed
    if(self.processed == "1")
      return "Aprobado "

    elsif (self.processed == "2")
      
      return "**Anulado **"

    elsif (self.processed == "3")

      return "-Cerrado --"  

    elsif (self.processed == "4")

      return "-Facturado --"  

    else   
      return "No Aprobado"
        
    end
  end
  
  def get_processed_short
    if(self.processed == "1")
      return "Yes"
    elsif (self.processed == "3")
       return "Yes"
    else
      return "No"
    end
  end
  
  def get_return
    if(self.return == "1")
      return "Yes"
    else
      return "No"
    end
  end
  # Process the invoice
  def process
    if(self.processed == "1" or self.processed == true)          
      self.processed="1"
      self.date_processed = Time.zone.now
      self.save
    end
  end
  def cerrar
    if(self.processed == "3" )         
      
      self.processed="3"
      self.date_processed = Time.now
      self.save
    end
  end
  
  # Process the invoice
  def anular
    if(self.processed == "2" )          
      self.processed="2"
      self.subtotal =0
      self.tax = 0
      self.total = 0
      self.balance = 0
      
      self.date_processed = Time.now
      self.save
    end
  end

  def processed_color
    if(self.processed == "1")
      return "green"
    else
      return "red"
    end
  end
 
  def correlativo      
        numero = Voided.find(13).numero.to_i + 1
        lcnumero = numero.to_s
        Voided.where(:id=>'13').update_all(:numero =>lcnumero)        
  end

  def get_cheque
    @viatico_details
   if   ViaticoDetail.exists?(document_id: 6 , viatico_id: self.id)


        return ViaticoDetail.exists?(document_id: 6 , viatico_id: self.id).first        

   end 
 end 


  def get_proveedor(id)

if   a= Supplier.where(id: id ).exists? 

           category = Supplier.find(id)

           return category.name
      else

           return "proveedor no existe."
      end 
  end

  def get_empleado(id)
    if   a= Employee.where(id: id ).exists? 

           category = Employee.find(id)

           return category.full_name2 
      else

           return "Employee no existe."
      end 
  end  



    def get_total 

    facturas = VueltoDetail.where(vuelto_id: self.id)
     ret = 0  


    if facturas
    

      for factura in facturas      
       
          ret += factura.total
        
      end
    end 


    return ret
   
    

    end 





end
