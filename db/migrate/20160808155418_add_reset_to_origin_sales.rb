class AddResetToOriginSales < ActiveRecord::Migration
  def change
    add_column :origin_sales, :reset, :integer, default: 0
  end
end
