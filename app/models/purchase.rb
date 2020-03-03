class Purchase < ActiveRecord::Base
  self.per_page = 20
  
  validates_presence_of :company_id, :supplier_id, :documento,:document_id,:date1,:date2,:date3, :moneda_id,:almacen_id 
  validates :documento , uniqueness:{ scope:[:supplier_id, :document_id,:moneda_id]}


  belongs_to :company
  belongs_to :location
  belongs_to :division
  belongs_to :supplier 
  belongs_to :user  
  belongs_to :document
  belongs_to :moneda
  belongs_to :payment
  belongs_to :product 
   belongs_to :almacen 
   
  
  belongs_to :purchaseorder

  has_many :purchase_details

TABLE_HEADERS  = ["ITEM ",
                      "PROVEEDOR",
                     "ORDEN",
                     "FECHA ",
                     "CANTIDAD",
                     "CODIGO",
                     "PRODUCTO",
                     "COSTO",
                     "TOTAL "]



TABLE_HEADERS2  = ["ITEM ",
                      "CATEGORIA",
                      "DOCUMENTO",
                     "FECHA",
                     "CODIGO",
                     "PRODUCTO",
                     "UNIDAD",
                     "CANTIDAD",
                     "COSTO US$",
                     "COSTO S/.",
                     "TOTAL US$",
                     "TOTAL S/"
                     ]


 TABLE_HEADERS3 = ["TD",
                      "Documento",
                     "Fecha",
                     "Fec.Vmto",
                     "Proveedor",
                     "Moneda",  
                     "Percepcion",  
                     "SOLES",
                     "DOLARES ",
                     "OBSERV"]

 TABLE_HEADERS4 = ["TD",
                      "DOCUMENTO",
                     "FECHA",
                     "CODIGO",
                     "DESCRIPCION",
                     "UNIDAD",                                         
                     "PROVEEDOR",
                     "CANTIDAD ",
                     "COSTO US$ ",
                     "COSTO S/.",
                     "TOTAL S/."
                     ]                     
 
TABLE_HEADERS6 = ["ITEM",
                     "RUC" ,
                     "CLIENTE",   
                     "al 2017",                  
                    "2018",
                    "2019",             
                    "2020",
                    "2021",
                    "2022",
                    "2023",
                    "2024",
                    "General (1)" ,            
                    "Cant.Fact.",
                    "Compras (2) " ,
                    "Cant.Fact.",
                    "Tot.Gral ",     
                    "Cant.Fact.",     
                    "Vmto. (3)",
                    "Por Pagar " ,
                    "Pago Detrac. ",
                    "SALDO   "]

  TABLE_HEADERS7  = ["ITEM ",
                      "CATEGORIA",
                     "DESCRIPCION",
                     "TOTAL "]

  TABLE_HEADERS8  = ["ITEM ",
                     "DESCRIPCION",
                     "PROVEEDOR",
                     "FECHA",
                     "TD",
                     "DOCUMENTO",
                     "PRODUCTO",
                     "CANTIDAD",
                     "PRECIO",
                     "TOTAL "]
TABLE_HEADERS30 = ["TD",
                      "Documento",
                     "Fecha",
                     "Fec.Vmto",
                     "Proveedor",
                     "Moneda",  
                     "SOLES",
                     "DOLARES ",
                     "OBSERV"]


TABLE_HEADERS31= ["ITEM","PROVEEDOR","TD",
                      "Nro.Docmto.",
                     "DESCRIPCION",
                     "FECHA
                     EMISION",
                     "FECHA 
                     RECEP",
                     "FECHA 
                     VMTO.",
                     "S/.",  
                     "US$",  
                     "DESTINO",
                     "COMPRADOR ",
                     "OBSERVACION",
                     "METODO DE PAGO",
                     "V.B. ENTREGA"]


    def get_general(fecha1,fecha2,proveedor,moneda)

      a =  Purchase.find_by_sql(["
   SELECT   SUM(balance) as balance
   FROM purchases
   WHERE date3 >= ? and date3 <= ?  and supplier_id =? and balance <> 0 and moneda_id = ? and company_id=?
   ORDER BY 1 ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59", proveedor,moneda,"1" ])

        if (a.first.balance == nil) 
          puts "aaa************"
          puts proveedor 
          return 0
        else
          return a.first.balance  
        end
         
    end

 def get_general_contar(fecha1,fecha2,proveedor,moneda)
      a =  Purchase.find_by_sql(["
   SELECT   count(*) as balance 
   FROM purchases
   WHERE date3 >= ? and date3 <= ?  and supplier_id =? and balance <> 0 and moneda_id = ? and company_id = ?
   ORDER BY 1 ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59", proveedor,moneda ,"1"])

         if (a.first.balance == nil) 
          return 0  
        else

          return a.first.balance  

        end
    end



    def get_general2(fecha1,fecha2,proveedor,moneda)
      a =  Purchase.find_by_sql(["
   SELECT  supplier_id,
   SUM(balance) as balance,
   COUNT(documento) as Compras 
   FROM purchases
   WHERE date3 >= ? and date3 <= ?  and supplier_id =? and balance <> 0  and moneda_id =? and company_id = ?
   GROUP BY 1
   ORDER BY 1 ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59", proveedor,moneda, "1" ])

        if a.nil?
          return nil 
        else

          return a 

        end
    end




    def get_general_compras(fecha1,fecha2,proveedor,moneda)

      a =  Purchase.find_by_sql(["
   SELECT   SUM(balance) as balance
   FROM purchases
   WHERE date1 >= ? and date1 <= ?  and supplier_id =? and balance <> 0 and moneda_id = ? and company_id=? and payment_id <> 1
   ORDER BY 1 ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59", proveedor,moneda,"1" ])

        if (a.first.balance == nil) 
          puts "aaa************"
          puts proveedor 
          return 0
        else
          return a.first.balance  
        end
         
    end

 def get_general_contar_compras(fecha1,fecha2,proveedor,moneda)
      a =  Purchase.find_by_sql(["
   SELECT   count(*) as balance 
   FROM purchases
   WHERE date1 >= ? and date1 <= ?  and supplier_id =? and balance <> 0 and moneda_id = ? and company_id = ? and payment_id <> 1
   ORDER BY 1 ", "#{fecha1} 00:00:00","#{fecha2} 23:59:59", proveedor,moneda ,"1"])

         if (a.first.balance == nil) 
          return 0  
        else

          return a.first.balance  

        end
    end


    def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|

            #falta hacer validacion ingreso
           proveedor =  row['supplier_id']
           doc1 =  row['documento'].strip
           doc2 =  row['document_id']
           saldo = row['balance']
           moneda = row['moneda_id']
           puts proveedor
           puts doc1
           puts doc2
           puts saldo
           puts moneda 

            a =Purchase.find_by(supplier_id: proveedor, documento: doc1, document_id: doc2 , moneda_id: moneda)

            if a.nil?


               Purchase.create! row.to_hash 
          
            else  
                a.date2 = row['date2'] 
                a.date3 = row['date3']
                #a.balance = saldo 
                a.save
            end 

            
           

           end
    end     



  def get_vencido

      if(self.date3 < Date.today)   

        return "** Vencido ** "
      else
        return ""
      end 

  end 

  def get_dias_vmto(id)

    a =   Payment.find(id)
    
    return a.day 

  end

  def get_descrip0

    a = PurchaseDetail.find_by(purchase_id: self.id)
    if a.nil?

    

    else 
        if a.product.nil? 
            b =Servicebuy.find_by(id:a.product_id)
            if b.nil?
              return ""
            else  
              return b.name 
            end
          return 
        else 
          return  a.product.name  
        end 
    end

  end 

  def get_destino
    
    if self.tipo == "0" 

       a =  Purchaseorder.where(id: self.purchaseorder_id)


          if a.first.nil?
            return " "
           else

             return a.first.description 
          end
      
      

    else
           a =  Serviceorder.where(id: self.purchaseorder_id) 
           if a.first.nil?
            return " "
           else 
             return a.first.description 
          end
      
    end 
  end 
def get_observacion
    
    if self.tipo == "0" 

       a =  Purchaseorder.where(id: self.purchaseorder_id)


      if a.first.nil?
            return " "
           else

             return a.first.comments 
          end
      
      

    else
           a =  Serviceorder.where(id: self.purchaseorder_id) 
           if a.first.nil?
            return " "
           else 
             return a.first.comments  
          end
      
    end 
  end 

  def not_purchase_with?()
    document_tipo = self.document_id
    document_numero=  self.documento
    
    existe=Purchase.where(document_id: document_tipo,documento: document_numero).count < 1
    return existe 
  end

  def get_subtotal2(items)
    subtotal = 0

    for item in items
                    
        total = item.price * item.quantity
        total -= total * (item.discount / 100)        
        begin        
          subtotal += total      
        end     
    end  
    return subtotal
  end 

  def get_tax2(items, supplier_id)
    tax = 0
    
    supplier = Supplier.find(supplier_id)
    
    if(supplier)
      if(supplier.taxable == "1")
        for item in items
          if(item and item != "")

            total = item.price * item.quantity
            total -= total * (item.discount / 100)
        
            begin
              product = Product.find(item.product_id)
              
              if(product)
                if(product.tax1 and product.tax1 > 0)
                  tax += total * (product.tax1 / 100)
                end

                if(product.tax2 and product.tax2 > 0)
                  tax += total * (product.tax2 / 100)
                end

                if(product.tax3 and product.tax3 > 0)
                  tax += total * (product.tax3 / 100)
                end
              end
            rescue
            end
          end
        end
      end
    end
    return tax
  end


def get_tax3(items, supplier_id)
    tax = 0
    
    supplier = Supplier.find(supplier_id)
      
    if(supplier)
      if(supplier.taxable == "1")
        for item in items
          if(item and item != "")

            total = item.price * item.quantity
            total -= total * (item.discount / 100)
        
            begin
              product = Servicebuy.find(item.servicebuy_id)
              
              if(product)
                if(product.tax1 and product.tax1 > 0)
                  tax += total * (product.tax1 / 100)

                end

                if(product.tax2 and product.tax2 > 0)
                  tax += total * (product.tax2 / 100)
                end

                if(product.tax3 and product.tax3 > 0)
                  tax += total * (product.tax3 / 100)
                end
              end
            rescue
            end
          end
        end
      end
    end
    return tax
  end

  
  
  def get_subtotal(items)
    subtotal = 0
    precio_unit = 0 
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        price = parts[2]
        discount = parts[3]
        price2 = parts[4]
         
        total = price.to_f * quantity.to_f
        total = total /1.18 
        total -= total * (discount.to_f / 100)
        
        
        begin
          product = Product.find(id.to_i)
          subtotal += total
        rescue
        end
      end
    end  
    return subtotal
  end
  
  def get_tax(items, supplier_id)
    tax = 0
    
    supplier = Supplier.find(supplier_id)
    
    if(supplier)
      if(supplier.taxable == "1")
        for item in items
          if(item and item != "")
            parts = item.split("|BRK|")
        
            id = parts[0]
            quantity = parts[1]
            price = parts[2]
            discount = parts[3]
          
            total = price.to_f * quantity.to_f
            total = total /1.18 
            total -= total * (discount.to_f / 100)
        
            begin
              product = Product.find(id.to_i)
              
              if(product)
                if(product.tax1 and product.tax1 > 0)
                  tax += total * (product.tax1 / 100)
                end

                if(product.tax2 and product.tax2 > 0)
                  tax += total * (product.tax2 / 100)
                end

                if(product.tax3 and product.tax3 > 0)
                  tax += total * (product.tax3 / 100)
                end
              end
            rescue
            end
          end
        end
      end
    end
    
    return tax
  end
  
  def delete_products()
    purchase_details = PurchaseDetail.where(purchase_id: self.id)
    
    for ip in purchase_details
      ip.destroy
    end
  end
  
  def add_products(items)

    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        price = parts[2]
        discount = parts[3]
        lcprice_tax = price.to_f
        lcprice_without_tax = price.to_f/1.18

        total = lcprice_tax.to_f * quantity.to_f
        total -= total * (discount.to_f / 100)
        
        begin

          product = Product.find(id.to_i)          
          new_pur_product = PurchaseDetail.new(:purchase_id => self.id, :product_id => product.id,
          :price_with_tax => lcprice_tax, :price_without_tax=>lcprice_without_tax, :quantity => quantity.to_f, :discount => discount.to_f,
          :total => total.to_f)
          new_pur_product.save
        rescue
        end
              
      end
    end
  end  

   def add_products_menos(items)
    
    for item in items
      if(item and item != "")
        parts = item.split("|BRK|")
        
        id = parts[0]
        quantity = parts[1]
        price = parts[2]
        discount = parts[3]
        
        lcprice_tax = price.to_f

        quantity_1 = (quantity.to_f) * -1
      

        total = price.to_f * quantity_1 
        total -= total * (discount.to_f / 100)
        
        
          product = Product.find(id.to_i)

          
          new_pur_product = PurchaseDetail.new(:purchase_id => self.id, :product_id => product.id,
          :price_with_tax => lcprice_tax, :price_without_tax=>price.to_f,:quantity => quantity_1, :discount => discount.to_f,
          :total => total)
          new_pur_product.save
        
      end
    end
  end   

  def add_products2(items)

    for item in items      

        total = item.price * item.quantity
        total -= total * (item.discount / 100)
        lcprice_tax = item.price*1.18      
        
        if $lcTipoFacturaCompra == "1"
          product = Servicebuy.find(item.servicebuy_id)
        else
          product = Product.find(item.product_id)
        end

  
        new_pur_product = PurchaseDetail.new(:purchase_id => self.id, :product_id => product.id,
            :price_with_tax => lcprice_tax,:price_without_tax=>item.price, :quantity => item.quantity, 
            :discount => item.discount, :total => item.total )
        new_pur_product.save   

          
      
    end

  end   

  
  
  def identifier
    return "#{self.documento} - #{self.supplier.name}"
  end


  
  def get_products    
    

    if self.tipo == "1"
      @itemproducts = PurchaseDetail.find_by_sql(['Select purchase_details.price_with_tax as price,purchase_details.quantity,
      purchase_details.discount,purchase_details.price_without_tax as price2,purchase_details.total,
      servicebuys.code,servicebuys.name  from purchase_details INNER JOIN servicebuys ON 
      purchase_details.product_id = servicebuys.id where purchase_details.purchase_id = ?', self.id ])

    else

    @itemproducts = PurchaseDetail.find_by_sql(['Select purchase_details.price_with_tax as price,purchase_details.quantity,
      purchase_details.discount,purchase_details.price_without_tax as price2,purchase_details.total,
      products.code,products.name  from purchase_details INNER JOIN products ON 
      purchase_details.product_id = products.id where purchase_details.purchase_id = ?', self.id ])
      
    
    end

    return @itemproducts
  end
  
  def get_purchase_details
    purchase_details = PurchaseDetail.where(purchase_id:  self.id)    
    return purchase_details
  end
  

  def products_lines
    products = []
    purchase_details = PurchaseDetail.where(purchase_id:  self.id)   
    purchase_details.each do | ip |

      ip.product[:price] = ip.price_with_tax
      ip.product[:quantity] = ip.quantity
      ip.product[:discount] = ip.discount
      ip.product[:price2] = ip.price_without_tax
      ip.product[:total] = ip.total
      products.push("#{ip.product.id}|BRK|#{ip.product.quantity}|BRK|#{ip.product.price}|BRK|#{ip.product.discount}|BRK|#{ip.product.price2}|BRK|#{ip.product.total}")
      end

    return products.join(",")
  end
  
  def get_processed
    if(self.processed == "1")
      return "Procesado"
    else
      return "No Procesado"
    end
  end
  
  def get_processed_short
    if(self.processed == "1")
      return "Si"
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
  
  def get_purchaseorder

    if(self.purchaseorder_id == nil)
      return ""
    else
      if    self.purchaseorder  == nil
        return ""
      else        
        return self.purchaseorder.code 
      end 
    end
  end
  
    def process2

    if(self.processed == "1" or self.processed == true  )
        self.date_processed = Time.now
        self.save
    end 

  end 
  # Process the purchase
  def process

    if self.tipo =="0"

    if(self.processed == "1" or self.processed == true  )


      purchase_details =PurchaseDetail.where(purchase_id: self.id)
    
      for ip in purchase_details
                
        #actualiza stock
         stock_product =  Stock.find_by(:product_id => ip.product_id,:store_id=> self.almacen_id)

        if stock_product 
           @last_stock = stock_product.quantity + ip.quantity      
           stock_product.quantity = @last_stock
          if (self.moneda_id == 2)  
              stock_product.unitary_cost = ip.price_without_tax   
          else        
              dolar = Tipocambio.find_by('dia = ?',self.date1)
               if dolar 
                   stock_product.unitary_cost = ip.price_without_tax * dolar.compra  
               else 
                   stock_product.unitary_cost = ip.price_without_tax   
               end 
          end   
        else

          @last_stock = 0

          if (self.moneda_id == 2)  
               @lcprice_tax = ip.price_without_tax   
          else        
               dolar = Tipocambio.find_by('dia = ?',self.date1)
               if dolar 
                   @lcprice_tax = ip.price_without_tax * dolar.compra  
               else 
                   @lcprice_tax = ip.price_without_tax   
               end 
          end   

          stock_product= Stock.new(:store_id=> self.almacen_id,:state=>"Lima",:unitary_cost=> @lcprice_tax,
          :quantity=> ip.quantity,:minimum=>0,:user_id=>@user_id,:product_id=>ip.product_id,
          :document_id=>self.document_id,:documento=>self.documento)           
        end 

        stock_product.save

        self.date_processed = Time.now
        self.save
      

      end
    end   
  end 
  end
  
  def process_nota_credito

    if self.tipo =="0"

      if(self.processed == "1" or self.processed == true  )

        self.date_processed = Time.now
        self.save
    

      end
     
    end 
  end
  
  
  
  def process_documentos 
      if self.purchaseorder_id != nil 
        
        a = Purchaseorder.find_by(id: self.purchaseorder_id, supplier_id: self.supplier_id)
        
        if a 
          a.processed = "1"
          a.save 
        end 
      end

  
  end 
  def process_menos
    if self.tipo =="0"
      

    if(self.processed == "1" or self.processed == true  )
      

     
        self.date_processed = Time.now
        self.save
      

     
    end   
  end 
  end

  
  # Color for processed or not
  def processed_color
    if(self.processed == "1")
      return "green"
    else
      return "red"
    end
  end
  
  def get_categoria_name(codigo)  
    
    a=ProductsCategory.find(codigo)
    return a.category
  end   
  def get_service_name(codigo)  
    a = Service.find_by(code:codigo) 
    
    if a 
      return a.name 
    else
      return " no existe "
      
    end 
  end   
  def get_servicebuy_name(codigo)  
    a = Servicebuy.find_by(code:codigo) 
    
    if a 
      return a.name 
    else
      return " no existe "
      
    end 
  end   
  
  def get_tipocambio(fecha)
      fecha1 = fecha.strftime("%F") 
     tipocambio = Tipocambio.find_by("dia  >= ?  and dia <= ?", "#{fecha1} 00:00:00","#{fecha1} 23:59:59")
     if tipocambio 
      return tipocambio.compra 
     else
       return 0 
     end 
  end 

  def get_importe_soles1
    valor = 0
    
    if self.moneda_id == 2
          if self.document_id   == 2
                  valor = self.payable_amount
                    
          else  
                  valor = self.payable_amount
          
           end   
            
    end
    return valor     
  end 
  
  def get_importe_soles2
    valor = 0
    
    if self.moneda_id == 2
          if self.document_id   == 2
                  valor = self.tax_amount*-1
                    
          else  
                  valor = self.tax_amount
          
           end   
            
    end
    return valor     
  end 
  
  def get_importe_soles
    valor = 0
    
    if self.moneda_id == 2
          if self.document_id   == 2
                  valor = self.total_amount
                    
          else  
                  valor = self.total_amount
          
           end   
            
    end
    return valor     
  end 
  
  def get_importe_dolares
       valor = 0
       if self.moneda_id ==1
          if self.document_id   == 2
                  valor = self.balance
                    
          else  
                  valor = self.balance
          
           end   
          end 
        return valor         
  end
  
  def get_importe_balance_soles
       valor = 0
       if self.moneda_id ==2
          if self.document_id   == 2
                  valor = self.balance
                    
          else  
                  valor = self.balance
          
           end   
          end 
        return valor         
  end
  def get_importe_balance_dolares
       valor = 0
       if self.moneda_id ==1
          if self.document_id   == 2
                  valor = self.balance
                    
          else  
                  valor = self.balance
          
           end   
          end 
        return valor         
  end
  
  def self.search(search)
    where("documento iLIKE ?", "%#{search}%") 
  end  
  
  

end
