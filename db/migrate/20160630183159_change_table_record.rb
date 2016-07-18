class ChangeTableRecord < ActiveRecord::Migration
  def change
    remove_column :records, :cuenta_ml, :string

    add_reference :records, :cuenta_ml, index: true
    add_foreign_key :records, :cuenta_ml
  end
end
