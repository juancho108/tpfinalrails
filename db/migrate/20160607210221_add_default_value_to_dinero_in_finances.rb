class AddDefaultValueToDineroInFinances < ActiveRecord::Migration
  def change
    remove_column :finances, :dinero, :float
  
    add_column :finances, :dinero, :float, default: 0
  end
end
