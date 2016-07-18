class CreateCopies < ActiveRecord::Migration
  def change
    create_table :copies do |t|
      t.string :lugar
      t.float :precio_compra
      t.string :packaging
      t.string :estado_del_producto
      t.string :estado
      t.string :nro_serie
      t.string :descripcion

      t.timestamps null: false

      t.references :product
    end
  end
end
