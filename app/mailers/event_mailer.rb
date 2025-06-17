class EventMailer < ApplicationMailer
  default from: 'noreply@eventbrite-app.com'

  def new_participant_email(attendance)
    @user = attendance.user
    @event = attendance.event
    @event_creator = @event.user

    mail(to: @event_creator.email,
         subject: "Nouvelle inscription à votre événement : #{@event.title}")
  end
end
