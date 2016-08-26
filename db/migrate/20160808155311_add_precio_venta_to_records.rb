class AddPrecioVentaToRecords < ActiveRecord::Migration
  def change
    add_column :records, :precio_venta, :float, default: 0
  end
end
