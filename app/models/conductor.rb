class Conductor < ActiveRecord::Base
  belongs_to :employee


  validates_presence_of :employee_id
  validates_uniqueness_of :employee_id

  validates_presence_of :lugar,:anio,:licencia,
  :categoria,:expedicion_licencia,:revalidacion_licencia,
   :categoria_especial,
   :expedicion_licencia_especial,
   :iqbf,
    :dni_emision,
    :dni_caducidad,
    :ap_emision,
    :ap_caducidad,
    :ape_emision,
    :ape_caducidad,
    :user_id,
    :revalidacion_licencia_especial,
    :anio1,
    :anio2,
    :anio3,
    :anio4 
   


 TABLE_HEADERS = ["Nro.",
                      "APELLIDOS",
                     "NOMBRES",
                     "LUGAR RESIDENCIA ",
                     "AÑOS EXPERIENCIA",
                     "AÑOS EXP.CAMIONETA",
                     "AÑOS EXP.CAMION",
                     "AÑOS EXP.PLATAFORMA",
                     "AÑOS EXP.CAMABAJA",
                      "LICENCIA",  
                     "CATEGORIA ",
                     "EXP.LICENCIA",
                     "REVAL.LICENCIA",
                     "CATEGORIA ESP.",
                     "EXP.LIC.ESPECIAL",
                     "REVAL.LIC.ESPECIAL",
                     "IQBF",
                     "DNI.EMISION",
                     "DNI.CADUCIDAD",
                     "ANT.POL.EMISION",
                     "ANT.POL.VMTO",
                     "ANT.PEN.EMISION",
                     "ANT.PEN.VMTO"    ]

    def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|

	          if Employee.where(idnumber: row["idnumber"]).exists? 

	          		  a = Employee.find_by(idnumber: row["idnumber"])	
	          	     row["employee_id"] = a.id 

	          		 Conductor.create! row.to_hash 
	          		 puts a.id 
	          		 puts row['licencia']
	          		 puts row['idnumber']

	         end


          end     

    end 
end
