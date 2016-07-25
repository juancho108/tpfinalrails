class CreateConfigurations < ActiveRecord::Migration
  def change
    create_table :configurations do |t|
      t.string :dolar_libre
      t.string :dolar_blue

      t.timestamps null: false
    end
  end
end
