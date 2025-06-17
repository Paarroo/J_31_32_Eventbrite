# app/controllers/events_controller.rb
class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: [ :index, :show, :home ]
  before_action :check_owner, only: [ :edit, :update, :destroy ]

  # GET / (page d'accueil)
  def home
    # Rien à charger pour la page d'accueil, juste les stats
  end

  # GET /events (liste des événements)
  def index
    if params[:user_id]
      # Si on veut voir les événements d'un utilisateur spécifique
      @user = User.find(params[:user_id])
      @events = @user.events.includes(:user, :participants).order(start_date: :asc)
      @title = "Événements de #{@user.first_name}"
    else
      # Tous les événements
      @events = Event.includes(:user, :participants).order(start_date: :asc)
      @title = "Tous les événements"
    end
  end

  # GET /my_events
  def my_events
    @events = current_user.events.includes(:user, :participants).order(start_date: :asc)
    @title = "Mes événements"
    @user = current_user
    render :index
  end

  # GET /events/1
  def show
    @attendance = Attendance.new
    @is_participant = user_signed_in? && @event.participants.include?(current_user)
    @is_owner = user_signed_in? && @event.user == current_user
  end

  # GET /events/new
  def new
    @event = current_user.events.build
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @event = current_user.events.build(event_params)

    if @event.save
      redirect_to @event, notice: 'Événement créé avec succès !'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Événement mis à jour avec succès !'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    redirect_to events_url, notice: 'Événement supprimé avec succès !'
  end

  # GET /events/1/participants (pour le propriétaire de l'événement)
  def participants
    unless @event.user == current_user
      redirect_to @event, alert: "Accès non autorisé."
      return
    end

    @participants = @event.participants.includes(:attendances)
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def check_owner
    unless @event.user == current_user
      redirect_to events_path, alert: "Vous n'êtes pas autorisé à modifier cet événement."
    end
  end

  def event_params
    params.require(:event).permit(:title, :description, :start_date, :duration, :price, :location)
  end
end
