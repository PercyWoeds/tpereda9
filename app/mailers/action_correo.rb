class ActionCorreo < ApplicationMailer
  	  default from: 'wds.report.tpereda@gmail.com'


	  def st_email(invoice)
		  @manifest =invoice 			
		   @url  = 'http://www.tpereda.com.pe'
		  email_with_name = "Factura Enviada <percywoeds@gmail.com>"	
		  email_with_copia = "Comercial <comercial@tpereda.com.pe>"
		  email_with_copia1 = "Recepcion <recepcionydespacho@tpereda.com.pe>"
		  email_with_copia2 = "Asistente <asistenteadministrativa@tpereda.com.pe>"
		  	
		  email_with_copy = "Operaciones <operaciones@tpereda.com.pe>"	
		  email_add = ""
		  mail(to: [email_with_copy] ,cc: [email_with_copia,email_with_copia1,email_with_copia2 ], subject: 'Informacion Sistema : ' )


	  end

	  

	  def rq_email(invoice)
		@requerimiento =invoice 			
		 @url  = 'http://www.tpereda.com.pe'

		email_with_copy = " Rq <percywoeds@gmail.com "
		email_with_copia = "Almacen  <almacen@tpereda.com.pe>"
		
		email_add = " "

		mail(to: [email_with_copia] , cc: email_with_copy, subject: 'Requerimiento sistema  : ' )


	end


	def bienvenido_email(invoice)
		  @invoices=invoice 			
		   @url  = 'http://www.tpereda.com.pe'
		  #attachments["Factura"] = File.read("#{$lcFileName1}")
		  #attachments['Factura'] = File.read($lcFileName1)

		  email_with_name = "Factura Enviada <facturaselectronicas@tpereda.com.pe>"	
		  email_with_copy = "Operaciones <operaciones@tpereda.com.pe>"	

		  attachments[$lcFileName] =  open($lcFileName1).read
		
		  if $lcFile2 != ""	
		  attachments[$lcFilezip] =  open($lcFile2).read
		  end 

		  mail(to: [$lcMail,$lcMail2,$lcMail3], cc: email_with_copy,   bcc:email_with_name, subject: 'Factura Electrónica : '+$lcFileNameIni )

	  end


 
	  def notify_followers(mail,user)
		   @user=user			
		   @url  = 'http://www.tpereda.com.pe'
		
        

		  email_with_name = "Stocks <percywoeds@gmail.com>"	
		 
		   


		  mail(to: [mail], cc:email_with_name, subject: 'Account Reports : ' )

	  end


end
