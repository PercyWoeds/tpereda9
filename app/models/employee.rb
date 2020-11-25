class Employee < ActiveRecord::Base

	before_save :set_full_name
	before_save :set_full_name2
	
	belongs_to :location
	belongs_to :division 
	belongs_to :ocupacion
	belongs_to :categorium
	belongs_to :afp 
	belongs_to :ccosto 
  belongs_to :afericion
  belongs_to :tipofaltante

	
	has_many :outputs
	has_many :payroll_details
	has_many :payrollbonis 
	has_many :quintos 
	has_many :horas_mes 
  has_many :assistances 
  has_many :contratos   
  has_many :conductors   

 has_many :couts  

  
    
    validates_uniqueness_of :idnumber,:cod_interno
    validates_presence_of :company_id, :idnumber, :firstname,:lastname,:fecha_ingreso,:fecha_nacimiento,:sueldo,:categoria_id,:division_id,:ccosto_id,:ocupacion_id,:comision_flujo,:asignacion,:location_id,:efectivo,:hora_ex,:cod_interno
    
    def get_afpname
        ret = ""
    if self.afp_id != nil    
        afp = Afp.find(self.afp_id)
        ret = afp.name 
        return ret
    end 
    end 
 
	def get_afp(parameter_id,value = "aporte")
	
	 detalle = ParameterDetail.where(["afp_id = ? and parameter_id = ?", self.afp_id, parameter_id ])
    if detalle
    ret=0  
      
    for dato in detalle
      
    
       if self.onp == "1"
           ret = 0
       else 
        if (value =="aporte")
            ret = dato.aporte  
        elsif  (value == "seguro")
        
            ret = dato.seguro 
        elsif (value == "comision")
            if self.comision_flujo == 1 
            ret = dato.comision_flujo 
            end 
            if self.comision_flujo == 2
            ret = dato.comision_mixta 
            end 
            if self.comision_flujo == 3
            ret = dato.comision_mixta_saldo 
            end 
            
        end
      end     
    end
    end 

    return ret
		
	end 

	private 

	def set_full_name
		self.full_name ="#{self.firstname} #{self.lastname}".strip		
        self.flujo = 0
	end 
	
	
	def set_full_name2
		self.full_name2 ="#{self.lastname} #{self.firstname}".strip		
        self.flujo = 0
	end 
	

	def self.import(file)
  
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|


           a = Employee.find_by(idnumber: row['dni'])
           
           if a 

              a.fecha_ingreso = row['fecha_ingreso']
              a.fecha_cese = row['fecha_cese']
              a.afp_id = row['afp_id']
              a.onp  = row['onp_id']
              a.sueldo = row['sueldo']
              a.asignacion = row['asignacion']
              a.planilla = "1"
              a.cod_interno = row['item']
              a.efectivo = 0 
              a.hora_ex = row['hora_ex'] 
              
              
              a.save

          else

              puts row['idnumber']
           end

        end        
  end

    def self.search(search)
      # Title is for the above case, the OP incorrectly had 'name'
      where("idnumber LIKE ? or full_name ilike ? and active = ?", "%#{search}%","%#{search}%","1")
    end

end
