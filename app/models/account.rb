require 'elasticsearch/model'

class Account < ApplicationRecord
  include Elasticsearch::Model
	include Elasticsearch::Model::Callbacks

  # default_scope { order('winery ASC') }

  belongs_to :user
  belongs_to :winery

  def self.has_account?( user, winery )
    return self.where( user: user, winery: winery ).count > 0
  end

  def as_indexed_json(options={})
    {
      "user_fullname" => user.fullname,
      "winery_name" => winery.name,
      "clubs_list" => winery.clubs.map{ |c| c.name }.join(", ")
    }
  end

end

Account.import force: true
