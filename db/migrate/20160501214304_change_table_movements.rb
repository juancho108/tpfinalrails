class ChangeTableMovements < ActiveRecord::Migration
  def change
    remove_column :movements, :forma_de_pago, :string
  
    add_reference :movements, :origen, index: true
    add_foreign_key :movements, :origen
    add_reference :movements, :destino, index: true
    add_foreign_key :movements, :destino
  end
end
