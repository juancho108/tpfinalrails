class CreateMovements < ActiveRecord::Migration
  def change
    create_table :movements do |t|
      t.string :operacion
      t.string :tipo_operacion
      t.string :forma_de_pago
      t.string :persona
      t.float :monto_neto
      t.datetime :fecha_operacion
      t.string :detalles_adicionales

      t.timestamps null: false

    end
  end
end
