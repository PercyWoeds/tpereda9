class CreateProgramExamen < ActiveRecord::Migration
  def change
    create_table :program_examen do |t|
      t.datetime :fecha
      t.string :code
      t.string :processed
      t.datetime :date_processed

      t.timestamps null: false
    end
  end
end
