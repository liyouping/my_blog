class UserMailer < ApplicationMailer

  def send_msg_to_me(contact)
    @contact = contact
    mail(to: Settings.email.receive_email, subject: "留言通知")
  end
end
