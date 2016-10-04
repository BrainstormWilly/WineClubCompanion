class Winery < ActiveRecord::Base

  default_scope { order('name ASC') }

  has_many :clubs

  validates :name, length: { minimum: 1, maximum: 100 }, presence: true


end
