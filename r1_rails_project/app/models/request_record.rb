class RequestRecord < ActiveRecord::Base
  validates_uniqueness_of "uuid"

end