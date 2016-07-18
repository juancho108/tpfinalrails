class AddTipoToOriginSales < ActiveRecord::Migration
  def change
    add_column :origin_sales, :tipo, :boolean

    remove_column :origin_sales, :monto_bruto, :float
    remove_column :origin_sales, :monto_neto, :float

  
    add_column :origin_sales, :monto_bruto, :float, default: 0
    add_column :origin_sales, :monto_neto, :float, default: 0
  end
end
