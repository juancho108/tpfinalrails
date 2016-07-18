class AddCantidadDePagosToSales < ActiveRecord::Migration
  def change
    add_column :sales, :cantidad_de_pagos, :integer, default: 1
  end
end
