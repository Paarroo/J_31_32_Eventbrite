# app/controllers/payments_controller.rb
class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event

  # GET /events/:event_id/payments/new
  def new
    @stripe_service = StripeService.new(current_user, @event)
    @stripe_session = @stripe_service.create_checkout_session

    # Redirection automatique vers Stripe
    redirect_to @stripe_session.url, allow_other_host: true

  rescue ArgumentError => e
    redirect_to @event, alert: e.message
  end

  # POST /events/:event_id/payments (pour compatibilité)
  def create
    redirect_to new_event_payment_path(@event)
  end

  # GET /events/:event_id/payments/success
  def success
    session_id = params[:session_id]

    if session_id.present?
      stripe_service = StripeService.new(current_user, @event)
      @payment_success = stripe_service.confirm_payment(session_id)

      if @payment_success
        flash.now[:notice] = "🎉 Paiement confirmé ! Vous participez maintenant à l'événement."
      else
        flash.now[:alert] = "❌ Problème lors de la confirmation du paiement."
      end
    else
      @payment_success = false
      flash.now[:alert] = "❌ Session de paiement introuvable."
    end
  end

  # GET /events/:event_id/payments/cancel
  def cancel
    flash.now[:alert] = "💳 Paiement annulé. Vous pouvez réessayer à tout moment."
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to events_path, alert: "❌ Événement introuvable."
  end
end
