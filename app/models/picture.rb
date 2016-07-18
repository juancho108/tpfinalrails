class Picture < ActiveRecord::Base
  belongs_to :copia, :class_name => 'Copy', :foreign_key => 'copy_id'
end
