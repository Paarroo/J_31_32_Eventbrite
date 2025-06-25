class PaymentService
  def initialize(user, event)
    @user = user
    @event = event
  end

  def create_stripe_session
    # Logique Stripe ici
  end
end
