Rails.application.configure do
  # Configuration de Stripe avec les variables d'environnement
  config.stripe = {
    publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
    secret_key: ENV['STRIPE_SECRET_KEY']
  }
end

# Configuration globale de Stripe
Stripe.api_key = Rails.application.config.stripe[:secret_key]

# Vérification des clés en développement
if Rails.env.development?
  Rails.logger.info "🔑 Stripe configuré avec les clés : #{Rails.application.config.stripe[:publishable_key] ? 'PRÉSENTES' : 'MANQUANTES'}"
end
