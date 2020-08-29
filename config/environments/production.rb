
Mnygo::Application.configure do

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true
  config.eager_load= true 

  config.assets.compile = false
  config.assets.digest = true
  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  
   
  # Compress JavaScripts and CSS.
  config.assets.js_compressor = Uglifier.new(harmony:true)
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  config.log_level = :debug

 
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
  
  config.exceptions_app = ->(env) { ExceptionsController.action(:show).call(env) }

  config.action_mailer.delivery_method = :smtp


  config.active_storage.service = :amazon 
  
  config.action_mailer.smtp_settings = {
    address:              'smtp.gmail.com',
    port:                 587,
    domain:               'gmail.com',
    user_name:            'wds.report.tpereda@gmail.com',
    password:             'wpjngmnqcrppgxws',
    authentication:       :plain,
    enable_starttls_auto: true  }


end
