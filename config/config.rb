SUNAT.configure do |config|
  config.credentials do |c|


    c.ruc       = "20424092941"
    c.username  = "FACTURA2"
    c.password  = "20424092941"
   end

  config.signature do |s|
    s.party_id    = "20424092941"
    s.party_name  = "TRANSPORTES PEREDA SRL"
    s.cert_file   = File.join(Dir.pwd, './app/keys', 'certificate2019.crt')
    s.pk_file     = File.join(Dir.pwd, './app/keys', 'CERTIFICADO2019.key') 
  end

  config.supplier do |s|
    s.legal_name = "TRANPORTES PEREDA SRL."
    s.name       = "HERBERT TONY ERQUINIGO PEREDA"
    s.ruc        = "20424092941"
    s.address_id = "150101"
    s.street     = "JR. VICTOR REINEL NRO.187 VILLA DE LA LEGUA"
    s.district   = "LIMA"
    s.city       = "LIMA"
    s.country    = "PE"
    s.logo_path  = "#{Dir.pwd}/assets/images/logo.png"
  end
end