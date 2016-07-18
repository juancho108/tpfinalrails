class CreateOriginSales < ActiveRecord::Migration
  def change
    create_table :origin_sales do |t|
      t.string :nombre
      t.float :monto_bruto
      t.float :monto_neto

      t.timestamps null: false
    end
  end
end
