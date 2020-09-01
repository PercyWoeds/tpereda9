require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Mnygo
  class Application < Rails::Application
    
    
    config.assets.precompile += %w( *.js *.css )
    config.assets.precompile = ['.js', '.css', '*.css.erb']
    
    config.encoding = "utf-8"
    config.assets.initialize_on_precompile = false
    config.serve_static_files = true
    
    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    config.time_zone ='Lima'
    config.exceptions = self.routes
    config.enable_dependency_loading= true
    config.autoload_paths << Rails.root.join('lib')
   config.active_job.queue_adapter =  :sidekiq 
   
     # config.web_console.whitelisted_ips = '192.168.0.0/16'

     # config.web_console.permissions = '192.168.0.0/16'
     # config.web_console.permissions = '127.0.0.1/16'
     
     # config.web_console.whiny_requests = false
     # config.web_console.template_paths = 'app/views/web_console'
     # config.web_console.mount_point = '/path/to/web_console'

  end

  class String
  def to_d
    begin
      BigDecimal(self)
    rescue ArgumentError
      BigDecimal(0)
    end
  end
end

end
