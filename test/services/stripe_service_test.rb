require 'test_helper'

class StripeServiceTest < ActiveSupport::TestCase
  def setup
    @user = users(:marie)
    @event = events(:cooking_workshop)
    @service = StripeService.new(@user, @event)
  end

  test "should create checkout session for valid payment" do
    VCR.use_cassette("stripe_create_session") do
      session = @service.create_checkout_session

      assert_not_nil session
      assert_equal 'checkout.session', session.object
      assert_equal @event.price_in_cents, session.amount_total
    end
  end

  test "should raise error for own event" do
    service = StripeService.new(@event.user, @event)

    assert_raises(ArgumentError) do
      service.create_checkout_session
    end
  end

  test "should create payment record" do
    VCR.use_cassette("stripe_create_session_with_payment") do
      assert_difference 'Payment.count', 1 do
        @service.create_checkout_session
      end

      payment = Payment.last
      assert_equal @user, payment.user
      assert_equal @event, payment.event
      assert_equal 'pending', payment.status
    end
  end
end
