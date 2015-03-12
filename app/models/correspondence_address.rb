class CorrespondenceAddress < Address
  default_scope where(:kind => :correspondence)

  before_create :set_as_correspondence
  before_save :set_as_correspondence

  # There appears to be no way to pass two different :date conditions with a unique message for each
  # in one validates statement. So we make sure to put each :date condition in a separate validates statement.
  validates :valid_from, :presence => true, :if => :contact?
  validates :valid_from, :date => { :before_or_equal_to => :valid_until, :message => I18n.t(:must_be_before_valid_until) },
                      :if => lambda { |a| contact? && a.valid_until }
  validates :valid_from, :date => { :before_or_equal_to => Date.today, :message => I18n.t(:must_be_valid_now) },
                      :if => lambda { |a| contact? && a.valid_from }

  validates :valid_until, :presence => true, :if => :contact?
  validates :valid_until, :date => { :after_or_equal_to => :valid_from, :message => I18n.t(:must_be_after_valid_from) },
                          :if => lambda { |a| contact? && a.valid_from && a.valid_until }
  validates :valid_until, :date => { :after_or_equal_to => Date.today + 6.weeks, :message => I18n.t(:must_be_at_least_6_weeks_in_the_future) },
                          :if => lambda { |a| contact? && a.valid_until }

 protected

 def set_as_correspondence
   self.kind = :correspondence
 end

end

