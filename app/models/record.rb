class Record < ActiveRecord::Base
  enum state: [:publicado, :pausado, :finalizado]
  #validations
  belongs_to :producto, :class_name => 'Product', :foreign_key => 'product_id'
  belongs_to :cuenta_ml, :class_name => 'OriginSale', :foreign_key => 'cuenta_ml_id'
end
