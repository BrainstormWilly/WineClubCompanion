class Winery < ActiveRecord::Base

  has_many :clubs

  validates :name, length: { minimum: 1, maximum: 100 }, presence: true

end
