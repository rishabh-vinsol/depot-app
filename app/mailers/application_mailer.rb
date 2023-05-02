class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"

  before_action :attach_headers

  def attach_headers
    headers['X-SYSTEM-PROCESS-ID'] = Process.pid
  end
end
