class AddMotivoToMntos < ActiveRecord::Migration
  def change
    add_column :mntos, :motivo, :text
  end
end
