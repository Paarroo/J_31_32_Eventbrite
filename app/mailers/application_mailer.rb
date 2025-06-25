class ApplicationMailer < ActionMailer::Base
  # Configuration globale pour tous les mailers
  layout 'mailer'

  # Adresse d'envoi par défaut (sera écrasée dans chaque environnement)
  default from: 'no-reply@eventbrite.fr'

  private

  # Méthode helper pour adapter les URLs selon l'environnement
  def base_url
    if Rails.env.production?
      'https://monsite.herokuapp.com'
    elsif Rails.env.staging?  # Si vous avez un environnement de staging
      'https://staging-monsite.herokuapp.com'
    else
      'http://localhost:3000'
    end
  end
end
