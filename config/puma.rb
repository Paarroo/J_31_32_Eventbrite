# config/puma.rb

# ===============================================
# CONFIGURATION DE BASE PUMA
# ===============================================

max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"
port ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "development" }
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# ===============================================
# CONFIGURATION FLEXIBLE DÉVELOPPEMENT
# ===============================================

if ENV.fetch("RAILS_ENV", "development") == "development"

  # Variables d'environnement pour cohérence avec development.rb
  use_ssl = ENV['USE_SSL'] == 'true'
  use_real_smtp = ENV['USE_REAL_SMTP'] == 'true'

  puts "🚀 Puma - Configuration flexible"
  puts "🔒 SSL: #{use_ssl ? 'Activé' : 'Désactivé'}"
  puts "📧 SMTP: #{use_real_smtp ? 'Réel' : 'Letter Opener'}"

  if use_ssl
    # ===============================================
    # MODE HTTPS (si USE_SSL=true)
    # ===============================================

    ssl_configured = false

    begin
      # Essayer d'abord la gem localhost
      require 'localhost'

      # Chemins des certificats localhost
      localhost_dir = File.expand_path('~/.localhost')
      key_path = File.join(localhost_dir, 'localhost.key')
      cert_path = File.join(localhost_dir, 'localhost.crt')

      # Créer certificats si nécessaire
      unless File.exist?(key_path) && File.exist?(cert_path)
        require 'fileutils'
        FileUtils.mkdir_p(localhost_dir)

        puts "🔧 Génération des certificats SSL..."

        # Commandes avec guillemets pour gérer les espaces dans les chemins
        key_cmd = %{openssl genrsa -out "#{key_path}" 2048}
        cert_cmd = %{openssl req -new -x509 -key "#{key_path}" -out "#{cert_path}" -days 365 -subj "/CN=localhost"}

        key_result = system(key_cmd)
        cert_result = system(cert_cmd) if key_result

        if key_result && cert_result
          puts "✅ Certificats SSL créés avec succès"
        else
          puts "⚠️  Problème lors de la création des certificats"
        end
      end

      # Vérifier que les certificats existent
      if File.exist?(key_path) && File.exist?(cert_path)
        # Configuration SSL avec gem localhost
        ssl_bind '0.0.0.0', '3000', {
          key: key_path,
          cert: cert_path,
          verify_mode: 'none'
        }

        ssl_configured = true

        puts ""
        puts "🔒 " + "HTTPS activé avec gem localhost".colorize(:green) rescue puts "🔒 HTTPS activé avec gem localhost"
        puts "🌐 " + "Accédez à : https://localhost:3000".colorize(:cyan) rescue puts "🌐 Accédez à : https://localhost:3000"
        puts "📁 " + "Certificats: #{cert_path}".colorize(:yellow) rescue puts "📁 Certificats: #{cert_path}"
        puts ""
      end

    rescue LoadError
      # Gem localhost non disponible - essayer certificats manuels
      puts "⚠️  Gem 'localhost' non disponible"
      puts "🔧 Tentative avec certificats manuels..."

      # Certificats dans config/ssl
      ssl_dir = Rails.root.join('config', 'ssl')
      require 'fileutils'
      FileUtils.mkdir_p(ssl_dir, mode: 0755) unless Dir.exist?(ssl_dir)

      key_path = ssl_dir.join('localhost.key')
      cert_path = ssl_dir.join('localhost.crt')

      # Générer certificats manuels si nécessaire
      unless File.exist?(key_path) && File.exist?(cert_path)
        puts "🔑 Génération certificats manuels..."

        key_cmd = %{openssl genrsa -out "#{key_path}" 2048}
        cert_cmd = %{openssl req -new -x509 -key "#{key_path}" -out "#{cert_path}" -days 365 -subj "/C=FR/ST=Auvergne/L=Clermont-Ferrand/O=Eventbrite/OU=Dev/CN=localhost"}

        key_result = system(key_cmd)
        cert_result = system(cert_cmd) if key_result

        if key_result && cert_result
          puts "✅ Certificats manuels créés"
        else
          puts "❌ Erreur création certificats manuels"
        end
      end

      # Configuration SSL avec certificats manuels
      if File.exist?(key_path) && File.exist?(cert_path)
        ssl_bind '0.0.0.0', '3000', {
          key: key_path.to_s,
          cert: cert_path.to_s,
          verify_mode: 'none'
        }

        ssl_configured = true

        puts ""
        puts "🔒 " + "HTTPS activé avec certificats manuels".colorize(:green) rescue puts "🔒 HTTPS activé avec certificats manuels"
        puts "🌐 " + "Accédez à : https://localhost:3000".colorize(:cyan) rescue puts "🌐 Accédez à : https://localhost:3000"
        puts "📁 " + "Certificats: config/ssl/".colorize(:yellow) rescue puts "📁 Certificats: config/ssl/"
        puts ""
      end

    rescue StandardError => e
      # Autres erreurs SSL
      puts "❌ Erreur SSL: #{e.message}"
    end

    # Fallback vers HTTP si SSL n'a pas pu être configuré
    unless ssl_configured
      puts "🌐 Fallback vers HTTP : http://localhost:3000"
      bind "tcp://0.0.0.0:3000"
    end

  else
    # ===============================================
    # MODE HTTP PAR DÉFAUT (si USE_SSL=false ou non défini)
    # ===============================================

    bind "tcp://0.0.0.0:3000"

    puts ""
    puts "🌐 " + "HTTP activé (par défaut)".colorize(:blue) rescue puts "🌐 HTTP activé (par défaut)"
    puts "🔗 " + "Accédez à : http://localhost:3000".colorize(:cyan) rescue puts "🔗 Accédez à : http://localhost:3000"
    puts ""
    puts "💡 " + "Modes disponibles :".colorize(:yellow) rescue puts "💡 Modes disponibles :"
    puts "   HTTP simple      : rails server"
    puts "   HTTPS            : USE_SSL=true rails server"
    puts "   HTTP + SMTP      : USE_REAL_SMTP=true rails server"
    puts "   HTTPS + SMTP     : USE_SSL=true USE_REAL_SMTP=true rails server"
    puts ""
  end

else
  # ===============================================
  # CONFIGURATION PRODUCTION
  # ===============================================

  bind "tcp://0.0.0.0:#{ENV.fetch('PORT') { 3000 }}"
  puts "🏭 Configuration production activée"
end

# ===============================================
# PLUGINS ET CONFIGURATION SUPPLÉMENTAIRE
# ===============================================

# Allow puma to be restarted by `bin/rails restart` command.
plugin :tmp_restart

# Configuration additionnelle pour développement
if ENV.fetch("RAILS_ENV", "development") == "development"

  # Timeout plus long en développement pour le debugging
  worker_timeout 3600

  puts "🔧 Configuration développement Puma appliquée"
  puts "=" * 60
end
