class AddSocioToMovements < ActiveRecord::Migration
  def change
    add_reference :movements, :socio, index: true
    add_foreign_key :movements, :socio
  end
end
