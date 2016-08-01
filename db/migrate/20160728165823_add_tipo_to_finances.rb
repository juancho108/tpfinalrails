class AddTipoToFinances < ActiveRecord::Migration
  def change
    add_column :finances, :tipo_mp, :boolean
  end
end
