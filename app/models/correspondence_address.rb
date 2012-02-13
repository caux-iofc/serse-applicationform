class CorrespondenceAddress < Address

  # There appears to be no way to pass two different :date conditions with a unique message for each
  # in one validates statement. So we make sure to put each :date condition in a separate validates statement.
  validates :valid_from, :presence => true,
                      :date => { :before_or_equal_to => :valid_until, :message => I18n.t(:must_be_before_valid_until) }, 
                      :if => :valid_until
  validates :valid_until, :presence => true
  validates :valid_until, :date => { :after_or_equal_to => :valid_from, :message => I18n.t(:must_be_after_valid_from) },
                        :if => "valid_from and valid_until"
  validates :valid_until, :date => { :after_or_equal_to => Date.today + 6.weeks, :message => I18n.t(:must_be_at_least_6_weeks_in_the_future) }, :if => :valid_until

end

