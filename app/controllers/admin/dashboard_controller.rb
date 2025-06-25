class Admin::DashboardController < Admin::ApplicationController
  def index
    # Calcul des statistiques en temps réel
    @stats = calculate_dashboard_stats

    # Données récentes pour l'affichage
    @recent_events = Event.includes(:user)
                         .order(created_at: :desc)
                         .limit(5)

    @recent_users = User.order(created_at: :desc).limit(5)

    @pending_events = Event.pending
                          .includes(:user)
                          .order(created_at: :asc)
                          .limit(10)
  end

  private

  def calculate_dashboard_stats
    {
      total_users: User.count,
      total_events: Event.count,
      validated_events: Event.validated.count,
      pending_events: Event.pending.count,
      # Si vous n'avez pas encore le modèle Payment, mettez 0
      total_revenue: 0, # Payment.succeeded.sum(:amount) || 0,
      total_payments: 0  # Payment.succeeded.count || 0
    }
  rescue => e
    Rails.logger.error "Erreur calcul stats dashboard: #{e.message}"
    # Stats par défaut en cas d'erreur
    {
      total_users: 0,
      total_events: 0,
      validated_events: 0,
      pending_events: 0,
      total_revenue: 0,
      total_payments: 0
    }
  end
end
