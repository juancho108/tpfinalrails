class ChangeTableSales < ActiveRecord::Migration
  def change
    remove_column :sales, :forma_de_pago, :string
  
    add_reference :sales, :forma_de_pago, index: true
    add_foreign_key :sales, :forma_de_pago
  end
end