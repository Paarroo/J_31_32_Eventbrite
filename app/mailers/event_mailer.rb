class EventMailer < ApplicationMailer
  default from: 'events@eventbrite.local'

  def new_participant_email(attendance)
    @user = attendance.user
    @event = attendance.event
    @event_creator = @event.user
    @attendance = attendance

    mail(
      to: @event_creator.email,
      subject: "Nouvelle inscription à votre événement : #{@event.title}"
    )
  end

  def payment_confirmed(attendance)
    @user = attendance.user
    @event = attendance.event
    @attendance = attendance

    mail(
      to: @user.email,
      subject: "Confirmation de paiement pour #{@event.title}"
    )
  end

  def event_reminder(attendance)
    @user = attendance.user
    @event = attendance.event
    @attendance = attendance

    mail(
      to: @user.email,
      subject: "Rappel: #{@event.title} commence bientôt !"
    )
  end
end
