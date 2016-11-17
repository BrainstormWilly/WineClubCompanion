require 'elasticsearch/model'

class Club < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :winery
  has_many :memberships, dependent: :destroy

  validates :name, length: { minimum: 1, maximum: 100 }, presence: true


end

Club.import force: true
