class Admin::EventsController < Admin::ApplicationController
  before_action :set_event, only: [ :show, :edit, :update, :destroy ]

  def index
    @events = Event.includes(:user, :confirmed_attendances, :pending_attendances)
                  .order(created_at: :desc)

    # Filtres optionnels
    @events = @events.where(validated: params[:status]) if params[:status].present?
    @events = @events.where('title ILIKE ?', "%#{params[:search]}%") if params[:search].present?
  end

  def show
    # ✅ AMÉLIORÉ : Statistiques détaillées pour l'admin
    @confirmed_participants = @event.confirmed_participants.includes(:attendances)
    @pending_participants = @event.pending_participants.includes(:attendances)

    @stats = {
      total_attendances: @event.attendances.count,
      confirmed_count: @event.confirmed_participants_count,
      pending_count: @event.pending_participants_count,
      revenue: @event.total_revenue
    }
  end

  def edit
  end

  def update
    if @event.update(event_params)
      # Log de l'action admin
      Rails.logger.info "Admin #{current_user.email} a modifié l'événement #{@event.id}"

      redirect_to admin_event_path(@event), notice: 'Événement mis à jour avec succès.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    event_title = @event.title

    # Vérifier s'il y a des participants confirmés
    if @event.confirmed_participants_count > 0
      redirect_to admin_event_path(@event),
                  alert: "Impossible de supprimer un événement avec des participants confirmés."
      return
    end

    @event.destroy

    # Log de l'action admin
    Rails.logger.info "Admin #{current_user.email} a supprimé l'événement '#{event_title}'"

    redirect_to admin_events_path, notice: 'Événement supprimé avec succès.'
  end

  private

  def set_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_events_path, alert: "Événement introuvable."
  end

  def event_params
    params.require(:event).permit(
      :title, :description, :start_date, :duration, :price, :location,
      :validated, :admin_comment
    )
  end
end
