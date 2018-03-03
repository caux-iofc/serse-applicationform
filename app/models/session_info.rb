module SessionInfo
  def request
    Thread.current[:request]
  end

  def self.request=(request)
    Thread.current[:request] = request
  end
end
