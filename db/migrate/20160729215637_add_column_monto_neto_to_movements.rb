class AddColumnMontoNetoToMovements < ActiveRecord::Migration
  def change
    add_column :movements, :monto_bruto, :float, default: 0.0
  end
end
