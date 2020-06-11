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
  
  self.per_page = 20



  has_many   :supplier_details , :dependent => :destroy
  

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

end

