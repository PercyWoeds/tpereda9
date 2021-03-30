# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20210330182116) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.string   "currency",       limit: 10
    t.decimal  "exchange_rate",              precision: 14, scale: 4, default: 1.0
    t.decimal  "amount",                     precision: 14, scale: 2, default: 0.0
    t.string   "type",           limit: 30
    t.integer  "contact_id"
    t.integer  "project_id"
    t.boolean  "active",                                              default: true
    t.string   "description",    limit: 500
    t.date     "date"
    t.string   "state",          limit: 30
    t.boolean  "has_error",                                           default: false
    t.string   "error_messages", limit: 400
    t.integer  "tag_ids",                                             default: [],    array: true
    t.integer  "updater_id"
    t.decimal  "tax_percentage",             precision: 5,  scale: 2, default: 0.0
    t.integer  "tax_id"
    t.decimal  "total",                      precision: 14, scale: 2, default: 0.0
    t.boolean  "tax_in_out",                                          default: false
    t.integer  "creator_id"
    t.integer  "approver_id"
    t.integer  "nuller_id"
    t.date     "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["active"], name: "index_accounts_on_active", using: :btree
  add_index "accounts", ["amount"], name: "index_accounts_on_amount", using: :btree
  add_index "accounts", ["approver_id"], name: "index_accounts_on_approver_id", using: :btree
  add_index "accounts", ["contact_id"], name: "index_accounts_on_contact_id", using: :btree
  add_index "accounts", ["creator_id"], name: "index_accounts_on_creator_id", using: :btree
  add_index "accounts", ["currency"], name: "index_accounts_on_currency", using: :btree
  add_index "accounts", ["date"], name: "index_accounts_on_date", using: :btree
  add_index "accounts", ["description"], name: "index_accounts_on_description", using: :btree
  add_index "accounts", ["due_date"], name: "index_accounts_on_due_date", using: :btree
  add_index "accounts", ["has_error"], name: "index_accounts_on_has_error", using: :btree
  add_index "accounts", ["name"], name: "index_accounts_on_name", using: :btree
  add_index "accounts", ["nuller_id"], name: "index_accounts_on_nuller_id", using: :btree
  add_index "accounts", ["project_id"], name: "index_accounts_on_project_id", using: :btree
  add_index "accounts", ["state"], name: "index_accounts_on_state", using: :btree
  add_index "accounts", ["tag_ids"], name: "index_accounts_on_tag_ids", using: :btree
  add_index "accounts", ["tax_id"], name: "index_accounts_on_tax_id", using: :btree
  add_index "accounts", ["tax_in_out"], name: "index_accounts_on_tax_in_out", using: :btree
  add_index "accounts", ["type"], name: "index_accounts_on_type", using: :btree
  add_index "accounts", ["updater_id"], name: "index_accounts_on_updater_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.string   "address"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "full_address"
    t.integer  "address2_id"
    t.integer  "customer_id"
  end

  create_table "afericions", force: :cascade do |t|
    t.datetime "fecha"
    t.string   "turno"
    t.integer  "employee_id"
    t.integer  "tanque_id"
    t.string   "documento"
    t.float    "quantity"
    t.float    "importe"
    t.string   "concepto"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "afps", force: :cascade do |t|
    t.string   "name"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ajust_details", force: :cascade do |t|
    t.integer  "ajust_id"
    t.integer  "product_id"
    t.float    "quantity"
    t.float    "quantity_transit"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "ajusts", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.text     "description"
    t.text     "comments"
    t.datetime "fecha1"
    t.string   "code"
    t.float    "total"
    t.string   "processed"
    t.string   "return"
    t.datetime "date_processed"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.float    "subtotal"
    t.float    "tax"
    t.integer  "almacen_id"
  end

  create_table "almacens", force: :cascade do |t|
    t.string   "nombre"
    t.string   "direccion"
    t.string   "codigo"
    t.string   "telefono"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "antecedents", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assistances", force: :cascade do |t|
    t.string   "departamento"
    t.string   "nombre"
    t.string   "nro"
    t.datetime "fecha"
    t.string   "equipo"
    t.string   "cod_verificacion"
    t.string   "num_tarjeta"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.datetime "hora1"
    t.datetime "hora2"
    t.datetime "hora_efectivo"
    t.string   "observacion"
    t.integer  "inasist_id"
    t.integer  "employee_id"
    t.datetime "hora_efectivo2"
  end

  add_index "assistances", ["inasist_id"], name: "index_assistances_on_inasist_id", using: :btree

  create_table "autoviaticos", force: :cascade do |t|
    t.string   "code"
    t.integer  "employee_id"
    t.datetime "fecha"
    t.string   "tema"
    t.integer  "supplier_id"
    t.string   "asunto"
    t.float    "movilidad"
    t.float    "almuerzo"
    t.float    "otros"
    t.string   "observa"
    t.string   "hora_ingreso"
    t.string   "hora_salida"
    t.integer  "employee_id2"
    t.string   "lugar_salida"
    t.string   "lugar_destino"
    t.string   "hora1"
    t.string   "hora2"
    t.string   "observa2"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "asunto1"
    t.datetime "fecha2"
    t.string   "asunto2"
    t.string   "lugar1"
    t.string   "lugar2"
    t.string   "lugar3"
    t.float    "total"
    t.string   "processed"
    t.datetime "date_processed"
  end

  create_table "autoviatics", force: :cascade do |t|
    t.integer  "location_id"
    t.integer  "employee_id"
    t.datetime "fecha"
    t.text     "tema"
    t.integer  "supplier_id"
    t.string   "asunto"
    t.integer  "tramit_id"
    t.float    "movilidad"
    t.float    "almuerzo"
    t.float    "otros"
    t.string   "lugar1"
    t.string   "lugar2"
    t.string   "lugar3"
    t.text     "obser"
    t.string   "lugar_salida"
    t.string   "lugar_salida2"
    t.time     "hora_ingreso"
    t.time     "hora_salida"
    t.text     "obser2"
    t.string   "processed"
    t.datetime "date_processed"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "code"
    t.integer  "proyecto_minero_id"
    t.string   "references"
    t.string   "proyecto_mineros"
  end

  create_table "bank_acounts", force: :cascade do |t|
    t.string   "number"
    t.integer  "moneda_id"
    t.integer  "bank_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "cuenta"
  end

  create_table "bankdetails", force: :cascade do |t|
    t.integer  "bank_acount_id"
    t.datetime "fecha"
    t.float    "saldo_inicial"
    t.float    "total_abono"
    t.float    "total_cargo"
    t.float    "saldo_final"
    t.float    "company_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "banks", force: :cascade do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "phone1"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cajas", force: :cascade do |t|
    t.string   "descrip"
    t.float    "inicial"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "numero"
  end

  create_table "carts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categoria", force: :cascade do |t|
    t.string   "code"
    t.string   "descrip"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ccostos", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.string   "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cdocuments", force: :cascade do |t|
    t.integer  "employee_id"
    t.string   "lugar"
    t.string   "experiencia"
    t.string   "dni"
    t.string   "categoria"
    t.string   "exp_licencia"
    t.string   "rev_licencia"
    t.string   "categoria_especial"
    t.string   "exp_licencia2"
    t.string   "iqbf"
    t.datetime "dni_emision"
    t.datetime "dni_caducidad"
    t.datetime "ap_emision"
    t.datetime "ap_caducidad"
    t.datetime "app_emision"
    t.datetime "app_caducidad"
    t.text     "cv_documentado"
    t.string   "nivel_educativo"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "rev_licencia2"
  end

  create_table "cegresos", force: :cascade do |t|
    t.integer  "employee_id"
    t.integer  "transportorder_id"
    t.datetime "fecha1"
    t.datetime "fecha2"
    t.text     "observa"
    t.text     "descrip"
    t.float    "importe"
    t.integer  "moneda_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "cierres", force: :cascade do |t|
    t.integer  "modulo"
    t.string   "descrip"
    t.datetime "fecha"
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clase_cats", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "color_vehis", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "website"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo"
    t.string   "ruc"
  end

  create_table "company_users", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "compros", force: :cascade do |t|
    t.integer  "ost_id"
    t.datetime "fecha"
    t.string   "descrip"
    t.integer  "document_id"
    t.string   "numero"
    t.float    "importe"
    t.text     "detalle"
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "tranportorder_id"
    t.string   "code"
    t.integer  "i"
    t.float    "CurrTotal"
  end

  create_table "concepts", force: :cascade do |t|
    t.string   "descrip"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "conductors", force: :cascade do |t|
    t.string   "lugar"
    t.string   "anio"
    t.string   "licencia"
    t.string   "categoria"
    t.datetime "expedicion_licencia"
    t.datetime "revalidacion_licencia"
    t.string   "categoria_especial"
    t.datetime "expedicion_licencia_especial"
    t.string   "iqbf"
    t.datetime "fecha_emision"
    t.datetime "dni_emision"
    t.datetime "dni_caducidad"
    t.datetime "ap_emision"
    t.datetime "ap_caducidad"
    t.datetime "ape_emision"
    t.datetime "ape_caducidad"
    t.integer  "user_id"
    t.integer  "company_id"
    t.integer  "employee_id"
    t.string   "active"
    t.integer  "employees_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.datetime "revalidacion_licencia_especial"
    t.string   "idnumber"
    t.string   "anio1"
    t.string   "anio2"
    t.string   "anio3"
    t.string   "anio4"
  end

  add_index "conductors", ["employees_id"], name: "index_conductors_on_employees_id", using: :btree

  create_table "config_vehis", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contactopmdetails", force: :cascade do |t|
    t.string   "contacto"
    t.string   "email"
    t.string   "telefono"
    t.integer  "contactopm_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "contactopmdetails", ["contactopm_id"], name: "index_contactopmdetails_on_contactopm_id", using: :btree

  create_table "contactopms", force: :cascade do |t|
    t.integer  "proyecto_minero_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "code"
  end

  create_table "contratos", force: :cascade do |t|
    t.integer  "employee_id"
    t.datetime "fecha_inicio"
    t.datetime "fecha_fin"
    t.datetime "fecha_suscripcion"
    t.integer  "location_id"
    t.integer  "division_id"
    t.float    "sueldo"
    t.string   "reingreso"
    t.text     "comments"
    t.integer  "modalidad_id"
    t.integer  "tipocontrato_id"
    t.integer  "submodalidad_id"
    t.integer  "moneda_id"
    t.integer  "tiporemuneracion_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "cotizacions", force: :cascade do |t|
    t.datetime "fecha"
    t.string   "code"
    t.integer  "customer_id"
    t.integer  "punto_id"
    t.integer  "punto2_id"
    t.integer  "tipocargue_id"
    t.float    "tarifa"
    t.string   "processed"
    t.string   "comments"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.datetime "date_processed"
    t.string   "tipo_unidad"
    t.string   "estado"
    t.string   "especifica"
    t.integer  "tipo_unidad_id"
    t.integer  "tipo_unidad2_id"
    t.integer  "tipo_unidad3_id"
    t.integer  "config_vehi_id"
    t.integer  "config_vehi2_id"
    t.integer  "config_vehi3_id"
    t.float    "qty"
    t.float    "qty2"
    t.float    "qty3"
    t.float    "price"
    t.float    "price2"
    t.float    "price3"
    t.float    "total"
    t.float    "total2"
    t.float    "total3"
    t.float    "tipounidad1"
    t.float    "tipounidad2"
    t.float    "tipounidad3"
    t.float    "tipounidad4"
    t.float    "tipounidad5"
    t.integer  "tm"
    t.integer  "moneda_id"
    t.integer  "payment_id"
    t.integer  "tipocustomer_id"
    t.float    "valorseguro"
    t.string   "descrip1"
    t.string   "descrip2"
    t.string   "descrip3"
    t.integer  "tipo_unidad4_id"
    t.integer  "config_vehi4_id"
    t.string   "descrip4"
    t.float    "qty4"
    t.float    "price4"
    t.float    "total4"
    t.integer  "tipo_unidad5_id"
    t.integer  "config_vehi5_id"
    t.string   "descrip5"
    t.float    "qty5"
    t.float    "price5"
    t.float    "total5"
    t.integer  "tipo_unidad6_id"
    t.integer  "config_vehi6_id"
    t.string   "descrip6"
    t.float    "qty6"
    t.float    "price6"
    t.float    "total6"
    t.integer  "tipo_unidad7_id"
    t.integer  "config_vehi7_id"
    t.string   "descrip7"
    t.float    "qty7"
    t.float    "price7"
    t.float    "total7"
    t.integer  "tipo_unidad8_id"
    t.integer  "config_vehi8_id"
    t.string   "descrip8"
    t.float    "qty8"
    t.float    "price8"
    t.float    "total8"
    t.integer  "tipo_unidad9_id"
    t.integer  "config_vehi9_id"
    t.string   "descrip9"
    t.float    "qty9"
    t.float    "price9"
    t.float    "total9"
    t.integer  "tipo_unidad10_id"
    t.integer  "config_vehi10_id"
    t.string   "descrip10"
    t.float    "qty10"
    t.float    "price10"
    t.float    "total10"
    t.string   "camacuna"
    t.string   "stand_by"
    t.string   "modularobs"
  end

  create_table "couts", force: :cascade do |t|
    t.string   "code"
    t.datetime "fecha"
    t.float    "importe"
    t.integer  "truck_id"
    t.integer  "punto_id"
    t.integer  "tranportorder_id"
    t.integer  "employee_id"
    t.integer  "employee2_id"
    t.integer  "employee3_id"
    t.float    "peajes"
    t.float    "lavado"
    t.float    "llanta"
    t.float    "alimento"
    t.float    "otros"
    t.float    "monto_recibido"
    t.float    "flete"
    t.float    "recibido_ruta"
    t.float    "vuelto"
    t.float    "descuento"
    t.float    "reembolso"
    t.integer  "ost_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.float    "tbk"
    t.string   "processed"
    t.string   "tbk_documento"
  end

  create_table "cpagar_details", force: :cascade do |t|
    t.integer  "document_id"
    t.string   "documento"
    t.integer  "supplier_id"
    t.string   "tm"
    t.float    "total"
    t.text     "descrip"
    t.integer  "cpagar_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "cpagar_details", ["cpagar_id"], name: "index_cpagar_details_on_cpagar_id", using: :btree

  create_table "cpagars", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.integer  "bank_acount_id"
    t.integer  "document_id"
    t.string   "documento"
    t.integer  "supplier_id"
    t.string   "tm"
    t.float    "total"
    t.datetime "fecha1"
    t.datetime "fecha2"
    t.string   "nrooperacion"
    t.string   "operacion"
    t.string   "comments"
    t.integer  "user_id"
    t.string   "processed"
    t.datetime "date_processed"
    t.string   "code"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "creditos", force: :cascade do |t|
    t.string   "code"
    t.string   "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "csubdia", force: :cascade do |t|
    t.string   "ccompro"
    t.string   "cfeccom"
    t.string   "ccodmon"
    t.string   "csitua"
    t.float    "ctipcam"
    t.string   "cglosa"
    t.float    "ctotal"
    t.string   "ctipo"
    t.string   "cflag"
    t.datetime "cdate"
    t.string   "chora"
    t.string   "cfeccam"
    t.string   "cuser"
    t.string   "corig"
    t.string   "cform"
    t.string   "cextor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "csubdia"
    t.float    "factory"
    t.float    "ajuste"
    t.float    "compen"
    t.float    "total1"
  end

  create_table "csubdiarios", force: :cascade do |t|
    t.string   "csubdia"
    t.string   "ccompro"
    t.string   "ccodmon"
    t.string   "csitua"
    t.string   "ctipcam"
    t.string   "cglosa"
    t.float    "ctotal"
    t.string   "ctipo"
    t.string   "cflag"
    t.string   "cdate"
    t.string   "chora"
    t.string   "cfeccam"
    t.string   "cuser"
    t.string   "corig"
    t.string   "cform"
    t.string   "cextor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "cfeccom"
    t.string   "ccodane"
    t.float    "csubtotal"
    t.float    "ctax"
    t.float    "factory"
    t.float    "ajuste"
    t.float    "compen"
    t.float    "total1"
  end

  create_table "customer_payment_details", force: :cascade do |t|
    t.integer  "document_id"
    t.string   "documento"
    t.integer  "customer_id"
    t.string   "tm"
    t.float    "total"
    t.text     "descrip"
    t.integer  "factura_id"
    t.integer  "customer_payment_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.float    "factory"
    t.float    "ajuste"
    t.float    "compen"
    t.datetime "fecha2"
    t.string   "month_year"
    t.float    "balance"
    t.integer  "moneda_id"
  end

  create_table "customer_payments", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.integer  "bank_account_id"
    t.integer  "document_id"
    t.string   "documento"
    t.integer  "customer_id"
    t.string   "tm"
    t.float    "total"
    t.datetime "fecha1"
    t.datetime "fecha2"
    t.string   "nrooperacion"
    t.string   "operacion"
    t.text     "descrip"
    t.text     "comments"
    t.integer  "user_id"
    t.string   "processed"
    t.datetime "date_processed"
    t.string   "code"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "bank_acount_id"
    t.integer  "concept_id"
    t.float    "compen"
    t.integer  "moneda_id"
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "email"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.text     "comments"
    t.string   "account"
    t.string   "taxable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "ruc"
    t.string   "contacto"
    t.string   "sr"
  end

  create_table "dato_laws", force: :cascade do |t|
    t.integer  "employee_id"
    t.string   "sueldo_integral"
    t.string   "comision"
    t.string   "descuento_ley"
    t.integer  "afp_id"
    t.string   "ies"
    t.string   "senati"
    t.string   "sobretiempo"
    t.string   "otra_ley_social"
    t.string   "accidente_trabajo"
    t.string   "descuento_quinta"
    t.string   "domiciliado"
    t.string   "a_familiar"
    t.string   "no_afecto"
    t.string   "no_afecto_grati"
    t.string   "no_afecto_afp"
    t.string   "cussp"
    t.string   "tipo_afiliado_id"
    t.string   "regimen_id"
    t.datetime "contrato_inicio"
    t.datetime "contrato_fin"
    t.datetime "vacaciones_inicio"
    t.datetime "vacaciones_fin"
    t.float    "grati_julio"
    t.float    "grati_diciembre"
    t.float    "importe_subsidio"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "declaration_deliveries", force: :cascade do |t|
    t.integer  "delivery_id"
    t.integer  "declaration_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "declarations", force: :cascade do |t|
    t.string   "code"
    t.integer  "employee_id"
    t.integer  "punto_id"
    t.integer  "punto2_id"
    t.integer  "truck_id"
    t.integer  "truck2_id"
    t.datetime "fecha1"
    t.datetime "fecha2"
    t.text     "observacion"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "deliveries", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "customer_id"
    t.text     "description"
    t.text     "comments"
    t.string   "code"
    t.float    "subtotal"
    t.float    "tax"
    t.float    "total"
    t.string   "processes"
    t.string   "return"
    t.datetime "date_processes"
    t.integer  "user_id"
    t.datetime "fecha1"
    t.datetime "fecha2"
    t.integer  "employee_id"
    t.integer  "empsub_id"
    t.integer  "subcontrat_id"
    t.integer  "truck_id"
    t.integer  "truck2_id"
    t.integer  "address_id"
    t.integer  "remision"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "processed"
    t.integer  "division_id"
    t.float    "i"
    t.integer  "remite_id"
    t.integer  "address2_id"
    t.datetime "date_processed"
    t.integer  "tranportorder_id"
    t.datetime "fecha3"
    t.datetime "fecha4"
  end

  create_table "delivery_services", force: :cascade do |t|
    t.integer  "service_id"
    t.integer  "price"
    t.integer  "quantity"
    t.integer  "unidad_id"
    t.integer  "peso"
    t.float    "discount"
    t.float    "total"
    t.integer  "delivery_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "deliverymines", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "delivery_id"
    t.integer  "mine_id"
  end

  create_table "deliveryships", force: :cascade do |t|
    t.integer  "factura_id"
    t.integer  "delivery_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "destinos", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "divisions", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "documents", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "company_id"
    t.string   "descripshort"
    t.string   "tiposunat"
    t.string   "fullname"
    t.string   "area"
    t.string   "orden"
  end

  create_table "dsubdia", force: :cascade do |t|
    t.string   "dcompro"
    t.string   "dsecue"
    t.string   "dfeccom"
    t.string   "dcuenta"
    t.string   "dcodane"
    t.string   "dcencos"
    t.string   "dcodmon"
    t.string   "ddh"
    t.float    "dimport"
    t.string   "dtipdoc"
    t.string   "dnumdoc"
    t.string   "dfecdoc"
    t.string   "dfecven"
    t.string   "darea"
    t.string   "dflag"
    t.string   "dxglosa"
    t.datetime "ddate"
    t.string   "dcodane2"
    t.float    "dusimpor"
    t.float    "dmnimpor"
    t.string   "dcodarc"
    t.string   "dtidref"
    t.string   "dndoref"
    t.datetime "dfecref"
    t.datetime "dbimref"
    t.float    "digvref"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dsubdiarios", force: :cascade do |t|
    t.string   "dcompro"
    t.string   "dsecue"
    t.string   "dfeccom"
    t.string   "dcuenta"
    t.string   "dcodane"
    t.string   "dcencos"
    t.string   "dcodmon"
    t.string   "ddh"
    t.float    "dimport"
    t.string   "dtipdoc"
    t.string   "dnumdoc"
    t.string   "dfecdoc"
    t.string   "dfecven"
    t.string   "darea"
    t.string   "dflag"
    t.string   "dxglosa"
    t.string   "ddate"
    t.string   "dcodane2"
    t.string   "dusimpor"
    t.string   "dmnimpor"
    t.string   "dcodarc"
    t.string   "dtidref"
    t.string   "dndoref"
    t.string   "dfecref"
    t.string   "dbimref"
    t.string   "digvref"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "dsubdiario"
  end

  create_table "eesses", force: :cascade do |t|
    t.string   "code"
    t.string   "nombre"
    t.string   "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "egresos", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.string   "extension"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "egreso_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "email1"
    t.string   "email2"
    t.integer  "company_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "licencia"
    t.string   "full_name"
    t.string   "IdNumber"
    t.string   "idnumber"
    t.string   "active"
    t.integer  "categoria_id"
    t.string   "file_nro"
    t.datetime "fecha_nacimiento"
    t.integer  "ocupacion_id"
    t.string   "carnet_seguro"
    t.integer  "sexo_id"
    t.integer  "tipotrabajador_id"
    t.integer  "estado_civil_id"
    t.float    "quincena"
    t.integer  "grado_instruccion_id"
    t.float    "sueldo"
    t.integer  "sueldo_moneda"
    t.float    "horas_diarias"
    t.string   "calculo_base_hora"
    t.integer  "nacionalidad_id"
    t.string   "calculo_tardanza_hora"
    t.datetime "fecha_ingreso"
    t.datetime "fecha_cese"
    t.integer  "confianza_id"
    t.string   "anexo_referencia"
    t.integer  "motivo_cese_id"
    t.string   "anexo_contable"
    t.integer  "afp_id"
    t.string   "onp"
    t.integer  "location_id"
    t.integer  "division_id"
    t.string   "code"
    t.integer  "asignacion"
    t.integer  "flujo"
    t.integer  "comision_flujo"
    t.string   "planilla"
    t.string   "full_name2"
    t.string   "cusspp"
    t.integer  "ccosto_id"
    t.string   "cuenta_bancaria"
    t.string   "interasistence"
    t.string   "cod_interno"
    t.float    "efectivo"
    t.float    "hora_ex"
  end

  create_table "exmautorizs", force: :cascade do |t|
    t.integer  "tramit_id"
    t.integer  "tipo_tramit_id"
    t.integer  "employee_id"
    t.integer  "proyecto_minero_id"
    t.integer  "supplier_id"
    t.datetime "fecha_ingreso"
    t.datetime "fecha_vmto"
    t.integer  "truck_id"
    t.integer  "employee2_id"
    t.string   "tipo_revision_tecnica"
    t.datetime "fecha_vmto_rt"
    t.datetime "fecha_carga_rt"
    t.string   "obs_rt"
    t.integer  "employee3_id"
    t.integer  "antecedent_id"
    t.integer  "tipo_antecedent_id"
    t.datetime "fecha_vmto_ant"
    t.text     "obs_ant"
    t.integer  "employee4_id"
    t.string   "curso_cap"
    t.datetime "fecha_vmto_cap"
    t.text     "obs_cap"
    t.integer  "employee5_id"
    t.text     "tramite"
    t.datetime "fecha_vmto_ot"
    t.text     "obs_ot"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "proyecto_minero2_id"
    t.string   "code"
    t.string   "processed"
    t.string   "comments"
    t.integer  "tecnic_revision_id"
    t.datetime "date_processed"
    t.datetime "fecha"
  end

  create_table "factura_details", force: :cascade do |t|
    t.integer  "factura_id"
    t.integer  "sellvale_id"
    t.integer  "producto_id"
    t.float    "price"
    t.float    "price_discount"
    t.float    "quantity"
    t.float    "total"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "product_id"
    t.float    "discount"
  end

  create_table "facturas", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.integer  "customer_id"
    t.text     "description"
    t.text     "comments"
    t.string   "code"
    t.float    "subtotal"
    t.float    "tax"
    t.float    "total"
    t.string   "processed"
    t.string   "return"
    t.datetime "date_processed"
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "fecha"
    t.string   "serie"
    t.string   "numero"
    t.string   "payment_id"
    t.integer  "factura_id"
    t.string   "tipo"
    t.float    "pago"
    t.float    "charge"
    t.float    "balance"
    t.integer  "moneda_id"
    t.text     "observ"
    t.datetime "fecha2"
    t.string   "year_mounth"
    t.float    "detraccion"
    t.integer  "numero2"
    t.integer  "document_id"
    t.string   "descuento"
    t.integer  "tipoventa"
    t.integer  "tipoventa_id"
    t.string   "ruc"
    t.string   "contrato"
    t.string   "ost"
    t.integer  "manifest_id"
    t.text     "os_customer"
    t.string   "documento2"
    t.float    "valor_referencial"
  end

  create_table "faltantes", force: :cascade do |t|
    t.integer  "employee_id"
    t.integer  "tipofaltante_id"
    t.string   "descrip"
    t.text     "comments"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.float    "total"
    t.datetime "fecha"
  end

  create_table "fiveparameters", force: :cascade do |t|
    t.integer  "anio"
    t.float    "valor_uit"
    t.float    "hasta_5"
    t.float    "tasa1"
    t.float    "exceso_5"
    t.float    "y_hasta_20"
    t.float    "exceso_20"
    t.float    "y_hasta_35"
    t.float    "exceso_35"
    t.float    "y_hasta_45"
    t.float    "exceso_45"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "tasa2"
    t.float    "tasa3"
    t.float    "tasa4"
    t.float    "tasa5"
    t.float    "tasa6"
    t.float    "tasa7"
    t.float    "tasa8"
  end

  create_table "freepagars", force: :cascade do |t|
    t.integer  "supplier_id"
    t.float    "anio01"
    t.float    "anio02"
    t.float    "anio03"
    t.float    "anio04"
    t.float    "anio05"
    t.float    "anio06"
    t.float    "anio07"
    t.float    "general"
    t.float    "cantidad"
    t.float    "compras"
    t.float    "compras_cant"
    t.float    "total_gral"
    t.float    "cant_fact"
    t.float    "vmto"
    t.float    "xpagar"
    t.float    "detraccion"
    t.float    "saldo"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.float    "anio00"
  end

  create_table "gastos", force: :cascade do |t|
    t.integer  "codigo"
    t.string   "code"
    t.string   "descrip"
    t.string   "cuenta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "i"
    t.datetime "fecha"
    t.string   "td"
    t.string   "documento"
    t.float    "importe"
    t.float    "currtotal"
    t.integer  "company_id"
    t.string   "grupo"
    t.string   "fullcuenta"
    t.string   "flag"
  end

  create_table "grado_instruccions", force: :cascade do |t|
    t.integer  "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "histories", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "historiable_id"
    t.boolean  "new_item",         default: false
    t.string   "historiable_type"
    t.datetime "created_at",                       null: false
    t.string   "klass_type"
    t.datetime "updated_at",                       null: false
  end

  add_index "histories", ["created_at"], name: "index_histories_on_created_at", using: :btree
  add_index "histories", ["historiable_id"], name: "index_histories_on_historiable_id", using: :btree
  add_index "histories", ["user_id"], name: "index_histories_on_user_id", using: :btree

  create_table "horas_mes", force: :cascade do |t|
    t.float    "dt"
    t.float    "fal"
    t.float    "sub"
    t.float    "dm"
    t.float    "pat"
    t.float    "vac"
    t.float    "tot"
    t.integer  "payroll_id"
    t.integer  "employee_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "lsg"
    t.integer  "lcg"
    t.integer  "vtavac"
    t.integer  "otros"
  end

  create_table "inasists", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "instruccions", force: :cascade do |t|
    t.text     "description1"
    t.text     "description2"
    t.text     "description3"
    t.text     "description4"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "condicion"
    t.text     "instruccion6"
    t.text     "instruccion7"
    t.text     "instruccion8"
    t.text     "instruccion9"
    t.text     "instruccion10"
  end

  create_table "inventario_detalles", force: :cascade do |t|
    t.integer  "inventario_id"
    t.integer  "item_id"
    t.boolean  "activo"
    t.date     "fecha_vencimiento"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.float    "cantidad"
    t.float    "precio_unitario"
  end

  create_table "inventarios", force: :cascade do |t|
    t.integer  "almacen_id"
    t.datetime "fecha"
    t.string   "descripcion"
    t.string   "tipo"
    t.decimal  "total",       precision: 12, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inventories", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "store_id"
    t.integer  "account_id"
    t.date     "date"
    t.string   "ref_number"
    t.string   "operation",       limit: 10
    t.string   "state"
    t.string   "description"
    t.decimal  "total",                      precision: 14, scale: 2, default: 0.0
    t.integer  "creator_id"
    t.integer  "transference_id"
    t.integer  "store_to_id"
    t.integer  "project_id"
    t.boolean  "has_error",                                           default: false
    t.string   "error_messages"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "inventories", ["account_id"], name: "index_inventories_on_account_id", using: :btree
  add_index "inventories", ["contact_id"], name: "index_inventories_on_contact_id", using: :btree
  add_index "inventories", ["date"], name: "index_inventories_on_date", using: :btree
  add_index "inventories", ["has_error"], name: "index_inventories_on_has_error", using: :btree
  add_index "inventories", ["operation"], name: "index_inventories_on_operation", using: :btree
  add_index "inventories", ["project_id"], name: "index_inventories_on_project_id", using: :btree
  add_index "inventories", ["ref_number"], name: "index_inventories_on_ref_number", using: :btree
  add_index "inventories", ["state"], name: "index_inventories_on_state", using: :btree
  add_index "inventories", ["store_id"], name: "index_inventories_on_store_id", using: :btree

  create_table "inventory_details", force: :cascade do |t|
    t.integer  "inventory_operation_id"
    t.integer  "item_id"
    t.integer  "store_id"
    t.decimal  "quantity",               precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "inventory_details", ["inventory_operation_id"], name: "index_inventory_details_on_inventory_operation_id", using: :btree
  add_index "inventory_details", ["item_id"], name: "index_inventory_details_on_item_id", using: :btree
  add_index "inventory_details", ["store_id"], name: "index_inventory_details_on_store_id", using: :btree

  create_table "invoice_products", force: :cascade do |t|
    t.integer  "invoice_id"
    t.integer  "product_id"
    t.float    "price"
    t.integer  "quantity"
    t.float    "discount"
    t.float    "total"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoice_services", force: :cascade do |t|
    t.integer  "invoice2_id"
    t.integer  "service_id"
    t.float    "price"
    t.float    "quantity"
    t.float    "discount"
    t.float    "total"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.float    "preciocigv"
    t.integer  "factura_id"
  end

  create_table "invoiceitems", force: :cascade do |t|
    t.integer  "factura_id"
    t.string   "code"
    t.string   "cantidad"
    t.string   "um"
    t.string   "codigo"
    t.string   "descrip"
    t.float    "vunit"
    t.float    "punit"
    t.float    "vventa"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.integer  "customer_id"
    t.text     "description"
    t.text     "comments"
    t.string   "code"
    t.float    "subtotal"
    t.float    "tax"
    t.float    "total"
    t.string   "processed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "return"
    t.datetime "date_processed"
    t.integer  "user_id"
  end

  create_table "invoicesunats", force: :cascade do |t|
    t.string   "cliente"
    t.date     "fecha"
    t.string   "td"
    t.string   "serie"
    t.string   "numero"
    t.float    "cantidad"
    t.float    "vventa"
    t.float    "igv"
    t.float    "importe"
    t.string   "ruc"
    t.string   "guia"
    t.string   "codplaca10"
    t.string   "formapago"
    t.text     "description"
    t.text     "comments"
    t.string   "descrip"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.float    "preciocigv"
    t.float    "preciosigv"
    t.integer  "moneda"
    t.string   "razon"
    t.string   "documento2"
  end

  create_table "islands", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.integer  "unit_id"
    t.decimal  "price",                   precision: 14, scale: 2, default: 0.0
    t.string   "name"
    t.string   "description"
    t.string   "code",        limit: 100
    t.boolean  "for_sale",                                         default: true
    t.boolean  "stockable",                                        default: true
    t.boolean  "active",                                           default: true
    t.decimal  "buy_price",               precision: 14, scale: 2, default: 0.0
    t.string   "unit_symbol", limit: 20
    t.string   "unit_name"
    t.integer  "tag_ids",                                          default: [],   array: true
    t.integer  "updater_id"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.integer  "quantity"
    t.integer  "qty"
    t.integer  "recibir"
  end

  add_index "items", ["code"], name: "index_items_on_code", using: :btree
  add_index "items", ["creator_id"], name: "index_items_on_creator_id", using: :btree
  add_index "items", ["for_sale"], name: "index_items_on_for_sale", using: :btree
  add_index "items", ["stockable"], name: "index_items_on_stockable", using: :btree
  add_index "items", ["tag_ids"], name: "index_items_on_tag_ids", using: :btree
  add_index "items", ["unit_id"], name: "index_items_on_unit_id", using: :btree
  add_index "items", ["updater_id"], name: "index_items_on_updater_id", using: :btree

  create_table "kits_products", force: :cascade do |t|
    t.integer  "product_kit_id"
    t.integer  "product_id"
    t.string   "session"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity"
  end

  create_table "lgcs", force: :cascade do |t|
    t.integer  "employee_id"
    t.integer  "placa_id"
    t.integer  "placa_id2"
    t.float    "peso_ida"
    t.float    "peso_ret"
    t.integer  "tipo_carga_id"
    t.string   "ruta"
    t.datetime "viaje_salida_fecha"
    t.datetime "viaje_retorno_fecha"
    t.string   "recorrido"
    t.string   "float"
    t.float    "salida_km"
    t.float    "retorno_km"
    t.float    "km_real"
    t.float    "total_gal"
    t.float    "ratio_fisico"
    t.float    "ratio_teorico"
    t.float    "idle_fuel"
    t.time     "idletime"
    t.float    "time_1"
    t.float    "margen"
    t.float    "dscto_gln"
    t.float    "monto"
    t.float    "rpm"
    t.float    "km"
    t.float    "abas_total"
    t.float    "monto_total"
    t.text     "obser"
    t.integer  "user_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "lgv_deliveries", force: :cascade do |t|
    t.integer  "lgv_id"
    t.float    "importe"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "compro_id"
  end

  create_table "lgv_details", force: :cascade do |t|
    t.datetime "fecha"
    t.integer  "gasto_id"
    t.integer  "document_id"
    t.string   "documento"
    t.float    "total"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "supplier_id"
    t.integer  "lgv_id"
    t.string   "td"
    t.string   "detalle"
  end

  create_table "lgvs", force: :cascade do |t|
    t.string   "code"
    t.integer  "tranportorderd_id"
    t.datetime "fecha"
    t.integer  "viatico_id"
    t.float    "total"
    t.string   "devuelto_texto"
    t.float    "devuelto"
    t.float    "reembolso"
    t.float    "descuento"
    t.text     "observa"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "company_id"
    t.string   "processed"
    t.integer  "user_id"
    t.integer  "tranporterorder_id"
    t.integer  "tranportorder_id"
    t.text     "comments"
    t.integer  "gasto_id"
    t.integer  "compro_id"
    t.float    "inicial"
    t.float    "total_ing"
    t.float    "total_egreso"
    t.float    "saldo"
    t.integer  "lgv_id"
    t.float    "peaje"
    t.string   "cdevuelto"
    t.string   "cdescuento"
    t.string   "creembolso"
  end

  create_table "line_items", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "cart_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "quantity",         default: 1
    t.integer  "order_id"
    t.integer  "purchaseorder_id"
  end

  create_table "loan_details", force: :cascade do |t|
    t.integer  "employee_id"
    t.integer  "valor_id"
    t.string   "tm"
    t.text     "detalle"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "loan_id"
    t.float    "total"
  end

  create_table "loans", force: :cascade do |t|
    t.integer  "payroll_id"
    t.string   "descrip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "website"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "manifests", force: :cascade do |t|
    t.integer  "customer_id"
    t.string   "solicitante"
    t.datetime "fecha1"
    t.string   "telefono1"
    t.integer  "camionetaqty"
    t.integer  "camionetapeso"
    t.integer  "camionqty"
    t.integer  "camionpeso"
    t.integer  "semiqty"
    t.integer  "semipeso"
    t.integer  "extenqty"
    t.integer  "extenpeso"
    t.integer  "camaqty"
    t.integer  "camapeso"
    t.integer  "modularqty"
    t.integer  "modularpeso"
    t.integer  "punto_id"
    t.integer  "punto2_id"
    t.datetime "fecha2"
    t.string   "contacto1"
    t.string   "contacto2"
    t.string   "telefono2"
    t.text     "especificacion"
    t.float    "largo"
    t.float    "ancho"
    t.float    "alto"
    t.integer  "peso"
    t.integer  "bultos"
    t.string   "otros"
    t.text     "observa"
    t.text     "observa2"
    t.integer  "company_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "code"
    t.integer  "location_id"
    t.string   "processed"
    t.datetime "date_processed"
    t.integer  "user_id"
    t.float    "importe"
    t.integer  "tipocargue_id"
    t.string   "references"
    t.string   "manifest"
    t.string   "hora"
    t.string   "direccion1"
    t.string   "direccion2"
    t.float    "importe2"
    t.integer  "i"
    t.float    "empaletizado"
    t.float    "montacarga"
    t.float    "escolta"
    t.float    "stand_by"
    t.string   "motivo"
    t.string   "cotizacion"
    t.float    "stand_by_pen"
    t.float    "escolta_pen"
    t.string   "year_mounth"
  end

  create_table "manifestships", force: :cascade do |t|
    t.integer  "tranportorder_id"
    t.integer  "manifest_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "manigfestships", force: :cascade do |t|
    t.integer  "tranportorder_id"
    t.integer  "manifest_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "marcas", force: :cascade do |t|
    t.string   "descrip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "company_id"
  end

  create_table "modelos", force: :cascade do |t|
    t.string   "descrip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "company_id"
  end

  create_table "monedas", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "description"
    t.string   "symbol"
    t.integer  "company_id"
  end

  create_table "movement_details", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "item_id"
    t.float    "quantity",                                default: 0.0
    t.float    "price",                                   default: 0.0
    t.string   "description"
    t.decimal  "discount",       precision: 14, scale: 2, default: 0.0
    t.decimal  "balance",        precision: 14, scale: 2, default: 0.0
    t.decimal  "original_price", precision: 14, scale: 2, default: 0.0
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "product_id"
    t.float    "stock_inicial"
    t.float    "ingreso"
    t.float    "salida"
    t.float    "stock_final"
    t.datetime "fecha"
    t.integer  "user_id"
    t.integer  "document_id"
    t.string   "documento"
    t.string   "tm"
    t.float    "costo_ingreso"
    t.float    "costo_salida"
    t.float    "costo_saldo"
    t.float    "amount"
    t.string   "to"
  end

  add_index "movement_details", ["account_id"], name: "index_movement_details_on_account_id", using: :btree
  add_index "movement_details", ["item_id"], name: "index_movement_details_on_item_id", using: :btree

  create_table "movement_products", force: :cascade do |t|
    t.integer  "movement_id"
    t.integer  "product_id"
    t.integer  "unidad_id"
    t.float    "price"
    t.integer  "quantity"
    t.float    "discount"
    t.float    "total"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "movements", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.integer  "supplier_id"
    t.text     "description"
    t.text     "comments"
    t.datetime "fecha1"
    t.datetime "fecha2"
    t.integer  "payment_id"
    t.string   "money"
    t.string   "code"
    t.float    "subtotal"
    t.float    "tax"
    t.float    "detraccion"
    t.float    "percepcion"
    t.float    "total"
    t.string   "processed"
    t.string   "return"
    t.datetime "date_proceseed"
    t.integer  "user_id"
    t.string   "tm"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "document_id"
    t.string   "documento"
    t.string   "purchaseorder"
  end

  create_table "notacredits", force: :cascade do |t|
    t.datetime "fecha"
    t.string   "code"
    t.integer  "nota_id"
    t.string   "motivo"
    t.float    "subtotal"
    t.float    "tax"
    t.float    "total"
    t.integer  "moneda_id"
    t.string   "mod_factura"
    t.integer  "mod_tipo"
    t.string   "processed"
    t.string   "tipo"
    t.string   "description"
    t.integer  "customer_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "numeras", force: :cascade do |t|
    t.string   "subdiario"
    t.string   "compro"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ocupacions", force: :cascade do |t|
    t.integer  "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", force: :cascade do |t|
    t.string   "name"
    t.text     "address"
    t.string   "email"
    t.string   "pay_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "company_id"
    t.float    "subtotal"
    t.float    "tax"
    t.float    "total"
    t.integer  "user_id"
    t.string   "ruc"
  end

  create_table "output_details", force: :cascade do |t|
    t.integer  "output_id"
    t.integer  "product_id"
    t.float    "price"
    t.float    "quantity"
    t.float    "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "outputs", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.text     "description"
    t.text     "comments"
    t.string   "code"
    t.float    "subtotal"
    t.float    "tax"
    t.float    "total"
    t.string   "processed"
    t.string   "return"
    t.datetime "date_processed"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "supplier_id"
    t.integer  "employee_id"
    t.integer  "truck_id"
    t.datetime "fecha"
    t.integer  "almacen_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string   "title"
    t.string   "slug"
    t.float    "price"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "companies"
    t.integer  "locations"
    t.integer  "users"
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.string   "title_clean"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parameter_details", force: :cascade do |t|
    t.integer  "parameter_id"
    t.integer  "afp_id"
    t.float    "aporte"
    t.float    "seguro"
    t.float    "comision"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.float    "comision_flujo"
    t.float    "comision_mixta"
    t.float    "comision_mixta_saldo"
  end

  create_table "parameters", force: :cascade do |t|
    t.string   "code"
    t.datetime "fecha"
    t.float    "onp"
    t.float    "sctr_1"
    t.float    "sctr_2"
    t.float    "essalud"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "description"
    t.float    "asigfamiliar"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string   "name"
    t.string   "internal_type"
    t.integer  "vendor_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "hidden",        default: 0
    t.integer  "hidden_by"
    t.boolean  "cash"
    t.boolean  "change"
    t.boolean  "unpaid"
    t.boolean  "quote"
    t.integer  "position"
    t.integer  "company_id"
    t.datetime "hidden_at"
  end

  create_table "payment_notices", force: :cascade do |t|
    t.string   "code"
    t.integer  "employee_id"
    t.string   "asunto"
    t.datetime "fecha"
    t.string   "concepto"
    t.float    "total"
    t.string   "processed"
    t.datetime "date_processed"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "company_id"
    t.integer  "supplier_id"
  end

  create_table "paymentnotice_details", force: :cascade do |t|
    t.datetime "fecha_inicio"
    t.datetime "fecha_culmina"
    t.float    "total"
    t.string   "descrip"
    t.string   "lugar"
    t.float    "price_unit"
    t.float    "sub_total"
    t.float    "igv"
    t.string   "nro_compro"
    t.string   "nro_documento"
    t.string   "observa"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "payment_notice_id"
    t.float    "qty"
    t.integer  "proyecto_minero_id"
  end

  create_table "payments", force: :cascade do |t|
    t.string   "descrip"
    t.text     "comment"
    t.integer  "day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "company_id"
  end

  create_table "payroll_details", force: :cascade do |t|
    t.integer  "employee_id"
    t.float    "remuneracion"
    t.float    "calc1"
    t.float    "calc2"
    t.float    "calc3"
    t.float    "total1"
    t.float    "calc4"
    t.float    "calc5"
    t.float    "calc6"
    t.float    "calc7"
    t.float    "total2"
    t.float    "remneta"
    t.float    "calc8"
    t.float    "calc9"
    t.float    "calc10"
    t.float    "total3"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "payroll_id"
    t.float    "totaldia"
    t.float    "falta"
    t.float    "vaca"
    t.float    "desmed"
    t.float    "subsidio"
    t.float    "hextra"
    t.float    "reintegro"
    t.float    "otros"
    t.float    "dias"
    t.float    "vacaciones"
    t.float    "desmedico"
    t.float    "subsidio0"
    t.float    "totingreso"
    t.float    "quinta"
    t.float    "faltas"
    t.float    "basico"
    t.float    "hextra0"
    t.float    "aporte"
    t.float    "seguro"
    t.float    "comision"
    t.float    "hextra00"
    t.float    "aporte0"
    t.float    "seguro0"
    t.float    "comision0"
    t.integer  "lsg"
    t.integer  "lcg"
    t.integer  "vtavac"
    t.integer  "dt"
    t.integer  "pat"
    t.float    "total0"
    t.float    "xdia"
    t.float    "hesab"
    t.float    "hedom"
    t.float    "he25"
    t.float    "he35"
    t.float    "he100"
    t.float    "prestamo"
  end

  create_table "payrollbonis", force: :cascade do |t|
    t.string   "code"
    t.string   "descrip"
    t.float    "importe"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "valor_id"
    t.integer  "payroll_id"
    t.integer  "employee_id"
    t.integer  "tm_id"
  end

  create_table "payrolls", force: :cascade do |t|
    t.string   "code"
    t.string   "type_payroll"
    t.string   "integer"
    t.datetime "fecha"
    t.datetime "fecha_inicial"
    t.datetime "fecha_final"
    t.datetime "fecha_pago"
    t.integer  "company_id"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "type_payroll_id"
    t.integer  "parameter_id"
    t.datetime "date_processed"
  end

  create_table "products", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.string   "category"
    t.integer  "supplier_id"
    t.float    "cost"
    t.float    "price"
    t.string   "tax1_name"
    t.float    "tax1"
    t.string   "tax2_name"
    t.float    "tax2"
    t.string   "tax3_name"
    t.float    "tax3"
    t.integer  "reorder"
    t.text     "description"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.float    "discount"
    t.float    "CurrTotal"
    t.integer  "i"
    t.float    "price2"
    t.string   "status"
    t.integer  "quantity_transit"
    t.integer  "marca_id"
    t.integer  "modelo_id"
    t.integer  "products_category_id"
    t.integer  "Category_id"
    t.integer  "category_id"
    t.integer  "ubica_id"
    t.string   "unidad"
    t.string   "ubicacion"
    t.float    "quantity"
    t.float    "currtotal"
    t.string   "numparte"
    t.string   "active"
    t.integer  "stock_id"
    t.integer  "products_lines_id"
    t.integer  "products_grupos_id"
    t.integer  "unidad_id"
    t.string   "stock_active"
  end

  add_index "products", ["stock_id"], name: "index_products_on_stock_id", using: :btree

  create_table "products_categories", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  create_table "products_grupos", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products_kits", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
  end

  create_table "products_lines", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proyecto_exams", force: :cascade do |t|
    t.integer  "employee_id"
    t.integer  "proyecto_minero_exam_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "proyecto_minero_id"
  end

  create_table "proyecto_minero_exams", force: :cascade do |t|
    t.datetime "fecha"
    t.string   "observacion"
    t.string   "reference"
    t.integer  "proyecto_minero_id"
    t.integer  "proyectominero2_id"
    t.integer  "proyectominero3_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "ordeorden"
  end

  create_table "proyecto_mineros", force: :cascade do |t|
    t.string   "code"
    t.datetime "fecha1"
    t.datetime "fecha2"
    t.string   "descrip"
    t.integer  "punto_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "proyecto_minero_id"
  end

  create_table "proyectoexam_details", force: :cascade do |t|
    t.integer  "proyecto_minero_exam_id"
    t.datetime "fecha"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "employee_id"
    t.integer  "proyecto_exam_id"
    t.integer  "proyecto_minero_id"
    t.string   "observacion"
  end

  create_table "proyectominero2s", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proyectominero3s", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "formatofecha"
    t.string   "formatotexto"
  end

  create_table "pumps", force: :cascade do |t|
    t.string   "fuel"
    t.string   "pump01"
    t.integer  "tank_id"
    t.integer  "product_id"
    t.float    "price_buy"
    t.float    "price_sell"
    t.float    "le_an_gln"
    t.float    "le_ac_gln"
    t.float    "gln"
    t.datetime "date1"
    t.integer  "employee_id"
    t.string   "turno"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "tanque_id"
    t.integer  "island_id"
  end

  create_table "puntos", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchase_details", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "unit_id"
    t.float    "price_with_tax"
    t.float    "price_without_tax"
    t.float    "price_public"
    t.float    "quantity"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.float    "totaltax"
    t.float    "totaltax2"
    t.float    "discount"
    t.float    "total"
    t.integer  "purchase_id"
    t.float    "inafecto"
    t.float    "impuesto"
  end

  create_table "purchaseorder_details", force: :cascade do |t|
    t.integer  "purchaseorder_id"
    t.integer  "product_id"
    t.integer  "unidad_id"
    t.float    "price"
    t.float    "quantity"
    t.float    "discount"
    t.float    "total"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "quantity_transit"
    t.integer  "pending"
  end

  create_table "purchaseorders", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.integer  "supplier_id"
    t.text     "description"
    t.text     "comments"
    t.datetime "fecha1"
    t.integer  "payment_id"
    t.string   "money"
    t.string   "code"
    t.float    "subtotal"
    t.float    "tax"
    t.float    "detraccion"
    t.float    "percepcion"
    t.float    "total"
    t.string   "processed"
    t.string   "return"
    t.datetime "date_proceseed"
    t.integer  "user_id"
    t.string   "moneda"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "received"
    t.datetime "date_processed"
    t.integer  "moneda_id"
    t.datetime "fecha2"
    t.string   "cotizacion"
    t.string   "cotiza"
    t.datetime "fecha_entrega"
    t.string   "otros"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer  "document_type_id"
    t.datetime "date1"
    t.datetime "date2"
    t.float    "exchange"
    t.integer  "unit_id"
    t.float    "price_with_tax"
    t.float    "price_without_tax"
    t.float    "price_public"
    t.float    "quantity"
    t.integer  "other"
    t.float    "discount"
    t.float    "tax1"
    t.float    "payable_amount"
    t.float    "tax_amount"
    t.float    "total_amount"
    t.string   "status"
    t.string   "pricestatus"
    t.float    "charge"
    t.float    "balance"
    t.float    "tax2"
    t.integer  "supplier_id"
    t.string   "order1"
    t.integer  "user_id"
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.text     "comments"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "processed"
    t.string   "return"
    t.datetime "date_processed"
    t.string   "money"
    t.integer  "payment_id"
    t.integer  "document_id"
    t.integer  "moneda_id"
    t.string   "documento"
    t.datetime "date3"
    t.float    "pago"
    t.integer  "purchaseorder_id"
    t.string   "yearmonth"
    t.string   "tipo"
    t.float    "participacion"
    t.float    "percepcion"
    t.string   "tiponota"
    t.float    "inafecto"
    t.float    "pagos"
    t.datetime "date4"
    t.integer  "truck_id"
    t.integer  "almacen_id"
    t.string   "suma_stock"
  end

  create_table "purchaseships", force: :cascade do |t|
    t.integer  "serviceorder_id"
    t.integer  "purchase_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "quintos", force: :cascade do |t|
    t.integer  "anio"
    t.integer  "employee_id"
    t.integer  "mes"
    t.float    "rem_actual"
    t.float    "rem_mes"
    t.float    "asignacion"
    t.float    "hextras"
    t.float    "otros1"
    t.integer  "mes_proy"
    t.float    "rem_proyectada"
    t.float    "gratijulio"
    t.float    "gratidic"
    t.float    "bonextra"
    t.float    "otros2"
    t.float    "ene1"
    t.float    "feb1"
    t.float    "mar1"
    t.float    "abr1"
    t.float    "may1"
    t.float    "jun1"
    t.float    "jul1"
    t.float    "ago1"
    t.float    "set1"
    t.float    "oct1"
    t.float    "nov1"
    t.float    "renta_bruta"
    t.float    "deduccion7"
    t.float    "total_renta"
    t.float    "renta_impo1"
    t.float    "renta_impo2"
    t.float    "renta_impo3"
    t.float    "renta_impo4"
    t.float    "renta_impo5"
    t.float    "total_renta_impo"
    t.float    "ene2"
    t.float    "feb2"
    t.float    "mar2"
    t.float    "abr2"
    t.float    "may2"
    t.float    "jun2"
    t.float    "jul2"
    t.float    "ago2"
    t.float    "set2"
    t.float    "oct2"
    t.float    "nov2"
    t.float    "dic2"
    t.float    "renta_impo_ret"
    t.integer  "mes_pendiente"
    t.float    "retencion_mensual"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.float    "gratijulio1"
    t.float    "renta_anual_1"
    t.float    "renta_anual_2"
    t.float    "renta_anual_3"
    t.float    "renta_anual_4"
    t.float    "renta_anual_5"
    t.float    "total_renta_anual"
  end

  create_table "quotation_details", force: :cascade do |t|
    t.string   "descrip"
    t.float    "costo1"
    t.float    "costo2"
    t.float    "total"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "quotation_id"
    t.float    "total2"
    t.float    "qty"
    t.integer  "item"
  end

  create_table "quotations", force: :cascade do |t|
    t.datetime "fecha1"
    t.string   "code"
    t.integer  "customer_id"
    t.integer  "punto_id"
    t.text     "carga"
    t.text     "tipo_unidad"
    t.float    "importe"
    t.text     "condiciones"
    t.text     "respon"
    t.text     "seguro"
    t.integer  "firma_id"
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "processed"
    t.string   "date_processed"
    t.integer  "moneda_id"
    t.float    "dolar"
    t.integer  "user_id"
    t.string   "op1"
    t.string   "op2"
    t.string   "op3"
    t.integer  "instruccion_id"
  end

  create_table "remisions", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "requerimientos", force: :cascade do |t|
    t.string   "code"
    t.integer  "employee_id"
    t.integer  "division_id"
    t.datetime "fecha"
    t.string   "hora"
    t.string   "item_1"
    t.string   "codigo_1"
    t.integer  "cantidad_1"
    t.string   "unidad_1"
    t.string   "descrip_1"
    t.string   "placa_1"
    t.string   "item_2"
    t.string   "codigo_2"
    t.integer  "cantidad_2"
    t.string   "unidad_2"
    t.string   "descrip_2"
    t.string   "placa_2"
    t.string   "item_3"
    t.string   "codigo_3"
    t.integer  "cantidad_3"
    t.string   "unidad_3"
    t.string   "descrip_3"
    t.string   "placa_3"
    t.string   "item_4"
    t.string   "codigo_4"
    t.integer  "cantidad_4"
    t.string   "unidad_4"
    t.string   "descrip_4"
    t.string   "placa_4"
    t.string   "item_5"
    t.string   "codigo_5"
    t.integer  "cantidad_5"
    t.string   "unidad_5"
    t.string   "descrip_5"
    t.string   "placa_5"
    t.string   "item_6"
    t.string   "codigo_6"
    t.integer  "cantidad_6"
    t.string   "unidad_6"
    t.string   "descrip_6"
    t.string   "placa_6"
    t.string   "item_7"
    t.string   "codigo_7"
    t.integer  "cantidad_7"
    t.string   "unidad_7"
    t.string   "descrip_7"
    t.string   "placa_7"
    t.string   "item_8"
    t.string   "codigo_8"
    t.integer  "cantidad_8"
    t.string   "unidad_8"
    t.string   "descrip_8"
    t.string   "placa_8"
    t.string   "item_9"
    t.string   "codigo_9"
    t.integer  "cantidad_9"
    t.string   "unidad_9"
    t.string   "descrip_9"
    t.string   "placa_9"
    t.string   "item_10"
    t.string   "codigo_10"
    t.integer  "cantidad_10"
    t.string   "unidad_10"
    t.string   "descrip_10"
    t.string   "placa_10"
    t.text     "nota"
    t.text     "observa"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "processed"
    t.datetime "date_processed"
    t.integer  "user_id"
    t.string   "motivo"
  end

  create_table "restocks", force: :cascade do |t|
    t.integer  "product_id"
    t.integer  "supplier_id"
    t.integer  "quantity"
    t.datetime "when"
    t.string   "received"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.string   "code"
    t.string   "already_processed"
  end

  create_table "rqdetails", force: :cascade do |t|
    t.integer  "requerimiento_id"
    t.string   "codigo"
    t.float    "qty"
    t.integer  "unidad_id"
    t.string   "descrip"
    t.string   "placa_destino"
    t.string   "string"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "atento"
  end

  create_table "sellvales", force: :cascade do |t|
    t.string   "td"
    t.datetime "fecha"
    t.string   "turno"
    t.string   "cod_emp"
    t.string   "caja"
    t.string   "serie"
    t.string   "numero"
    t.string   "cod_cli"
    t.string   "ruc"
    t.string   "placa"
    t.string   "odometro"
    t.string   "cod_prod"
    t.float    "cantidad"
    t.string   "precio"
    t.string   "importe"
    t.float    "igv"
    t.float    "fpago"
    t.float    "dolat"
    t.float    "implista"
    t.string   "cod_tar"
    t.string   "km"
    t.string   "chofer"
    t.string   "tk_devol"
    t.string   "cod_sucu"
    t.string   "isla"
    t.string   "dni_cli"
    t.string   "clear"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float    "dolar"
    t.string   "processed"
    t.string   "tipo"
  end

  create_table "service_extensions", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "servicebuy_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "service_extensions", ["servicebuy_id"], name: "index_service_extensions_on_servicebuy_id", using: :btree

  create_table "servicebuys", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.float    "cost"
    t.float    "price"
    t.string   "tax1_name"
    t.float    "tax1"
    t.string   "tax2_name"
    t.float    "tax2"
    t.string   "tax3_name"
    t.float    "tax3"
    t.integer  "quantity"
    t.text     "description"
    t.text     "comments"
    t.integer  "company_id"
    t.float    "discount"
    t.float    "currtotal"
    t.integer  "i"
    t.float    "total"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "ext_id"
    t.string   "name_ext"
    t.string   "truck_ext"
    t.string   "empleado_ext"
  end

  create_table "serviceorder_services", force: :cascade do |t|
    t.integer  "serviceorder_id"
    t.integer  "service_id"
    t.float    "price"
    t.integer  "quantity"
    t.float    "discount"
    t.float    "total"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "servicebuy_id"
    t.integer  "ext_id"
    t.string   "name_ext"
    t.integer  "truck_id"
    t.integer  "employee_id"
    t.integer  "i"
  end

  create_table "serviceorders", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.integer  "supplier_id"
    t.text     "description"
    t.text     "comments"
    t.datetime "fecha1"
    t.integer  "payment_id"
    t.string   "money"
    t.string   "code"
    t.float    "subtotal"
    t.float    "tax"
    t.float    "detraccion"
    t.float    "percepcion"
    t.float    "total"
    t.string   "processed"
    t.string   "return"
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "instruccion_id"
    t.string   "moneda"
    t.integer  "moneda_id"
    t.datetime "date_processed"
    t.integer  "document_id"
    t.datetime "fecha2"
    t.datetime "fecha3"
    t.datetime "fecha4"
    t.string   "documento"
    t.integer  "purchase_id"
    t.float    "dolar"
    t.integer  "truck_id"
    t.integer  "employee_id"
    t.float    "detracion_percent"
    t.string   "cotiza"
    t.datetime "fecha_entrega"
    t.string   "otros"
  end

  create_table "services", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.float    "cost"
    t.float    "price"
    t.string   "tax1_name"
    t.float    "tax1"
    t.float    "quantity"
    t.text     "description"
    t.text     "comments"
    t.integer  "company_id"
    t.float    "discount"
    t.float    "currtotal"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "i"
    t.float    "total"
    t.integer  "peso"
    t.integer  "unidad_id"
    t.string   "cuenta"
    t.float    "tax2"
    t.string   "tax2_name"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.integer  "user_id"
    t.string   "session"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "stocks", force: :cascade do |t|
    t.integer  "store_id"
    t.integer  "item_id"
    t.string   "state",        limit: 20
    t.integer  "user_id"
    t.boolean  "active",                  default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id"
    t.float    "unitary_cost"
    t.float    "quantity"
    t.float    "minimum"
    t.integer  "document_id"
    t.string   "documento"
  end

  add_index "stocks", ["item_id"], name: "index_stocks_on_item_id", using: :btree
  add_index "stocks", ["state"], name: "index_stocks_on_state", using: :btree
  add_index "stocks", ["store_id"], name: "index_stocks_on_store_id", using: :btree
  add_index "stocks", ["user_id"], name: "index_stocks_on_user_id", using: :btree

  create_table "stsships", force: :cascade do |t|
    t.integer  "factura_id"
    t.integer  "manifest_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "subcontrats", force: :cascade do |t|
    t.string   "ruc"
    t.string   "name"
    t.string   "address1"
    t.string   "distrito"
    t.string   "provincia"
    t.string   "dpto"
    t.string   "pais"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "supplier_details", force: :cascade do |t|
    t.string   "name"
    t.string   "cargo"
    t.string   "telefono"
    t.string   "correo"
    t.string   "area"
    t.integer  "supplier_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "supplier_details", ["supplier_id"], name: "index_supplier_details_on_supplier_id", using: :btree

  create_table "supplier_payment_details", force: :cascade do |t|
    t.integer  "document_id"
    t.string   "documento"
    t.integer  "supplier_id"
    t.string   "tm"
    t.float    "total"
    t.text     "descrip"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "purchase_id"
    t.integer  "supplier_payment_id"
  end

  create_table "supplier_payments", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.integer  "bank_acount_id"
    t.integer  "document_id"
    t.string   "documento"
    t.integer  "supplier_id"
    t.string   "tm"
    t.float    "total"
    t.datetime "fecha1"
    t.datetime "fecha2"
    t.string   "nrooperacion"
    t.string   "operacion"
    t.text     "descrip"
    t.text     "comments"
    t.integer  "user_id"
    t.string   "processed"
    t.datetime "date_processed"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "code"
  end

  create_table "supplier_types", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "suppliers", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.string   "ruc",              limit: 11
    t.string   "taxable"
    t.string   "account"
    t.string   "tipo1"
    t.string   "tipo2"
    t.integer  "bank_id"
    t.string   "cuenta_corriente"
    t.string   "proyecto_minero"
    t.integer  "supplier_type_id"
    t.string   "service_type"
    t.text     "lugar"
    t.string   "tipoexm"
  end

  create_table "tanks", force: :cascade do |t|
    t.string   "comments"
    t.integer  "product_id"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tanks", ["company_id"], name: "index_tanks_on_company_id", using: :btree
  add_index "tanks", ["product_id"], name: "index_tanks_on_product_id", using: :btree

  create_table "tanques", force: :cascade do |t|
    t.string   "code"
    t.integer  "product_id"
    t.float    "saldo_inicial"
    t.float    "varilla"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "tecnic_revisions", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "telecredito_details", force: :cascade do |t|
    t.datetime "fecha"
    t.string   "nro"
    t.string   "operacion"
    t.integer  "purchase_id"
    t.string   "beneficiario"
    t.string   "documento"
    t.string   "moneda"
    t.float    "importe"
    t.float    "egreso"
    t.string   "aprueba"
    t.string   "observacion"
    t.integer  "telecredito_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "telecreditos", force: :cascade do |t|
    t.datetime "fecha1"
    t.datetime "fecha2"
    t.string   "code"
    t.integer  "bank_acount_id"
    t.float    "importe"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "processed"
  end

  create_table "tempcps", force: :cascade do |t|
    t.datetime "fecha2"
    t.string   "month_year"
    t.integer  "customer_id"
    t.float    "balance"
    t.integer  "moneda_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "customer_payment_detail_id"
  end

  create_table "tempfacturas", force: :cascade do |t|
    t.integer  "customer_id"
    t.float    "balance"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "year_month"
  end

  create_table "tickets", force: :cascade do |t|
    t.datetime "fecha"
    t.integer  "eess_id"
    t.integer  "truck_id"
    t.integer  "product_id"
    t.float    "quantity"
    t.float    "precioigv"
    t.float    "importe"
    t.integer  "employee_id"
    t.datetime "fecha_fact"
    t.integer  "factura_id"
    t.integer  "supplier_id"
    t.integer  "card_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "factu"
    t.integer  "tipocar_id"
  end

  create_table "tipo_tramits", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipo_unidads", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipocambios", force: :cascade do |t|
    t.datetime "dia"
    t.float    "compra"
    t.float    "venta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipocargues", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipocars", force: :cascade do |t|
    t.string   "code"
    t.string   "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "tipocar_id"
  end

  create_table "tipocustomers", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipofacturas", force: :cascade do |t|
    t.string   "descrip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "company_id"
  end

  create_table "tipofaltantes", force: :cascade do |t|
    t.string   "code"
    t.string   "descrip"
    t.float    "importe"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipoproveedors", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipotrabajadors", force: :cascade do |t|
    t.integer  "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tipoventa", force: :cascade do |t|
    t.string   "code"
    t.string   "nombre"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "tipoventa_id"
  end

  create_table "tms", force: :cascade do |t|
    t.string   "code"
    t.string   "descrip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tramits", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tranportorders", force: :cascade do |t|
    t.string   "code"
    t.integer  "employee_id"
    t.integer  "truck_id"
    t.integer  "employee2_id"
    t.integer  "truck2_id"
    t.integer  "ubication_id"
    t.integer  "ubication2_id"
    t.datetime "fecha1"
    t.datetime "fecha2"
    t.text     "description"
    t.text     "comments"
    t.string   "processed"
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "division_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "user_id"
    t.integer  "i"
    t.string   "tm"
    t.string   "comprobante"
    t.float    "importe"
    t.string   "detalle"
    t.float    "CurrTotal"
    t.datetime "fecha"
    t.string   "estado"
    t.datetime "date_processed"
    t.string   "customer_id"
    t.integer  "tipocargue_id"
    t.string   "carga"
    t.integer  "truck3_id"
    t.integer  "employee3_id"
    t.integer  "employee4_id"
  end

  create_table "transferencia_detalles", force: :cascade do |t|
    t.integer  "item_id"
    t.integer  "transferencia_id"
    t.float    "cantidad"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transferencias", force: :cascade do |t|
    t.integer  "almacen_origen_id"
    t.integer  "almacen_destino_id"
    t.datetime "fecha"
    t.float    "total"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trucks", force: :cascade do |t|
    t.string   "code"
    t.string   "placa"
    t.string   "clase"
    t.integer  "marca_id"
    t.integer  "modelo_id"
    t.string   "certificado"
    t.integer  "ejes"
    t.string   "licencia"
    t.string   "neumatico"
    t.string   "config"
    t.string   "carroceria"
    t.integer  "anio"
    t.string   "estado"
    t.string   "propio"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "tipo_unidad_id"
    t.integer  "config_vehi_id"
    t.integer  "clase_cat_id"
    t.integer  "color_vehi_id"
  end

  create_table "type_payrolls", force: :cascade do |t|
    t.string   "code"
    t.string   "descrip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ubicas", force: :cascade do |t|
    t.string   "descrip"
    t.text     "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ubications", force: :cascade do |t|
    t.string   "descrip"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unidads", force: :cascade do |t|
    t.string   "descrip"
    t.float    "valorconversion"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "company_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "most_recent_report"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_packages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "package_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "companies"
    t.integer  "locations"
    t.integer  "users"
  end

  create_table "vacations", force: :cascade do |t|
    t.integer  "employee_id"
    t.datetime "fecha1"
    t.datetime "fecha2"
    t.text     "observa"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "valors", force: :cascade do |t|
    t.string   "name"
    t.text     "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "varillajes", force: :cascade do |t|
    t.integer  "tanque_id"
    t.integer  "product_id"
    t.float    "inicial"
    t.float    "compras"
    t.float    "directo"
    t.float    "consumo"
    t.float    "transfe"
    t.float    "saldo"
    t.float    "varilla"
    t.string   "dife_dia"
    t.datetime "fecha"
    t.string   "documento"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "venta", force: :cascade do |t|
    t.string   "td"
    t.datetime "fecha"
    t.string   "turno"
    t.string   "cod_emp"
    t.string   "caja"
    t.string   "serie"
    t.string   "numero"
    t.string   "cod_cli"
    t.string   "ruc"
    t.string   "placa"
    t.string   "odometro"
    t.string   "cod_prod"
    t.float    "cantidad"
    t.string   "precio"
    t.string   "importe"
    t.float    "igv"
    t.float    "fpago"
    t.float    "dolat"
    t.float    "implista"
    t.string   "cod_tar"
    t.string   "km"
    t.string   "chofer"
    t.string   "tk_devol"
    t.string   "cod_sucu"
    t.string   "isla"
    t.string   "dni_cli"
    t.string   "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ventaisla_details", force: :cascade do |t|
    t.integer  "pump_id"
    t.float    "le_an_gln"
    t.float    "le_ac_gln"
    t.float    "price"
    t.float    "quantity"
    t.float    "total"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "ventaisla_id"
    t.integer  "product_id"
  end

  create_table "ventaislas", force: :cascade do |t|
    t.datetime "fecha"
    t.string   "turno"
    t.integer  "employee_id"
    t.integer  "pump_id"
    t.float    "importe"
    t.float    "le_an_gln"
    t.float    "le_ac_gln"
    t.float    "galones"
    t.float    "precio_ven"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "ventaisla_id"
  end

  create_table "viatico_details", force: :cascade do |t|
    t.integer  "viatico_id"
    t.datetime "fecha"
    t.text     "descrip"
    t.integer  "document_id"
    t.string   "numero"
    t.float    "importe"
    t.text     "detalle"
    t.string   "tm"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.float    "CurrTotal"
    t.integer  "tranportorder_id"
    t.datetime "date_processed"
    t.string   "ruc"
    t.integer  "supplier_id"
    t.integer  "gasto_id"
    t.integer  "employee_id"
    t.integer  "destino_id"
    t.integer  "egreso_id"
  end

  create_table "viaticos", force: :cascade do |t|
    t.string   "code"
    t.datetime "fecha1"
    t.float    "inicial"
    t.float    "total_ing"
    t.float    "total_egreso"
    t.float    "saldo"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "comments"
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "processed"
    t.integer  "compro_id"
    t.datetime "date_processed"
    t.string   "tipo"
    t.integer  "caja_id"
    t.string   "cdevuelto"
    t.string   "cdescuento"
    t.string   "creembolso"
  end

  create_table "voideds", force: :cascade do |t|
    t.string   "serie"
    t.string   "numero"
    t.string   "texto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "assistances", "inasists"
  add_foreign_key "conductors", "employees"
  add_foreign_key "contactopmdetails", "contactopms"
  add_foreign_key "cpagar_details", "cpagars"
  add_foreign_key "products", "stocks"
  add_foreign_key "service_extensions", "servicebuys"
  add_foreign_key "supplier_details", "suppliers"
  add_foreign_key "tanks", "companies"
  add_foreign_key "tanks", "products"
end
