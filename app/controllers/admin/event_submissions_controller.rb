class Admin::EventSubmissionsController < Admin::ApplicationController
  before_action :set_event, only: [ :show, :edit, :update ]

  def index
    # ✅ CORRIGÉ : Sans pagination Kaminari
    @pending_events = Event.pending
                          .includes(:user)
                          .order(created_at: :asc)
                          .limit(50) # Limite simple sans gem
  end

  def show
    # Affichage détaillé de l'événement à valider
  end

  def edit
    # Formulaire de validation avec commentaire
  end

  def update
    # Validation des paramètres obligatoires
    unless validate_decision_params
      return
    end

    decision = params[:event][:validated] == 'true'
    comment = params[:event][:admin_comment]

    begin
      # Transaction pour assurer la cohérence
      ActiveRecord::Base.transaction do
        # Mise à jour de l'événement
        @event.update!(
          validated: decision,
          admin_comment: comment,
          validated_by: current_user,
          validated_at: Time.current
        )

        # ✅ CORRIGÉ : Vérifier si AdminMailer existe avant d'envoyer
        if defined?(AdminMailer)
          AdminMailer.event_validation_result(@event, decision, comment).deliver_now
        end
      end

      # Log de l'action admin
      status = decision ? "validé" : "refusé"
      Rails.logger.info "Admin #{current_user.email} a #{status} l'événement #{@event.id}"

      redirect_to admin_event_submissions_path,
                  notice: "Événement #{status} avec succès."

    rescue ActiveRecord::RecordInvalid => e
      redirect_to edit_admin_event_submission_path(@event),
                  alert: "Validation échouée: #{e.record.errors.full_messages.join(', ')}"
    rescue StandardError => e
      Rails.logger.error "Erreur validation événement #{@event.id}: #{e.message}"
      redirect_to admin_event_submissions_path,
                  alert: "Une erreur est survenue lors de la validation."
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_event_submissions_path,
                alert: "Événement introuvable."
  end

  def validate_decision_params
    unless params[:event]&.[](:validated).in?([ 'true', 'false' ])
      redirect_to edit_admin_event_submission_path(@event),
                  alert: "Veuillez sélectionner une décision."
      return false
    end
    true
  end
end
