module SupplierPaymentsHelper

	class Helpers

    def self.textify(paymentAmount, lang=:es)
      text = I18n.with_locale(lang) {paymentAmount.int_part.to_words}
      
      "#{text} y #{paymentAmount.cents_part.to_s.rjust(2,'0')}/100 SOLES"
      
    end

  end

end


