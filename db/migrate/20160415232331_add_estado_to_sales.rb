class AddEstadoToSales < ActiveRecord::Migration
  def change
    add_column :sales, :estado, :string
  end
end
