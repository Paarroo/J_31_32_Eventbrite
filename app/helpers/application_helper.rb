module ApplicationHelper
  def stripe_publishable_key
    Rails.application.config.stripe[:publishable_key]
  end

  def format_stripe_amount(amount_in_cents)
    (amount_in_cents / 100.0).round(2)
  end

  def euros_to_cents(euros)
    (euros * 100).to_i
  end


  def event_status_badge(event)
    if event.validated?
      content_tag :span, "Validé", class: "tag is-success"
    elsif event.rejected?
      content_tag :span, "Refusé", class: "tag is-danger"
    else
      content_tag :span, "En attente", class: "tag is-warning"
    end
  end


  def admin_user?
    user_signed_in? && current_user.admin?
  end


  def french_date(date)
    date&.strftime("%d/%m/%Y")
  end

  def french_datetime(datetime)
    datetime&.strftime("%d/%m/%Y à %H:%M")
  end


  def format_revenue(cents)
    "#{(cents / 100.0).round(2)}€"
  end


  def user_avatar(user, size = 48)
    content_tag :span,
      user.first_name&.first&.upcase || "U",
      class: "has-background-primary has-text-white is-flex is-align-items-center is-justify-content-center",
      style: "width: #{size}px; height: #{size}px; border-radius: 50%; font-size: #{size/3}px; font-weight: bold;"
  end
end
