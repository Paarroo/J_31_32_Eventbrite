# Service pour la logique admin
class AdminService
  def self.validate_event!(event, admin, decision, comment = nil)
    ActiveRecord::Base.transaction do
      event.update!(
        validated: decision,
        reviewed: true,
        admin_comment: comment,
        validated_at: Time.current,
        validated_by_id: admin.id
      )

      # Envoyer un email à l'organisateur
      AdminMailer.event_validation_result(event, decision, comment).deliver_later

      Rails.logger.info "✅ Événement #{event.id} #{decision ? 'validé' : 'refusé'} par admin #{admin.id}"
    end
  end

  def self.pending_events
    Event.where(reviewed: false)
  end

  def self.stats
    {
      total_users: User.count,
      total_events: Event.count,
      validated_events: Event.where(validated: true).count,
      pending_events: Event.where(reviewed: false).count,
      total_payments: Payment.succeeded.count,
      total_revenue: Payment.succeeded.sum(:amount) / 100.0
    }
  end
end
