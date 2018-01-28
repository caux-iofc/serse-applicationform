class ConferencePackage < ActiveRecord::Base
  acts_as_paranoid_versioned :version_column => :lock_version
  default_scope { order('conference_id desc, price desc') }

  belongs_to :conference
  belongs_to :rate
  attr_accessible :price, :rate_id, :conference_id

  # A fake attribute that we use to tell the form that early bird pricing is in effect
  # when it asks for the json encoded package pricing list.
  attr_accessor :early_bird_pricing, :early_bird_discount

  validates :rate_id, :uniqueness => { scope: :conference_id, message: "already has a package for this conference" }
  validates :price, presence: true, numericality: true
end

