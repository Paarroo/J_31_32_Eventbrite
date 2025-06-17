class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: [ :show, :edit, :update, :destroy ]
  before_action :check_user_authorization, only: [ :edit, :update, :destroy ]

  # GET /users or /users.json
  def index
    @users = User.includes(:events, :attendances).all
  end

  # GET /users/1 or /users/1.json
  def show
    # Pour la page de profil, on récupère les événements créés et les participations
    @user_events = @user.events.includes(:participants).order(start_date: :desc)
    @user_attendances = @user.attendances.includes(:event).order(created_at: :desc)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    # Seul le propriétaire du profil peut l'éditer
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "Utilisateur créé avec succès." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "Profil mis à jour avec succès." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, status: :see_other, notice: "Utilisateur supprimé avec succès." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Vérification que l'utilisateur connecté est bien le propriétaire du profil
  def check_user_authorization
    unless current_user == @user
      redirect_to root_path, alert: "Vous n'êtes pas autorisé à accéder à cette page."
    end
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:first_name, :last_name, :description, :email)
  end
end
