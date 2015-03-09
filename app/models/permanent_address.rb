class PermanentAddress < Address
  default_scope where(:kind => :permanent)

  before_create :set_as_permanent
  before_save :set_as_permanent

  protected

  def set_as_permanent
    self.kind = :permanent
  end

end

