Mnygo::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  config.cache_classes = false
  
  config.eager_load = false   
  
  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true
  config.assets.debug = false
  # Show full error reports and disable caching
  
  config.consider_all_requests_local       = false
  #config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  config.action_mailer.delivery_method = :smtp
  
  config.action_mailer.default_url_options = {:host=>'localhost:3000',protocol: 'http'}

  config.action_controller.include_all_helpers = false

  config.force_ssl = false
  
 
 config.action_mailer.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    domain:               'gmail.com',
    user_name:            'wds.report.tpereda@gmail.com',
    password:             'wpjngmnqcrppgxws',
    authentication:       'plain',
    enable_starttls_auto: true  }


  #BetterErrors::Middleware.allow_ip! "0.0.0.0/0"
  
  config.web_console.whitelisted_ips = ['10.0.0.0/8', '172.16.0.0/12', '192.168.0.0/16','148.102.0.0/16','167.250.205.154','190.8.128.0/16']

  
  end
