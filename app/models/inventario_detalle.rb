class InventarioDetalle < ActiveRecord::Base
  belongs_to :inventario
  belongs_to :product

  # validaciones
  validates_numericality_of :cantidad
  validates_numericality_of :precio_unitario
  
  
#  validates_presence_of :item_id, :inventario_id
  # Hay que implementar un procedimiento para que no puedan activar los items
  # before_save :delete_activo

  def self.import(file)
          CSV.foreach(file.path, headers: true, encoding:'iso-8859-1:utf-8') do |row|
          InventarioDetalle.create! row.to_hash 
        end
    end   
  
  def total
    precio_unitario * cantidad
  end
end
