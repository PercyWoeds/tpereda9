class ActionCorreo < ApplicationMailer
  	  default from: 'wds.tpereda@gmail.com'


	  def st_email(invoice)
		  @manifest =invoice 			
		   @url  = 'http://www.tpereda.com.pe'
		  #attachments["Factura"] = File.read("#{$lcFileName1}")
		  #attachments['Factura'] = File.read($lcFileName1)
		  email_with_name = "Factura Enviada <percywoeds@gmail.com>"	
		  email_with_copy = "Operaciones <operaciones@tpereda.com.pe>"	
		  email_add = ""


		  mail(to: [email_with_copy] ,  bcc:email_with_name, subject: 'Informacion Sistema : ' )


	  end
end
