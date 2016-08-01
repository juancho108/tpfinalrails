class RenameConfigurationTableToOptionsTable < ActiveRecord::Migration
  def change
    rename_table :configurations, :options
  end
end
