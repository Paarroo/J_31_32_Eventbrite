class UserMailer < ApplicationMailer
  default from: ENV.fetch('MAILER_FROM') do
    case Rails.env
    when 'production'
      'noreply@eventbrite.fr'
    when 'staging'
      'staging@eventbrite.fr'
    else
      'dev@eventbrite.local'
    end
  end

  # Reply-to adaptatif
  default reply_to: ENV.fetch('MAILER_REPLY_TO') do
    case Rails.env
    when 'production'
      'support@eventbrite.fr'
    else
      'dev-support@eventbrite.local'
    end
  end

  def welcome_email(user)
    @user = user
    @app_name = app_name
    @login_url = new_user_session_url
    @support_email = support_email

    mail(
      to: @user.email,
      subject: "Bienvenue sur #{@app_name} ! 🎉"
    )
  end

  private

  # Helper pour URLs adaptatives (utilise la config Rails)
  def base_url
    Rails.application.routes.url_helpers.root_url
  end

  # Helper pour nom de l'app selon l'environnement
  def app_name
    base_name = "Eventbrite"
    case Rails.env
    when 'production'
      base_name
    when 'staging'
      "#{base_name} (Staging)"
    else
      "#{base_name} (Dev)"
    end
  end

  # Helper pour email de support
  def support_email
    ENV.fetch('SUPPORT_EMAIL') do
      case Rails.env
      when 'production'
        'support@eventbrite.fr'
      else
        'dev-support@eventbrite.local'
      end
    end
  end
end
