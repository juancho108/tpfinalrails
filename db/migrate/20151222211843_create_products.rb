class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :nombre
      t.string :tipo_stock
      t.string :instruccion_general

      t.timestamps null: false

      t.references :category
    end
  end
end
