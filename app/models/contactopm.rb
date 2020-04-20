class Contactopm < ActiveRecord::Base

   
   validates_presence_of :proyecto_minero_id 
   validates_uniqueness_of  :email

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

   belongs_to :proyecto_minero 

	 has_many :contactopmdetails, :dependent => :destroy 

	 accepts_nested_attributes_for :contactopmdetails , reject_if: proc { |att| att['contacto'].blank?} , :allow_destroy => true

 
	def generate_rq_number(serie)
    if Contactopm.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)") == nil 
      self.code = serie.to_s.rjust(3, '0') +"-000001"
    else
    self.code = serie.to_s.rjust(3, '0')+"-"+ Contactopm.where("cast(substring(code,1,3)  as int) = ?",serie).maximum("cast(substring(code,5,10)  as int)").next.to_s.rjust(6, '0') 
          
	  end 
  end 

end
