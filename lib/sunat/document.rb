
# Wrapper over model with some
# general properties to documents

module SUNAT
  class Document
    include Model

    DEFAULT_CUSTOMIZATION_ID = "1.0"
    DATE_FORMAT = "%Y-%m-%d"

    property :id,                         String # Usually: serial + correlative number
    property :issue_date,                 Date
    property :customization_id,           String
    property :company_name,               String
    property :document_type_name,         String
    property :accounting_supplier_party,  AccountingSupplierParty
    property :additional_properties,      [AdditionalProperty]
    property :additional_monetary_totals, [AdditionalMonetaryTotal]
    property :pdf_path,                   String
    property :global_discount_percent,    Float

    def self.xml_root(root_name)
      define_method :xml_root do
        root_name
      end
    end


    def not_implemented_exception
      "Implement in child document"
    end

    def initialize(*args)
      super(*args)
      #self.issue_date ||= Date.today
      self.issue_date ||= $lg_fecha 
      self.additional_properties ||= []
      self.additional_monetary_totals ||= []
    end

    def accounting_supplier_party
      get_attribute(:accounting_supplier_party) || AccountingSupplierParty.new(SUNAT::SUPPLIER.as_hash)
    end

    def file_name
      raise not_implemented_exception
    end

    def operation_list
      raise not_implemented_exception
    end

    def operation
      raise not_implemented_exception
    end

    def build_pdf_header(pdf)
     if self.accounting_supplier_party.logo_path.present?
        pdf.image "#{self.accounting_supplier_party.logo_path}", :width => 200
        pdf.move_down 6
      end
#     
                                                                                
      pdf.bounding_box([325, 725], :width => 200, :height => 80) do
        pdf.stroke_bounds
        pdf.move_down 15
        pdf.font "Helvetica", :style => :bold do
          pdf.text "R.U.C #{self.accounting_supplier_party.account_id}", :align => :center
          pdf.text "#{self.document_type_name.upcase}", :align => :center
          pdf.text "#{self.id}", :align => :center,
                                 :style => :bold
          pdf.text "Rectifica: #{self.billing_reference.invoice_document_reference.id}", :align => :center, :size => 8 if self.try(:billing_reference).present?
        end
      end
      pdf.move_down 25
      pdf
    end

    def build_pdf_header_extension(pdf)
      raise not_implemented_exception
    end

    def build_pdf_body(pdf)
      raise not_implemented_exception
    end


    def build_pdf_footer(pdf)
      
      
      pdf.bounding_box([0, 120], :width => 535, :height => 120) do

      pdf.stroke_bounds
      pdf.stroke_horizontal_rule
     
      image_path = open("https://chart.googleapis.com/chart?chs=90x90&cht=qr&chl=#{$lcCodigoBarra}&choe=UTF-8")
    
     pdf.table([[ {:image => image_path,:position => :center}  , "
      El pago del documento sera efectuado mediante deposito en cualquiera de las siguientes cuentas bancarias:  
  Banco SCOTIABANK Cuenta Corriente soles   : 4256085         CCI : 009-237-000004256085-94
  Banco SCOTIABANK Cuenta Corriente dolares : 1836766     CCI : 009-237-000001836766-94
  Banco de CREDITO Cuenta Corriente soles   : 191-1204755-0-41 CCI: 002-191-001204755041-58
  Banco de CREDITO Cuenta Corriente dolares : 191-1403434-1-10 CCI: 002-191-001403434110-58
  Banco  PICHINCHA Cuenta Corriente soles   : 001-095371657  CCI: 035-053001095371657-87 
  Banco  PICHINCHA Cuenta Corriente dolares : 001-095371665  CCI: 035-053001095371665-80
  Banco BBVA Cuenta Corriente soles  : 0011-0307-0100022426  CCI: 011-307-000100022426-59
  Banco BBVA Corriente dolares       : 0011-0307-0100023201  CCI: 011-307-000100023201-65
  Banco de la NACION Cuenta Detracción      : 00000459879
  OPERACION SUJETA AL SISTEMA DE PAGO DE OBLIGACIONES TRIBUTARIAS CONEL GOBIERNO CENTRAL D-LEG.NRO 940 "]],:cell_style => { :border_width => 0 } )

      end 

  
     
      pdf
      
    end

    def build_pdf(path=false)
      Prawn::Document.generate(path || self.pdf_path || "app/pdf_output/#{file_name}.pdf") do |pdf|
      
        pdf.font "Helvetica"
        pdf = build_pdf_header(pdf)
        pdf = build_pdf_body(pdf)
        
        build_pdf_footer(pdf)

        $lcFileName =path || self.pdf_path || "app/pdf_output/#{file_name}.pdf"
        $lcFileNameIni =file_name
        $lcFilezip =path || self.pdf_path || "/#{file_name}.zip"
        
      end
    end

    def to_pdf(path=false)
      build_pdf(path)
    end

    def customization_id
      self['customization_id'] ||= DEFAULT_CUSTOMIZATION_ID
    end

    def add_additional_property(options)
      id = options[:id]
      name = options[:name]
      value = options[:value]

      self.additional_properties << AdditionalProperty.new.tap do |property|
        property.id = id        if id
        property.name = name    if name
        property.value = value  if value
      end
    end

    def get_additional_properties_by_property(key, value)
      results = []
      additional_properties.each do |ap|
        if ap[key] and (ap[key] == value)
          results.push ap
        end
      end
      results
    end

    def get_additional_property_by_id(id)
      get_additional_properties_by_property(:id, id)[0]
    end

    def remove_additional_properties_by_property(key, value)
      results = []
      additional_properties.each do |ap|
        if ap[key] and (ap[key] != value)
          results.push ap
        end
      end
      self.additional_properties = results
      results
    end

    def modify_additional_property_by_id(ap)
      remove_additional_properties_by_property(:id, ap[:id])
      add_additional_property ap
    end

    def add_additional_monetary_total(options)
      id = options[:id]
      payable_amount = options[:payable_amount]
      reference_amount = options[:reference_amount]
      total_amount = options[:total_amount]
      percent = options[:percent]

      self.additional_monetary_totals << AdditionalMonetaryTotal.new.tap do |amt|
        amt.id = id                             if id
        amt.payable_amount = payable_amount     if payable_amount
        amt.reference_amount = reference_amount if reference_amount
        amt.total_amount = total_amount         if total_amount
        amt.percent = percent                   if percent
      end
    end

    def get_monetary_totals_by_property(key, value)
      results = []
      additional_monetary_totals.each do |amt|
        if amt[key] and (amt[key] == value)
          results.push amt
        end
      end
      results
    end

    def get_monetary_total_by_id(id)
      get_monetary_totals_by_property(:id, id)[0]
    end

    def remove_monetary_totals_by_property(key, value)
      results = []
      additional_monetary_totals.each do |amt|
        if amt[key] and (amt[key] != value)
          results.push amt
        end
      end
      self.additional_monetary_totals = results
      results
    end

    def modify_monetary_total(amt)
      remove_monetary_totals_by_property(:id, amt[:id])
      add_additional_monetary_total amt
    end

    # The signature here is for two reasons:
    #   1. easy call of the global SUNAT::SIGNATURE
    #   2. possible dependency injection of a signature in a test via stubs
    #
    attr_accessor :signature

    def signature
      @signature ||= SUNAT::SIGNATURE
    end

    def supplier
      @supplier ||= SUNAT::SUPPLIER
    end

    def to_xml
      # We create a decorator responsible to build the xml in top
      # of this document
      xml_document = XMLDocument.new(self)

       # Pass control over to the xml builder
      res = xml_document.build_xml do |xml|
        build_xml(xml)
      end

      # We pass a decorator to xml_signer, to allow it to use some generators
      # of xml_document
      xml_signer = XMLSigner.new(xml_document)
      xml_signer.sign(res.to_xml)
    end

    def build_xml(xml)
      raise "This method must be overriden!"
    end

    def to_zip
      @zip ||= Delivery::Chef.new(file_name + ".xml", to_xml).prepare
    end

    def format_date(date)
      date.strftime(DATE_FORMAT)
    end

    def sender
      @sender ||= SUNAT::Delivery::Sender.new
    end
  end
end
