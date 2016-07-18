class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :nombre
      t.string :mail
      t.string :detalle_adicional

      t.timestamps null: false
    end
  end
end
