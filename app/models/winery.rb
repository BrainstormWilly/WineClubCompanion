class Winery < ActiveRecord::Base

  # default_scope { order('name ASC') }

  has_many :clubs
  has_one :account

  validates :name, length: { minimum: 1, maximum: 100 }, presence: true

  def fulladdress
    s = "#{self.address1}<br/>"
    if self.address2
      s << "#{self.address2}<br/>"
    end
    s << "#{self.city}, #{self.state} #{self.zip}"
    s.html_safe
  end

end
