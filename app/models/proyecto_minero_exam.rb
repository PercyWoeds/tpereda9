class ProyectoMineroExam < ActiveRecord::Base

	validates_presence_of :proyecto_minero_id,:proyectominero2_id,:proyectominero3_id

    belongs_to :proyecto_minero
	belongs_to :proyectominero2
	belongs_to :proyectominero3
	




end
