class CreateFinances < ActiveRecord::Migration
  def change
    create_table :finances do |t|
      t.string :nombre
      t.float :dinero

      t.timestamps null: false
    end
  end
end
