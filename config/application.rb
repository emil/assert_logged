require_relative 'boot'

require 'rails/all'
#log4r requirements

require 'log4r'
require 'log4r/yamlconfigurator'
require 'log4r/outputter/datefileoutputter'
require 'log4r/outputter/syslogoutputter'
include Log4r

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MyAwesomeApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # assign log4r's logger as rails' logger.
    log_cfg = YamlConfigurator
    log_cfg['Rails.root'] = Rails.root.to_s
    log_cfg['Rails.env'] = Rails.env.to_s || 'development'
    log_cfg.load_yaml_file(File.join(File.dirname(__FILE__),"log4r_#{Rails.env}.yml"))
    config.logger = Log4r::Logger['bugs_app']

    # see gems/railties-5.1.4/lib/rails/commands/server/server_command.rb:83, method log_to_stdout
    # requires 'formatter' to be defined at the logger.
    config.logger.class_eval do
      def formatter
        # Give it the first formatter we have?
        outputters.collect {|o| o.formatter}.compact.first
      end
    
    ActiveRecord::Base.logger = Log4r::Logger['rails']
    end

  end
end
