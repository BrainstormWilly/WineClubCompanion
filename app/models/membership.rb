require 'elasticsearch/model'

class Membership < ActiveRecord::Base
	include Elasticsearch::Model
	include Elasticsearch::Model::Callbacks

  belongs_to :user
  belongs_to :club

  # def self.user_has_memberships(user)
  #   self.where(user:user).count > 0
  # end

  def self.not_in_club(club, user)
    return self.where(club:club, user:user).empty?
  end

  def as_indexed_json(options={})
    {
      "user_fullname" => user.fullname,
      "club_name" => club.name
    }
  end  

end

Membership.import force: true
