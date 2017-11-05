class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def has attribute
  	not attribute.nil?
  end
end
