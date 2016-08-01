class AddAttributesToConfiguration < ActiveRecord::Migration
  def change
    add_column :configurations, :porcentaje_mercadolibre, :float, default: 0
    add_column :configurations, :porcentaje_mercadopago, :float, default: 0
    add_column :configurations, :porcentaje_ml_mp, :float, default: 0
  end
end

