class Egreso < ActiveRecord::Base

	 validates_uniqueness_of :code
    validates_presence_of :code, :name

end
