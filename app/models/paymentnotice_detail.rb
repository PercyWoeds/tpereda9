class PaymentnoticeDetail < ActiveRecord::Base
  belongs_to :payment_notice



  attr_accessible :fecha_inicio,
			     :fecha_culmina,
			     :qty,
			    :descrip,
			    :lugar,
			    :price_unit,
			    :sub_total,
			    :igv,
			    :total,
			    :nro_compro,
			    :nro_documento,
			    :observa, :paymentnotice_details_attributes


		def total_item
		  if price_unit != nil and qty != nil
		  price_unit * qty
		else

			0 
			
		end

		end

end
