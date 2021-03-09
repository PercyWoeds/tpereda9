class CreateExmautorizs < ActiveRecord::Migration
  def change
    create_table :exmautorizs do |t|
      t.integer :tramit_id
      t.integer :tipo_tramit_id
      t.integer :employee_id
      t.integer :proyecto_minero_id
      t.integer :supplier_id
      t.datetime :fecha_ingreso
      t.datetime :fecha_vmto
      t.integer :truck_id
      t.integer :employee2_id
      t.string :tipo_revision_tecnica
      t.datetime :fecha_vmto_rt
      t.datetime :fecha_carga_rt
      t.string :obs_rt
      t.integer :employee3_id
      t.integer :antecedent_id
      t.integer :tipo_antecedent_id
      t.datetime :fecha_vmto_ant
      t.text :obs_ant
      t.integer :employee4_id
      t.string :curso_cap
      t.integer :proyecto_minero_id
      t.datetime :fecha_vmto_cap
      t.text :obs_cap
      t.integer :employee5_id
      t.text :tramite
      t.datetime :fecha_vmto_ot
      t.text :obs_ot

      t.timestamps null: false
    end
  end
end
