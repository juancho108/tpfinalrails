class ChangeTypeOfStateInSales < ActiveRecord::Migration
  def change
  	change_column :sales, :estado, :integer
  end
end
