# app/controllers/events_controller.rb
class EventsController < ApplicationController
  before_action :authenticate_user!, except: [ :home, :index, :show ]
  before_action :set_event, only: [ :show, :edit, :update, :destroy, :participants ]

  # GET / (page d'accueil)
  def home
    @stats = {
      events_count: Event.validated.count,
      users_count: User.count,
      # ✅ CORRIGÉ : Utiliser le bon scope
      attendances_count: Attendance.where(payment_status: [ 'succeeded', 'free' ]).count
    }
  end

  # GET /events (liste des événements VALIDÉS seulement)
  def index
    @events = Event.validated
                  .upcoming
                  .includes(:user, :confirmed_attendances)
                  .order(:start_date)
  end

  # GET /events/:id
  def show
    # Vérifier que l'événement est validé (sauf pour le propriétaire et les admins)
    unless @event.validated? || @event.user == current_user || current_user&.admin?
      redirect_to events_path, alert: "Cet événement n'est pas encore validé."
      return
    end


    @confirmed_participants = @event.confirmed_participants
    @pending_participants = @event.pending_participants
    @user_attendance = current_user&.attendances&.find_by(event: @event)
  end

  # GET /events/new
  def new
    @event = current_user.events.build
  end

  # POST /events
  def create
    @event = current_user.events.build(event_params)

    if @event.save
      redirect_to @event, notice: 'Événement créé avec succès. Il sera visible après validation par un administrateur.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /events/:id/edit
  def edit
    # Seul le créateur peut modifier (avant validation)
    unless @event.user == current_user
      redirect_to @event, alert: "Vous ne pouvez pas modifier cet événement."
    end
  end

  # PATCH/PUT /events/:id
  def update
    unless @event.user == current_user
      redirect_to @event, alert: "Vous ne pouvez pas modifier cet événement."
      return
    end

    if @event.update(event_params)
      redirect_to @event, notice: 'Événement mis à jour avec succès.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /events/:id
  def destroy
    unless @event.user == current_user || current_user&.admin?
      redirect_to events_path, alert: "Vous ne pouvez pas supprimer cet événement."
      return
    end

    @event.destroy
    redirect_to events_path, notice: 'Événement supprimé avec succès.'
  end

  # GET /my_events
  def my_events
    @created_events = current_user.events.order(created_at: :desc)
    @attended_events = current_user.attendances
                                  .joins(:event)
                                  .where(payment_status: [ 'succeeded', 'free' ])
                                  .includes(:event)
                                  .order('events.start_date DESC')
  end

  # GET /events/:id/participants
  def participants
    # Seul l'organisateur et les admins peuvent voir la liste complète
    unless @event.user == current_user || current_user&.admin?
      redirect_to @event, alert: "Accès non autorisé."
      return
    end


    @confirmed_attendances = @event.confirmed_attendances.includes(:user)
    @pending_attendances = @event.pending_attendances.includes(:user)
  end

  private

  def set_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to events_path, alert: "Événement introuvable."
  end

  def event_params
    params.require(:event).permit(:title, :description, :start_date, :duration, :price, :location)
  end
end
