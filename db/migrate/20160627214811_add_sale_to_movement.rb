class AddSaleToMovement < ActiveRecord::Migration
  def change
    add_reference :movements, :sale, index: true
    add_foreign_key :movements, :sale
  end
end
