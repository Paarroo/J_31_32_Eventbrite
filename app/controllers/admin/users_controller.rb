class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: [ :show, :edit, :update, :destroy, :toggle_admin ]

  def index
    @users = User.includes(:events, :attendances).order(created_at: :desc)
  end

  def show
    @user_events = @user.events.order(created_at: :desc)
    @user_attendances = @user.attendances.includes(:event).order(created_at: :desc)
  end

  def edit
    # ✅ CORRIGÉ : Admin peut modifier n'importe quel utilisateur
    # Pas de restriction ici pour l'admin
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: 'Utilisateur mis à jour avec succès.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user == current_user
      redirect_to admin_users_path, alert: "Vous ne pouvez pas supprimer votre propre compte."
      return
    end

    @user.destroy
    redirect_to admin_users_path, notice: 'Utilisateur supprimé avec succès.'
  end

  def toggle_admin
    if @user == current_user
      redirect_to admin_users_path, alert: "Vous ne pouvez pas modifier vos propres droits admin."
      return
    end

    @user.update!(admin: !@user.admin?)
    status = @user.admin? ? "promu administrateur" : "retiré des administrateurs"
    redirect_to admin_user_path(@user), notice: "Utilisateur #{status} avec succès."
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_users_path, alert: "Utilisateur introuvable."
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :description, :email, :admin)
  end
end
