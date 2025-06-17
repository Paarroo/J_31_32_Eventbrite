class UserMailer < ApplicationMailer
  default from: 'noreply@eventbrite-app.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Bienvenue sur Eventbrite !')
  end
end
