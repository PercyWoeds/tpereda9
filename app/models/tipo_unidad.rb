class TipoUnidad < ActiveRecord::Base


	validates_uniqueness_of :code
    validates_presence_of :code,:name,:user_id,:company_id
    
    has_many :trucks 
    has_many :cotizacions


end
