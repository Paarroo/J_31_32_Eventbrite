class AdminMailer < ApplicationMailer
  default from: 'admin@eventbrite.local'

  def event_validation_result(event, validated, comment = nil)
    @event = event
    @user = event.user
    @validated = validated
    @comment = comment
    @admin = event.validated_by

    subject = validated ? "✅ Votre événement a été validé" : "❌ Votre événement a été refusé"

    mail(
      to: @user.email,
      subject: subject
    )
  end

  def new_user_notification(user)
    @user = user
    @admin_emails = Rails.application.config.admin_emails

    mail(
      to: @admin_emails,
      subject: "Nouvel utilisateur inscrit: #{@user.full_name}"
    )
  end
end
