# config/application.rb
require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module J3132Eventbrite
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration Stripe
    config.stripe = {
      publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
      secret_key: ENV['STRIPE_SECRET_KEY']
    }

    # Configuration pour les admins
    config.admin_emails = ENV['ADMIN_EMAILS']&.split(',') || [ 'admin@eventbrite.local' ]

    # Configuration des emails
    config.action_mailer.default_url_options = {
      host: ENV['APP_HOST'] || 'localhost:3000',
      protocol: Rails.env.production? ? 'https' : 'http'
    }

    # Configuration pour l'internationalisation
    config.i18n.default_locale = :fr
    config.i18n.available_locales = [ :fr, :en ]

    if Rails.env.development?
      config.active_job.queue_adapter = :async
    elsif Rails.env.production?
      config.active_job.queue_adapter = :solid_queue
    else
      config.active_job.queue_adapter = :test
    end

    # Configuration de sécurité
    config.force_ssl = Rails.env.production?

    # Configuration des logs
    if Rails.env.development?
      config.log_level = :debug
    elsif Rails.env.production?
      config.log_level = :info
    end
  end
end
