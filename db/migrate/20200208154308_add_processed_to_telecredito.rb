class AddProcessedToTelecredito < ActiveRecord::Migration
  def change
    add_column :telecreditos, :processed, :string
  end
end
