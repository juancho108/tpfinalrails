class Product < ActiveRecord::Base
  #associations
  belongs_to :categoria, :class_name => 'Category', :foreign_key => 'category_id'
  has_many :copias, :class_name => 'Copy'
  has_many :registros, :class_name => 'Record'
  
  #validations
  validates :nombre, presence: true
end
