namespace :stripe do
  desc "Vérifier la configuration Stripe"
  task check: :environment do
    puts "🔍 Vérification de la configuration Stripe..."

    if ENV['STRIPE_SECRET_KEY'].present?
      puts "✅ STRIPE_SECRET_KEY: configurée"
      puts "   Type: #{ENV['STRIPE_SECRET_KEY'].start_with?('sk_test') ? 'TEST' : 'LIVE'}"
    else
      puts "❌ STRIPE_SECRET_KEY: manquante"
    end

    if ENV['STRIPE_PUBLISHABLE_KEY'].present?
      puts "✅ STRIPE_PUBLISHABLE_KEY: configurée"
      puts "   Type: #{ENV['STRIPE_PUBLISHABLE_KEY'].start_with?('pk_test') ? 'TEST' : 'LIVE'}"
    else
      puts "❌ STRIPE_PUBLISHABLE_KEY: manquante"
    end

    # Test de connexion Stripe
    if Stripe.api_key.present?
      begin
        account = Stripe::Account.retrieve
        puts "✅ Connexion Stripe réussie"
        puts "   Compte: #{account.id}"
        puts "   Email: #{account.email}"
        puts "   Pays: #{account.country}"
      rescue Stripe::StripeError => e
        puts "❌ Erreur de connexion Stripe: #{e.message}"
      end
    else
      puts "❌ Impossible de tester: clé API manquante"
    end
  end

  desc "Synchroniser les paiements avec Stripe"
  task sync_payments: :environment do
    pending_payments = Payment.where(status: 'pending')

    puts "🔄 Synchronisation de #{pending_payments.count} paiement(s) en attente..."

    pending_payments.each do |payment|
      begin
        session = Stripe::Checkout::Session.retrieve(payment.stripe_checkout_session_id)

        if session.payment_status == 'paid'
          payment.mark_as_succeeded!
          puts "✅ Paiement #{payment.id} confirmé"
        elsif session.status == 'expired'
          payment.mark_as_failed!
          puts "⏰ Paiement #{payment.id} expiré"
        end

      rescue Stripe::StripeError => e
        puts "❌ Erreur pour paiement #{payment.id}: #{e.message}"
      end
    end

    puts "🎉 Synchronisation terminée"
  end
end
