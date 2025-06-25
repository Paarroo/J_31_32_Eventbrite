module EventsHelper
  def format_event_price(event)
    if event.free?
      content_tag :span, "Gratuit", class: "tag is-success"
    else
      content_tag :span, "#{event.price}€", class: "tag is-primary"
    end
  end

  def event_can_be_purchased?(event, user)
    return false unless user
    return false if event.user == user
    return false if event.participants.include?(user)
    return false unless event.validated?
    event.paid?
  end

  def event_can_be_joined_free?(event, user)
    return false unless user
    return false if event.user == user
    return false if event.participants.include?(user)
    return false unless event.validated?
    event.free?
  end

  def participation_button(event, user)
    return login_required_button unless user

    if event.user == user
      owner_button
    elsif event.participants.include?(user)
      cancel_participation_button(event)
    elsif !event.validated?
      event_not_available_button
    elsif event.free?
      free_participation_button(event)
    else
      paid_participation_button(event)
    end
  end

  private

  def login_required_button
    content_tag :div, class: "notification is-warning is-light mb-4" do
      "Connectez-vous pour participer"
    end +
    link_to("Se connecter", new_user_session_path, class: "button is-primary is-fullwidth mb-2") +
    link_to("S'inscrire", new_user_registration_path, class: "button is-light is-fullwidth")
  end

  def owner_button
    content_tag :div, class: "notification is-info is-light" do
      content_tag(:span, class: "icon") { content_tag(:i, "", class: "fas fa-crown") } +
      content_tag(:span, "Vous êtes l'organisateur")
    end
  end

  def cancel_participation_button(event)
    content_tag :div, class: "notification is-success is-light mb-4" do
      content_tag(:span, class: "icon") { content_tag(:i, "", class: "fas fa-check-circle") } +
      content_tag(:span, "Vous êtes inscrit !")
    end +
    button_to("Annuler ma participation",
              event_attendances_path(event),
              method: :delete,
              class: "button is-danger is-fullwidth",
              data: { confirm: "Êtes-vous sûr de vouloir annuler votre participation ?" })
  end

  def event_not_available_button
    content_tag :div, class: "notification is-warning is-light" do
      "Cet événement n'est pas encore disponible"
    end
  end

  def free_participation_button(event)
    button_to("Participer gratuitement",
              event_attendances_path(event),
              class: "button is-success is-large is-fullwidth")
  end

  def paid_participation_button(event)
    link_to(new_event_payment_path(event), class: "button is-primary is-large is-fullwidth") do
      "Payer et participer - #{event.price}€"
    end +
    content_tag(:p, class: "help has-text-centered mt-2") do
      content_tag(:span, class: "icon") { content_tag(:i, "", class: "fas fa-shield-alt") } +
      content_tag(:span, "Paiement sécurisé par Stripe")
    end
  end
end
