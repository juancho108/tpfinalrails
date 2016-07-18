class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.float :precio_bruto
      t.float :precio_neto
      t.string :forma_de_pago
      t.string :quien_cargo
      t.float :ganancia

      t.timestamps null: false

      t.references :copy
      t.references :client
      t.references :origin_sale
      t.references :finance
    end
  end
end
