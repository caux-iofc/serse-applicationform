class Rate < ActiveRecord::Base
  validates :name, :uniqueness => true
  validates :name, :presence => true

  validates :from_age, :numericality => true
  validates :to_age, :numericality => true
  validates :from_age, :numericality => { :less_than_or_equal_to => :to_age, :message => " must be less than or equal to 'To age'" }

  default_scope order('daily_chf')

end
