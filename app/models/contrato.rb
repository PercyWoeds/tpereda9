class Contrato < ActiveRecord::Base

belongs_to :employee 
validates_presence_of :employee_id,:fecha_inicio, :fecha_fin, :fecha_suscripcion, :location_id, :division_id, :sueldo, :modalidad_id, :tipocontrato_id, :moneda_id, :tiporemuneracion_id

end
