class Supplier < ActiveRecord::Base
  validates_presence_of :company_id, :name
  validates_uniqueness_of :ruc
  
  belongs_to :company
  
  has_many :products
  has_many :restocks

  
  has_many :purchases
  has_many :purchaseorders
  has_many :supplier_payments
  has_many :outputs
  has_many :freepagars
  has_many :autoviatico 
  has_many :supplier_type 


  has_many :exmautorizs
  has_many :suppliers 
  
  belongs_to :banks 




  self.per_page = 20

  has_many   :supplier_details , :dependent => :destroy
   TABLE_HEADERS_EXM = ["Nro.",
                "EMPRESA",
                "RUC",
                "NOMBRE DE CONTACTO",
                "CARGO",
                "TELEFONO / CELULAR",
                "CORREO ELECTRÓNICO",
                "BANCO",
                "CTA CTE :",
                "PROYECTOS MINEROS AUTORIZADO",
                "TIPO DE SERVICIO",
                "DIRECCIÓN / LUGAR"
          ]

  def self.to_csv(options = {})
      CSV.generate(options) do |csv|
      csv << column_names
      all.each do |customer|
        csv << customer.attributes.values_at(*column_names)
      end
    end   
  end 
  

  def get_taxable
    if(self.taxable == "1")
      return "Taxable"
    else
      return "Not taxable"
    end
  end

  def self.import(file)
        CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
        Supplier.create! row.to_hash 
      end
  end  

  def get_banco(id)

        
      if   a= Bank.where(id: id ).exists? 

           category = Bank.find(id)

           return category.name 
      else

           return "Bank doesn't exists."
      end 


  end 




end

