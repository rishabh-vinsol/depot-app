class ExceptFirefox
  def self.matches?(request)
    debugger
    request.user_agent =~ /Firefox/
  end
end
