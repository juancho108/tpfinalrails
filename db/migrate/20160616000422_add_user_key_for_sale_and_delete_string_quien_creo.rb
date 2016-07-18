class AddUserKeyForSaleAndDeleteStringQuienCreo < ActiveRecord::Migration
  def change
    remove_column :sales, :quien_cargo, :string

    add_reference :sales, :usuario, index: true
    add_foreign_key :sales, :usuario
  end
end
