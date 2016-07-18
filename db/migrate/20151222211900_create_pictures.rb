class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :ruta

      t.timestamps null: false

      t.references :copy
    end
  end
end
