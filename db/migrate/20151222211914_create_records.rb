class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :cuenta_ml
      t.string :estado
      t.integer :orden

      t.timestamps null: false

      t.references :copy
      t.references :product
    end
  end
end
