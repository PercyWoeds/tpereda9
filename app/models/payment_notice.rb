class PaymentNotice < ActiveRecord::Base
	has_many :paymentnotice_details



   
   validates_presence_of :proyecto_minero_id 
  
   belongs_to :proyecto_minero 

	 has_many :paymentnotice_details, :dependent => :destroy 

	 accepts_nested_attributes_for :paymentnotice_details , reject_if: proc { |att| att['descrip'].blank?} , :allow_destroy => true

 TABLE_HEADERS = [ "Nro.",
                   "PROYECTO MINERO ",
                   "CONTACTO",
                   "CORREO ELECTRONICO",
                   "TELEFONO"
                   ]

 
	def generate_rq_number(serie)
    if Contactopm.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)") == nil 
      self.code = serie.to_s.rjust(3, '0') +"-000001"
    else
    self.code = serie.to_s.rjust(3, '0')+"-"+ Contactopm.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)").next.to_s.rjust(6, '0') 
          
	  end 
  end 


end
