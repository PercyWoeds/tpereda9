class Moneda < ActiveRecord::Base
validates_presence_of :company_id, :description

  belongs_to :company
  
  has_many :divisions
  has_many :invoices
  has_many :purchases
  has_many :facturas 
  has_many :purchaseorders
  has_many :serviceorders
  has_many :bank_acounts
  has_many :quotations
  has_many :cotizacions 


end
