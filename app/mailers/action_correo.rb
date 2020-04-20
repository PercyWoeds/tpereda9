class ActionCorreo < ApplicationMailer
  	  default from: 'wds.tpereda@gmail.com'


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


	  
	  def bienvenido_email(invoice,file1,file2,file3,file4,mail)
		  @invoices=invoice 			
		   @url  = 'http://www.tpereda.com.pe'
		  #attachments["Factura"] = File.read("#{$lcFileName1}")
		  #attachments['Factura'] = File.read($lcFileName1)

		  #  $lcFileName1=File.expand_path('../../../', __FILE__)+ "/"+$lcFileName        
          #  $lcFile2    =File.expand_path('../../../', __FILE__)+ "/"+$lcFilezip
        

		  email_with_name = "Factura Enviada <facturaselectronicas@tpereda.com.pe>"	
		  email_with_copy = "Operaciones <operaciones@tpereda.com.pe>"	

		   attachments[file2] =  open(file1).read
		
		  if file3 != ""	
		  attachments[file4] =  open(file3).read
		  end 



		  mail(to: [mail], cc: email_with_copy,   bcc:email_with_name, subject: 'Factura Electrónica : '+$lcFileNameIni )

	  end
end
