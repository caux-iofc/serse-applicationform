class PermanentAddress < Address
  default_scope { where(:kind => :permanent) }

  belongs_to :online_application, :inverse_of => :permanent_address

  before_create :set_as_permanent
  before_save :set_as_permanent

  protected

  def set_as_permanent
    self.kind = :permanent
  end

end

