class ConferencePackage < ActiveRecord::Base
  default_scope order('conference_id desc, price desc')

  belongs_to :conference
  belongs_to :rate
  attr_accessible :price, :rate_id, :conference_id

  validates :rate_id, :uniqueness => { scope: :conference_id, message: "already has a package for this conference" }
  validates :price, presence: true, numericality: true
end

