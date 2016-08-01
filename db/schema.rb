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

ActiveRecord::Schema.define(version: 20160801142920) do

  create_table "categories", force: :cascade do |t|
    t.string   "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "padre_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string   "nombre"
    t.string   "mail"
    t.string   "detalle_adicional"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "copies", force: :cascade do |t|
    t.string   "lugar"
    t.float    "precio_compra"
    t.string   "packaging"
    t.string   "estado_del_producto"
    t.string   "estado"
    t.string   "nro_serie"
    t.string   "descripcion"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "product_id"
  end

  create_table "finances", force: :cascade do |t|
    t.string   "nombre"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.float    "dinero",     default: 0.0
    t.boolean  "tipo_mp"
  end

  create_table "movements", force: :cascade do |t|
    t.string   "operacion"
    t.string   "tipo_operacion"
    t.string   "persona"
    t.float    "monto_neto"
    t.datetime "fecha_operacion"
    t.string   "detalles_adicionales"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "origen_id"
    t.integer  "destino_id"
    t.integer  "sale_id"
    t.float    "monto_bruto",          default: 0.0
  end

  add_index "movements", ["destino_id"], name: "index_movements_on_destino_id"
  add_index "movements", ["origen_id"], name: "index_movements_on_origen_id"
  add_index "movements", ["sale_id"], name: "index_movements_on_sale_id"

  create_table "options", force: :cascade do |t|
    t.string   "dolar_libre"
    t.string   "dolar_blue"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.float    "porcentaje_mercadolibre", default: 0.0
    t.float    "porcentaje_mercadopago",  default: 0.0
    t.float    "porcentaje_ml_mp",        default: 0.0
    t.string   "skin",                    default: "blue"
  end

  create_table "origin_sales", force: :cascade do |t|
    t.string   "nombre"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "tipo"
    t.float    "monto_bruto", default: 0.0
    t.float    "monto_neto",  default: 0.0
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "ruta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "copy_id"
  end

  create_table "products", force: :cascade do |t|
    t.string   "nombre"
    t.string   "tipo_stock"
    t.string   "instruccion_general"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "category_id"
  end

  create_table "records", force: :cascade do |t|
    t.string   "estado"
    t.integer  "orden"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "copy_id"
    t.integer  "product_id"
    t.integer  "cuenta_ml_id"
  end

  add_index "records", ["cuenta_ml_id"], name: "index_records_on_cuenta_ml_id"

  create_table "sales", force: :cascade do |t|
    t.float    "precio_bruto"
    t.float    "precio_neto"
    t.float    "ganancia"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "copy_id"
    t.integer  "client_id"
    t.integer  "origin_sale_id"
    t.integer  "finance_id"
    t.string   "estado"
    t.integer  "forma_de_pago_id"
    t.integer  "usuario_id"
    t.integer  "cantidad_de_pagos", default: 1
  end

  add_index "sales", ["forma_de_pago_id"], name: "index_sales_on_forma_de_pago_id"
  add_index "sales", ["usuario_id"], name: "index_sales_on_usuario_id"

  create_table "users", force: :cascade do |t|
    t.string   "nombre"
    t.string   "apellido"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "role",                   default: 0
    t.datetime "last_sign_out_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
