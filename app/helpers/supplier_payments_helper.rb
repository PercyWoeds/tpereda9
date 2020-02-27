module SupplierPaymentsHelper

	class Helpers

    def self.textify(paymentAmount, lang=:es)
      text = I18n.with_locale(lang) {paymentAmount.int_part.to_words}
      a = paymentAmount.cents_part
      puts "textttt"
      puts a
      a1 = a.round(2)
      puts a1
      "#{text} y #{a1.to_s.rjust(2,'0')}/100 SOLESx"
      
    end

  end

end


