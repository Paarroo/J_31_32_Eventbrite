# app/services/stripe_service.rb
class StripeService
  include Rails.application.routes.url_helpers

  # Erreurs personnalisées pour une meilleure gestion
  class StripeConfigurationError < StandardError; end
  class StripeSessionError < StandardError; end

  def initialize(user, event)
    @user = user
    @event = event
    validate_configuration!
  end

  # Méthode principale : créer une session de paiement Stripe
  def create_checkout_session
    validate_payment_eligibility!

    begin
      session = Stripe::Checkout::Session.create(
        payment_method_types: [ 'card' ],
        mode: 'payment',
        customer_email: @user.email,
        client_reference_id: "#{@user.id}-#{@event.id}",
        line_items: [ line_item ],
        metadata: metadata,
        success_url: success_url,
        cancel_url: cancel_url,
        expires_at: (Time.current + 30.minutes).to_i
      )

      # Créer l'enregistrement Payment en base
      create_payment_record(session)

      Rails.logger.info "✅ Session Stripe créée: #{session.id} pour #{@user.email}"
      session

    rescue Stripe::StripeError => e
      Rails.logger.error "❌ Erreur Stripe: #{e.message}"
      raise StripeSessionError, "Impossible de créer la session de paiement: #{e.message}"
    end
  end

  # Confirmer un paiement via session_id
  def confirm_payment(session_id)
    begin
      stripe_session = Stripe::Checkout::Session.retrieve(session_id)
      payment = Payment.find_by(stripe_checkout_session_id: session_id)

      return false unless payment && stripe_session.payment_status == 'paid'

      # Marquer le paiement comme réussi
      payment.mark_as_succeeded!

      # Envoyer email de confirmation (temporairement désactivé pour éviter l'erreur Solid Queue)
      # EventMailer.payment_confirmed(payment.attendance).deliver_later

      Rails.logger.info "✅ Paiement confirmé: #{session_id}"
      true

    rescue Stripe::StripeError => e
      Rails.logger.error "❌ Erreur confirmation: #{e.message}"
      false
    end
  end

  private

  def validate_configuration!
    unless Stripe.api_key.present?
      raise StripeConfigurationError, "Clés Stripe manquantes"
    end
  end

  def validate_payment_eligibility!
    if @event.user == @user
      raise ArgumentError, "Impossible de payer son propre événement"
    end

    if @event.participants.include?(@user)
      raise ArgumentError, "Déjà inscrit à cet événement"
    end

    unless @event.paid?
      raise ArgumentError, "Cet événement est gratuit"
    end
  end

  def line_item
    {
      price_data: {
        currency: 'eur',
        product_data: {
          name: @event.title,
          description: "Participation à l'événement: #{@event.title}",
          metadata: {
            event_id: @event.id.to_s,
            event_date: @event.start_date.strftime("%d/%m/%Y")
          }
        },
        unit_amount: @event.price_in_cents
      },
      quantity: 1
    }
  end

  def metadata
    {
      event_id: @event.id.to_s,
      user_id: @user.id.to_s,
      event_title: @event.title,
      event_price: @event.price.to_s,
      app_name: 'eventbrite'
    }
  end

  # ✅ CORRECTION: URLs simplifiées et fixes
  def success_url
    "#{base_url}/events/#{@event.id}/payments/success?session_id={CHECKOUT_SESSION_ID}"
  end

  def cancel_url
    "#{base_url}/events/#{@event.id}/payments/cancel"
  end

  def base_url
    if Rails.env.production?
      'https://localhost:3000'  # Remplace par ton domaine en production
    else
      'http://localhost:3000'
    end
  end

  def create_payment_record(stripe_session)
    Payment.create!(
      user: @user,
      event: @event,
      stripe_checkout_session_id: stripe_session.id,
      amount: @event.price_in_cents,
      currency: 'eur',
      status: 'pending',
      stripe_metadata: stripe_session.metadata.to_json
    )
  end
end
