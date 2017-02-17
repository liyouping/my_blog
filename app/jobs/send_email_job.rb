class SendEmailJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    sleep 10
    100.times do |index|
      pp index
    end
    #UserMailer.welcome_email.deliver_now
  end
end
