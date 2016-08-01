class AddSkinToOptions < ActiveRecord::Migration
  def change
    add_column :options, :skin, :string, default: "blue"
  end
end
