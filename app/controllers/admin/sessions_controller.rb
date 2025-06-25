class Admin::SessionsController < Admin::ApplicationController
  # On autorise l'accès aux pages de connexion sans être admin
  skip_before_action :ensure_admin!, only: [ :new, :create ]

  # Affichage du formulaire de connexion admin
  def new
    # Si l'utilisateur est déjà connecté ET admin, on le redirige
    if user_signed_in? && current_user.admin?
      redirect_to admin_root_path
      return
    end
  end

  # Traitement de la connexion
  def create
    # On cherche l'utilisateur par email avec la méthode Devise
    user = User.find_for_database_authentication(email: params[:email])

    # Vérification du mot de passe ET des droits admin
    if user && user.valid_password?(params[:password])
      if user.admin?
        # Connexion réussie pour un admin
        sign_in(user)
        Rails.logger.info "Connexion admin réussie: #{user.email}"
        redirect_to admin_root_path, notice: "Bienvenue #{user.full_name} !"
      else
        # Utilisateur valide mais pas admin
        Rails.logger.warn "Tentative d'accès admin non autorisée: #{user.email}"
        flash.now[:alert] = "Accès non autorisé. Seuls les administrateurs peuvent accéder à cette zone."
        render :new, status: :unprocessable_entity
      end
    else
      # Email ou mot de passe incorrect
      Rails.logger.warn "Tentative de connexion admin échouée: #{params[:email]}"
      flash.now[:alert] = "Email ou mot de passe incorrect."
      render :new, status: :unprocessable_entity
    end
  end

  # Déconnexion
  def destroy
    Rails.logger.info "Déconnexion admin: #{current_user.email}"
    sign_out(current_user)
    redirect_to root_path, notice: "Déconnexion réussie."
  end
end
