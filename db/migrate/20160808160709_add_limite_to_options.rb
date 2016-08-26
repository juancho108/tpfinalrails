class AddLimiteToOptions < ActiveRecord::Migration
  def change
    add_column :options, :limite, :float, default: 20000
  end
end
